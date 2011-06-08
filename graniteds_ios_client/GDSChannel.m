/*
 
    Project : GraniteDS iOS Client
    File    : GDSChannel.m
    Author  : Franck WOLFF
 
    ------------------------------------------------------------------------------

    GRANITE DATA SERVICES
    Copyright (C) 2011 GRANITE DATA SERVICES S.A.S.

    This file is part of Granite Data Services.

    Granite Data Services is free software; you can redistribute it and/or modify
    it under the terms of the GNU Library General Public License as published by
    the Free Software Foundation; either version 2 of the License, or (at your
    option) any later version.

    Granite Data Services is distributed in the hope that it will be useful, but
    WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
    FITNESS FOR A PARTICULAR PURPOSE. See the GNU Library General Public License
    for more details.

    You should have received a copy of the GNU Library General Public License
    along with this library; if not, see <http://www.gnu.org/licenses/>.
 
*/

#import "GDSXAMFRequest.h"
#import "GDSAsyncResponder.h"
#import "GDSAsyncToken.h"

#import "GDSChannel.h"

#import "GDSUtil.h"
#import "AMFActionMessage.h"
#import "GDSAbstractEvent.h"
#import "GDSResultEvent.h"
#import "GDSFaultEvent.h"
#import "GDSChannelNotification.h"


/**
 * @author Franck WOLFF
 */
@interface GDSChannel (Private)

#pragma mark -
#pragma mark GDSChannel Private Methods

- (BOOL)_atomicSendRequest:(NSData *)data result:(SEL)result fault:(SEL)fault;
- (void)_atomicReleaseRequest:(BOOL)sendPendingTokens;

- (void)_sendPendingTokens;
- (void)_sendPendingTokensResult:(NSData *)data;
- (void)_sendPendingTokensFault:(NSError *)error;

- (void)_connect;
- (void)_connectResult:(NSData *)data;
- (void)_connectFault:(NSError *)error;

- (GDSAsyncToken *)_createLoginToken;
- (void)_loginResult:(GDSResultEvent *)event;
- (void)_loginFault:(GDSFaultEvent *)event;

- (AMFActionMessage *)_createAMF0MessageWithMessage:(FlexAbstractMessage *)message;
- (AMFActionMessage *)_createAMF0MessageWithMessages:(NSArray *)messages;

#pragma mark -

@end



@implementation GDSChannel

#pragma mark -
#pragma mark Properties

@synthesize id=m_id;
@synthesize URL=m_URL;
@synthesize connected=m_connected;
@synthesize authenticated=m_authenticated;
@synthesize timeout=m_timeout;

static uint32_t g_responseIndex = 1;

#pragma mark -
#pragma mark Initialization & Deallocation

+ (id)channelWithId:(NSString *)id url:(NSURL *)url
{
	return [[[GDSChannel alloc] initWithId:id url:url] autorelease];
}

- (id)init
{
	if ((self = [super init]))
	{
        m_id = nil;
        m_URL = nil;
        m_credentials = nil;
        
        m_connected = NO;
        m_authenticated = NO;
        
        m_timeout = 60;
        
        m_pendingTokens = [[NSMutableArray alloc] init];
        m_sentTokens = nil;
        
        m_request = nil;
	}
	return self;
}

- (id)initWithId:(NSString *)id url:(NSURL *)url
{
	if ((self = [self init]))
	{
        [self setId:id];
        [self setURL:url];
	}
	return self;
}

- (void)dealloc
{
	[m_id release];
	[m_URL release];
    [m_credentials release];

    [m_pendingTokens release];
    [m_sentTokens release];
    
	[m_request release];

	[super dealloc];
}

#pragma mark -
#pragma mark Login & Logout Methods

- (void)setCredentials:(NSString *)credentials
{
    if (m_credentials != nil) {
        [m_credentials release];
        m_credentials = nil;
    }
    if (credentials != nil)
        m_credentials = [[GDSUtil encodeBase64:credentials] retain];
}

- (void)logoutWithResponder:(GDSAsyncResponder *)responder
{
    m_authenticated = NO;
    if (m_credentials != nil) {
        [m_credentials release];
        m_credentials = nil;
    }
    
    FlexCommandMessage *message = [[[FlexCommandMessage alloc] init] autorelease];
    
    [message setOperation:kFlexCommandMessageLogoutOperation];
    
    GDSAsyncToken *token = [[GDSAsyncToken alloc] initWithMessage:message];
    if (responder != nil)
        [token addResponder:responder];
    
    [self sendToken:token];
}

#pragma mark -
#pragma mark Send, Cancel & Restart Method

- (void)sendToken:(GDSAsyncToken *)token
{
    if (token == nil)
        @throw [NSException exceptionWithName:NSInvalidArgumentException
                                       reason:@"Parameter token cannot be null"
                                     userInfo:nil];
    @synchronized (self)
    {
        [m_pendingTokens addObject:token];
    }
    
    [self _sendPendingTokens];
}

