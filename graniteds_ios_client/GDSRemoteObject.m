/*
 
    Project : GraniteDS iOS Client
    File    : GDSRemoteObject.m
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

#import "GDSChannel.h"
#import "GDSAsyncResponder.h"

#import "GDSRemoteObject.h"

#import "FlexDataTypes.h"
#import "GDSAsyncToken.h"

@implementation GDSRemoteObject

#pragma mark -
#pragma mark Properties

@synthesize channel=m_channel;
@synthesize destination=m_destination;

- (BOOL)authenticated
{
    return [m_channel authenticated];
}

#pragma mark -
#pragma mark Initialization & Deallocation

+(id)remoteObjectWithChannel:(GDSChannel *)channel destination:(NSString *)destination
{
    return [[[GDSRemoteObject alloc] initWithChannel:channel destination:destination] autorelease];
}

-(id)initWithChannel:(GDSChannel *)channel destination:(NSString *)destination
{
    if (channel == nil || destination == nil)
        @throw [NSException exceptionWithName:NSInvalidArgumentException
                                       reason:@"Parameters channel and destination cannot be null"
                                     userInfo:nil];
    if ((self = [self init]))
	{
        m_channel = [channel retain];
        m_destination = [destination retain];
    }

    return self;
}

- (void)dealloc
{
    [m_channel release];
    [m_destination release];
    
    [super dealloc];
}

#pragma mark -
#pragma mark Login & Logout Methods

- (void)setCredentialsWithUsername:(NSString *)username password:(NSString *)password
{
    if (username == nil && password == nil)
        [m_channel setCredentials:nil];
    else
        [m_channel setCredentials:[NSString stringWithFormat:@"%@:%@", username, password]];
}

- (void)logoutWithTarget:(id)target result:(SEL)result  fault:(SEL)fault
{
    GDSAsyncResponder *responder = [GDSAsyncResponder responderWithTarget:target result:result fault:fault];
    [self logoutWithResponder:responder];
}

- (void)logoutWithResponder:(GDSAsyncResponder *)responder
{
    [m_channel logoutWithResponder:responder];
}

#pragma mark -
#pragma mark Remote Call Methods

-(void)callMethod:(NSString *)method target:(id)target result:(SEL)result
{
    GDSAsyncResponder *responder = [GDSAsyncResponder responderWithTarget:target result:result fault:nil];
    [self callMethod:method arguments:nil responders:[NSArray arrayWithObject:responder]];
}

-(void)callMethod:(NSString *)method arguments:(NSArray *)arguments target:(id)target result:(SEL)result
{
    GDSAsyncResponder *responder = [GDSAsyncResponder responderWithTarget:target result:result fault:nil];
    [self callMethod:method arguments:arguments responders:[NSArray arrayWithObject:responder]];
}


-(void)callMethod:(NSString *)method target:(id)target result:(SEL)result fault:(SEL)fault
{
    GDSAsyncResponder *responder = [GDSAsyncResponder responderWithTarget:target result:result fault:fault];
    [self callMethod:method arguments:nil responders:[NSArray arrayWithObject:responder]];
}

-(void)callMethod:(NSString *)method arguments:(NSArray *)arguments target:(id)target result:(SEL)result fault:(SEL)fault
{
    GDSAsyncResponder *responder = [GDSAsyncResponder responderWithTarget:target result:result fault:fault];
    [self callMethod:method arguments:arguments responders:[NSArray arrayWithObject:responder]];
}


-(void)callMethod:(NSString *)method responder:(GDSAsyncResponder *)responder
{
    [self callMethod:method arguments:nil responders:(responder ? [NSArray arrayWithObject:responder] : nil)];
}

-(void)callMethod:(NSString *)method arguments:(NSArray *)arguments responder:(GDSAsyncResponder *)responder
{
    [self callMethod:method arguments:arguments responders:(responder ? [NSArray arrayWithObject:responder] : nil)];
}


-(void)callMethod:(NSString *)method responders:(NSArray *)responders
{
    [self callMethod:method arguments:nil responders:responders];
}

-(void)callMethod:(NSString *)method arguments:(NSArray *)arguments responders:(NSArray *)responders
{
    if (method == nil)
        @throw [NSException exceptionWithName:NSInvalidArgumentException
                                       reason:@"Parameter method cannot be null"
                                     userInfo:nil];

    FlexRemotingMessage *message = [[FlexRemotingMessage alloc] init];
    [message setBody:(arguments ? arguments : [NSArray arrayWithObjects: nil])];
    [message setOperation:method];
    [message setDestination:m_destination];
    
    GDSAsyncToken *token = [GDSAsyncToken tokenWithMessage:message];
    if (responders != nil)
    {
        const NSUInteger count = [responders count];
        for (NSUInteger i = 0; i < count; i++)
        {
            GDSAsyncResponder *responder = [responders objectAtIndex:i];
            if (responder != nil)
                [token addResponder:responder];
        }
    }
    
    [m_channel sendToken:token];
    
    [message release];
}

@end
