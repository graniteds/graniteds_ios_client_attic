/*
 
    Project : GraniteDS iOS Client
    File    : AMFMessage.m
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


#import "GDSRemoteProtocols.h"
#import "AMFMessages.h"

#import "GDSUtil.h"


////////////////////////////////////////////////////////////////////////////////

@implementation AMFAbstractMessage

#pragma mark - Constants

+ (NSString *)__gds__remoteClassAlias
{
    return nil;
}

+ (NSString *)ENDPOINT_HEADER
{
    return @"DSEndpoint";
}

+ (NSString *)REMOTE_CREDENTIALS_HEADER
{
    return @"DSRemoteCredentials";
}

+ (NSString *)DS_ID_HEADER
{
    return @"DSId";
}

#pragma mark - Properties

@synthesize body=_body;
@synthesize clientId=_clientId;
@synthesize destination=_destination;
@synthesize headers=_headers;
@synthesize messageId=_messageId;
@synthesize timeToLive=_timeToLive;
@synthesize timestamp=_timestamp;

#pragma mark - Initialization & Deallocation

- (id)init
{
	if ((self = [super init]))
	{
		self.messageId = [GDSUtil randomUUID];
		self.clientId = [GDSUtil randomUUID];
		self.timestamp = [[NSDate date] timeIntervalSince1970];
	}
	return self;
}

- (void)dealloc
{
    [_body release];
    [_clientId release];
    [_destination release];
    [_headers release];
    [_messageId release];
    
    [super dealloc];
}

#pragma mark - ASAliasedClass (NSCoding) Implementation

- (id)initWithCoder:(NSCoder *)coder
{
	if ((self = [super init]))
	{
		self.body = [coder decodeObjectForKey:@"body"];
		self.clientId = [coder decodeObjectForKey:@"clientId"];
		self.destination = [coder decodeObjectForKey:@"destination"];
		self.headers = [coder decodeObjectForKey:@"headers"];
		self.messageId = [coder decodeObjectForKey:@"messageId"];
		self.timeToLive = [coder decodeInt32ForKey:@"timeToLive"] / 1000;
		self.timestamp = [coder decodeDoubleForKey:@"timestamp"] / 1000;
	}
	return self;
}

- (void)encodeWithCoder:(NSCoder *)coder
{
	[coder encodeObject:_body forKey:@"body"];
	[coder encodeObject:_clientId forKey:@"clientId"];
	[coder encodeObject:_destination forKey:@"destination"];
	[coder encodeObject:_headers forKey:@"headers"];
	[coder encodeObject:_messageId forKey:@"messageId"];
	[coder encodeDouble:(_timeToLive * 1000) forKey:@"timeToLive"];
	[coder encodeDouble:(_timestamp * 1000) forKey:@"timestamp"];
}

#pragma mark - Headers Utilities

- (BOOL)headerValueExistsForKey:(NSString *)key
{
    return [self headerValueForKey:key] != nil;
}

- (NSObject *)headerValueForKey:(NSString *)key
{
    if (_headers != nil)
        return [_headers valueForKey:key];
    return nil;
}

- (void)setHeaderValue:(NSObject *)value forKey:(NSString *)key
{
    if (_headers == nil)
        _headers = [[NSMutableDictionary alloc] init];
    [_headers setValue:value forKey:key];
}

#pragma mark - Description

- (NSString *)descriptionWithObjectsAndKeys:(NSArray *)objectsAndKeys
{
    NSMutableString *desc = [NSMutableString string];
    
    [desc appendFormat:@""];
    
	return [NSString stringWithFormat:
@"<%@ = 0x%08x> {\n\
    destination = %@,\n\
    headers =\n\
        %@,\n\
    messageId = %@,\n\
    timestamp = %f,\n\
    clientId = %@,\n\
    timeToLive = %f,\n\
    body =\n\
        %@\n\
}",
            NSStringFromClass([self class]), (long)self,
            _destination,
            _clientId, 
            _messageId,
            _timeToLive,
            _timestamp,
            _headers,
            _body];
}

@end


////////////////////////////////////////////////////////////////////////////////
#pragma mark -

@implementation AMFAsyncMessage

@synthesize correlationId=_correlationId;

+ (NSString *)__gds__remoteClassAlias
{
    return @"flex.messaging.messages.AMFAsyncMessage";
}

+ (NSString *)SUBTOPIC_HEADER
{
    return @"DSSubtopic";
}

+ (NSString *)DESTINATION_CLIENT_ID_HEADER
{
    return @"DSDstClientId";
}

- (void)dealloc
{
    [_correlationId release];
    
    [super dealloc];
}

@end

