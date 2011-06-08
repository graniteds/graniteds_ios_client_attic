/*
 
    Project : GraniteDS iOS Client
    File    : GDSChannelNotification.m
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

#import "GDSChannelNotification.h"

NSString *const GDSChannelNotificationName = @"GDSChannelNotification";

NSString *const kGDSChannelNotificationChannel = @"GDSChannelNotificationChannel";
NSString *const kGDSChannelNotificationLevel = @"GDSChannelNotificationLevel";
NSString *const kGDSChannelNotificationMessage = @"GDSChannelNotificationMessage";
NSString *const kGDSChannelNotificationError = @"GDSChannelNotificationError";
NSString *const kGDSChannelNotificationException = @"GDSChannelNotificationException";

@interface GDSChannelNotification (Private)

#pragma mark -
#pragma mark GDSChannelNotification Private Methods

+(void)_postWithChannel:(GDSChannel *)channel
                 level:(GDSChannelNoticationLevel)level
               message:(NSString *)message
                 error:(NSError *)error
             exception:(NSException *)exception;

- (id)_initWithChannel:(GDSChannel *)channel
                level:(GDSChannelNoticationLevel)level
              message:(NSString *)message
                error:(NSError *)error
            exception:(NSException *)exception;

#pragma mark -

@end


@implementation GDSChannelNotification

#pragma mark -
#pragma mark Properties

@synthesize channel=m_channel;
@synthesize level=m_level;
@synthesize message=m_message;
@synthesize error=m_error;
@synthesize exception=m_exception;


#pragma mark -
#pragma mark Initialization

+(void)postWithChannel:(GDSChannel *)channel 
                 level:(GDSChannelNoticationLevel)level 
               message:(NSString *)message
{
    [GDSChannelNotification _postWithChannel:channel
                                       level:level
                                     message:message
                                       error:nil
                                   exception:nil];
}

+(void)postWithChannel:(GDSChannel *)channel
                 level:(GDSChannelNoticationLevel)level
               message:(NSString *)message
                 error:(NSError *)error
{
    [GDSChannelNotification _postWithChannel:channel
                                       level:level
                                     message:message
                                       error:error
                                   exception:nil];
}

+(void)postWithChannel:(GDSChannel *)channel
                 level:(GDSChannelNoticationLevel)level
               message:(NSString *)message
             exception:(NSException *)exception
{
    [GDSChannelNotification _postWithChannel:channel
                                       level:level
                                     message:message
                                       error:nil
                                   exception:exception];
}

#pragma mark -
#pragma mark Private Initialization & Deallocation

+(void)_postWithChannel:(GDSChannel *)channel
                  level:(GDSChannelNoticationLevel)level
                message:(NSString *)message
                  error:(NSError *)error
              exception:(NSException *)exception
{
    GDSChannelNotification *notification =
    [[[GDSChannelNotification alloc] _initWithChannel:channel
                                               level:level
                                             message:message
                                               error:error
                                           exception:exception] autorelease];
    
    [[NSNotificationQueue defaultQueue] enqueueNotification:notification
                                               postingStyle:NSPostASAP
                                               coalesceMask:NSNotificationNoCoalescing
                                                   forModes:nil];
}

- (id)_initWithChannel:(GDSChannel *)channel
                 level:(GDSChannelNoticationLevel)level
               message:(NSString *)message
                 error:(NSError *)error
             exception:(NSException *)exception
{
    if (channel == nil)
        @throw [NSException exceptionWithName:NSInvalidArgumentException
                                       reason:@"Parameter channel cannot be null"
                                     userInfo:nil];
    if (level < kGDSChannelNoticationLevelInfo || level > kGDSChannelNoticationLevelError)
        @throw [NSException exceptionWithName:NSInvalidArgumentException
                                       reason:@"Parameter level out of range"
                                     userInfo:nil];
    if (self)
    {
        m_channel = [channel retain];
        m_level = level;
        m_message = [message retain];
        m_error = [error retain];
        m_exception = [exception retain];
        
        NSMutableDictionary *userInfo = [NSMutableDictionary dictionaryWithObject:[NSNumber numberWithInt:level]
                                                                           forKey:kGDSChannelNotificationLevel];
        
        if (message != nil)
            [userInfo setValue:message forKey:kGDSChannelNotificationMessage];
        if (error != nil)
            [userInfo setValue:error forKey:kGDSChannelNotificationError];
        if (exception != nil)
            [userInfo setValue:exception forKey:kGDSChannelNotificationException];
        
        m_userInfo = [[NSDictionary dictionaryWithDictionary:userInfo] retain];
    }
    return self;
}

- (void)dealloc
{
    [m_channel release];
    [m_message release];
    [m_error release];
    [m_exception release];
    [m_userInfo release];
    
    [super dealloc];
}


#pragma mark -
#pragma mark Notification Type

- (BOOL)hasError
{
    return m_error != nil;
}
- (BOOL)hasException
{
    return m_exception != nil;
}
- (BOOL)isHTTPError
{
    return m_error != nil && [NSURLErrorDomain isEqualToString:[m_error domain]];
}

#pragma mark -
#pragma mark NSNotification Implementation

- (NSString *)name
{
    return GDSChannelNotificationName;
}

- (id)object
{
    return m_channel;
}

- (NSDictionary *)userInfo
{
    return m_userInfo;
}

@end