- (void)cancelRequest
{
    @synchronized (self)
    {
        if (m_request != nil)
        {
            [m_request cancel];
            [m_request release];
            m_request = nil;
        }
        if (m_sentTokens != nil)
        {
            [m_sentTokens release];
            m_sentTokens = nil;
        }
    }
}

- (void)clearPendingToken
{
    @synchronized (self)
    {
        [m_pendingTokens release];
        m_pendingTokens = [[NSMutableArray alloc] init];
    }
}

- (void)sendPendingToken
{
    [self _sendPendingTokens];
}

#pragma mark -
#pragma mark Private Send Methods

- (BOOL)_atomicSendRequest:(NSData *)data result:(SEL)result fault:(SEL)fault
{
    @synchronized (self)
    {
        if (m_request == nil)
        {
            m_request = [[GDSXAMFRequest alloc] initWithURL:[self URL]
                                                       body:data
                                                     target:self
                                                     result:result
                                                      fault:fault
                                                    timeout:m_timeout];
            return YES;
        }
    }
    
    return NO;
}
- (void)_atomicReleaseRequest:(BOOL)sendPendingTokens
{
    @synchronized (self)
    {
        if (m_request != nil)
        {
            [m_request release];
            m_request = nil;
        }
    }

    if (sendPendingTokens)
        [self _sendPendingTokens];
}

- (void)_sendPendingTokens
{
    @synchronized (self)
    {
        if (m_request != nil || [m_pendingTokens count] == 0)
            return;
        
        if (!m_connected)
        {
            [self _connect];
            return;
        }

        if (!m_authenticated && m_credentials != nil)
            [m_pendingTokens insertObject:[self _createLoginToken] atIndex:(NSUInteger)0];
        
        NSMutableArray *messages = [[[NSMutableArray alloc] init] autorelease];
        const NSUInteger count = [m_pendingTokens count];
        for (NSUInteger i = 0; i < count; i++)
        {
            GDSAsyncToken *token = [m_pendingTokens objectAtIndex:(NSUInteger)i];
            FlexAbstractMessage *message = [token message];
            if (m_id != nil)
            {
                if (message.headers == nil)
                    message.headers = [[NSMutableDictionary alloc] initWithCapacity:1];
                [message.headers setValue:m_id forKey:@"DSEndpoint"];
            }
            [messages addObject:message];
        }
        m_sentTokens = m_pendingTokens;
        m_pendingTokens = [[NSMutableArray alloc] init];
        
        AMFActionMessage * amf0 = [self _createAMF0MessageWithMessages:messages];
        @try {
            NSData *data = [amf0 data];
            [self _atomicSendRequest:data result:@selector(_sendPendingTokensResult:) fault:@selector(_sendPendingTokensFault:)];
        }
        @catch (NSException *exception) {
            [GDSChannelNotification postWithChannel:self
                                              level:kGDSChannelNoticationLevelError
                                            message:@"AMF serialization failed"
                                          exception:exception];
            return;
        }
        @finally {
            [amf0 release];
        }
    }
}

- (void)_sendPendingTokensResult:(NSData *)data
{    
    AMFActionMessage *message = nil;
    @try {
        message = [[AMFActionMessage alloc] initWithData:data];
        NSArray *responses = [message bodies];
        
        const NSUInteger count = [responses count];
        
        if ([m_sentTokens count] != count)
        {
            NSString *message = [NSString stringWithFormat:@"Received %d response(s) for %d request(s)",
                                 count, [m_sentTokens count]];
            [GDSChannelNotification postWithChannel:self
                                              level:kGDSChannelNoticationLevelError
                                            message:message];
            return;
        }
        
        for (NSUInteger i = 0; i < count; i++)
        {
            NSObject *object = [[responses objectAtIndex:i] data];
            GDSAsyncToken *token = [m_sentTokens objectAtIndex:i];
            
            if ([object isKindOfClass:[FlexAsyncMessage class]])
            {
                FlexAsyncMessage *response = (FlexAsyncMessage *)object;
                
                if ([[[token message] messageId] isEqualToString:[response correlationId]])
                {
                    GDSAbstractEvent *event = nil;
                    if ([response isKindOfClass:[FlexErrorMessage class]])
                        event = [GDSFaultEvent initWithToken:token response:(FlexErrorMessage *)response];
                    else if ([response isKindOfClass:[FlexAcknowledgeMessage class]])
                        event = [GDSResultEvent initWithToken:token response:(FlexAcknowledgeMessage *)response];
                    else
                    {
                        NSString *message = [NSString stringWithFormat:@"Unknown response message type: %@", response];
                        [GDSChannelNotification postWithChannel:self
                                                          level:kGDSChannelNoticationLevelError
                                                        message:message];
                    }
                    [token callResponders:event];
                }
                else
                {
                    NSString *message = [NSString stringWithFormat:@"Bad correlation id: %@ (should be: %@)",
                                         [response correlationId], [[token message] messageId]];
                    [GDSChannelNotification postWithChannel:self
                                                      level:kGDSChannelNoticationLevelError
                                                    message:message];
                }
            }
            else
            {
                NSString *message = [NSString stringWithFormat:@"Unknown response message type: %@", object];
                [GDSChannelNotification postWithChannel:self
                                                  level:kGDSChannelNoticationLevelError
                                                message:message];
            }
        }
    }
    @catch (NSException *exception) {
        [GDSChannelNotification postWithChannel:self
                                          level:kGDSChannelNoticationLevelError
                                        message:@"AMF deserialization failed"
                                      exception:exception];
        return;
    }
    @finally {
        [message release];
        [m_sentTokens release];
        m_sentTokens = nil;
        
        [self _atomicReleaseRequest:YES];
    }
}
- (void)_sendPendingTokensFault:(NSError *)error
{
    [m_sentTokens release];
    m_sentTokens = nil;

    [self _atomicReleaseRequest:NO];
    
    NSString *message = [NSString stringWithFormat:@"Request failed to URL: %@", m_URL];
    [GDSChannelNotification postWithChannel:self
                                      level:kGDSChannelNoticationLevelError
                                    message:message
                                      error:error];
}


