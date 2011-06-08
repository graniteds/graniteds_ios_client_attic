/*
 
    Project : GraniteDS iOS Client
    File    : GDSChannelNotification.h
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

#ifndef __GDSCHANNELNOTIFICATION_H__
#define __GDSCHANNELNOTIFICATION_H__


#import <Foundation/Foundation.h>

@class GDSChannel;


extern NSString *const GDSChannelNotificationName;

extern NSString *const kGDSChannelNotificationLevel;
extern NSString *const kGDSChannelNotificationMessage;
extern NSString *const kGDSChannelNotificationError;
extern NSString *const kGDSChannelNotificationException;

typedef enum
{
    kGDSChannelNoticationLevelInfo,
    kGDSChannelNoticationLevelWarning,
    kGDSChannelNoticationLevelError
}
GDSChannelNoticationLevel;

/**
 *
 *
 * @author Franck WOLFF
 */
@interface GDSChannelNotification : NSNotification {

    GDSChannel *m_channel;
    GDSChannelNoticationLevel m_level;
    NSString *m_message;
    NSError *m_error;
    NSException *m_exception;
    
    NSDictionary *m_userInfo;
}


#pragma mark -
#pragma mark Properties

@property (readonly) GDSChannel *channel;
@property (readonly) GDSChannelNoticationLevel level;
@property (readonly) NSString *message;
@property (readonly) NSError *error;
@property (readonly) NSException *exception;


#pragma mark -
#pragma mark Initialization

+(void)postWithChannel:(GDSChannel *)channel
                 level:(GDSChannelNoticationLevel)level
               message:(NSString *)message;

+(void)postWithChannel:(GDSChannel *)channel
                 level:(GDSChannelNoticationLevel)level
               message:(NSString *)message
                 error:(NSError *)error;

+(void)postWithChannel:(GDSChannel *)channel
                 level:(GDSChannelNoticationLevel)level
               message:(NSString *)message
             exception:(NSException *)exception;


#pragma mark -
#pragma mark Notification Types

- (BOOL)hasError;
- (BOOL)hasException;
- (BOOL)isHTTPError;

#pragma mark -
#pragma mark NSNotification Implementation

- (NSString *)name;
- (id)object;
- (NSDictionary *)userInfo;

@end


#endif