#pragma mark -
#pragma mark Private Connect Methods (PING)

- (void)_connect
{
    FlexCommandMessage *message = [[[FlexCommandMessage alloc] init] autorelease];
    [message setOperation:kFlexCommandMessageClientPingOperation];
    [message setHeaders:[NSDictionary dictionaryWithObjectsAndKeys:
        @"1", @"DSMessagingVersion",
        @"nil", @"DSId",
        nil
    ]];
    [message setBody:[NSArray arrayWithObjects: nil]];
    
    AMFActionMessage *amf0 = [self _createAMF0MessageWithMessage:message];
    @try {
        NSData *data = [amf0 data];
        [self _atomicSendRequest:data result:@selector(_connectResult:) fault:@selector(_connectFault:)];
    }
    @catch (NSException *exception) {
        [GDSChannelNotification postWithChannel:self
                                          level:kGDSChannelNoticationLevelError
                                        message:@"AMF serialization failed"
                                      exception:exception];
        return;
    }
    @finally {
        [amf0 release];
    }
    
    
}

- (void)_connectResult:(NSData *)data
{
    m_connected = NO;
    
    AMFActionMessage *message = nil;
    @try {
        message = [[AMFActionMessage alloc] initWithData:data];
        NSArray *responses = [message bodies];
        
        if ([responses count] != 1)
        {
            [GDSChannelNotification postWithChannel:self
                                              level:kGDSChannelNoticationLevelError
                                            message:@"Server sent an empty response to connect"];
            return;
        }
        
        NSObject *object = [[responses objectAtIndex:0] data];
        
        if ([object isKindOfClass:[FlexErrorMessage class]]) {
            NSString *message = [NSString stringWithFormat:@"Server sent an error response to connect: %@", object];
            [GDSChannelNotification postWithChannel:self
                                              level:kGDSChannelNoticationLevelError
                                            message:message];
            return;
        }
        
        m_connected = YES;
    }
    @catch (NSException *exception) {
        [GDSChannelNotification postWithChannel:self
                                          level:kGDSChannelNoticationLevelError
                                        message:@"AMF deserialization failed"
                                      exception:exception];
        return;
    }
    @finally {
        [message release];
        [self _atomicReleaseRequest:YES];
    }
}
- (void)_connectFault:(NSError *)error
{
    m_connected = NO;
	
    [self _atomicReleaseRequest:NO];
    
    [GDSChannelNotification postWithChannel:self
                                      level:kGDSChannelNoticationLevelError
                                    message:[NSString stringWithFormat:@"Request failed to URL: %@", m_URL]
                                      error:error];
}

#pragma mark -
#pragma mark Private Login Methods

- (GDSAsyncToken *)_createLoginToken
{
    FlexCommandMessage *message = [[[FlexCommandMessage alloc] init] autorelease];
    
    [message setOperation:kFlexCommandMessageLoginOperation];
    [message setBody:m_credentials];
    
    GDSAsyncToken *token = [GDSAsyncToken tokenWithMessage:message];
    [token addResponder:[GDSAsyncResponder responderWithTarget:self result:@selector(_loginResult:) fault:@selector(_loginFault:)]];
    return token;
}
- (void)_loginResult:(GDSResultEvent *)event
{
    m_authenticated = YES;
}

- (void)_loginFault:(GDSFaultEvent *)event
{
    m_authenticated = NO;
}

#pragma mark -
#pragma mark Private Utilities

- (AMFActionMessage *)_createAMF0MessageWithMessage:(FlexAbstractMessage *)message
{
    return [self _createAMF0MessageWithMessages:[NSArray arrayWithObject:message]];
}
- (AMFActionMessage *)_createAMF0MessageWithMessages:(NSArray *)messages
{
    AMFActionMessage *amf0 = [[AMFActionMessage alloc] init];
    const NSUInteger count = [messages count];
    for (NSUInteger i = 0; i < count; i++)
    {
        [amf0 addBodyWithTargetURI:@""
                       responseURI:[NSString stringWithFormat:@"/%d", g_responseIndex++]
                              data:[NSArray arrayWithObject:[messages objectAtIndex:i]]];
    }
    return amf0;
}

@end
