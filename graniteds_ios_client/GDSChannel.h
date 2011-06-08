/*
 
    Project : GraniteDS iOS Client
    File    : GDSChannel.h
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

#ifndef __GDSCHANNEL_H__
#define __GDSCHANNEL_H__


#import <Foundation/Foundation.h>

@class GDSXAMFRequest;
@class GDSAsyncResponder;
@class GDSAsyncToken;


/**
 *
 *
 * @author Franck WOLFF
 */
@interface GDSChannel : NSObject {

    NSString *m_id;
    NSURL *m_URL;
    NSString *m_credentials;
    
    BOOL m_connected;
    BOOL m_authenticated;
    
    NSTimeInterval m_timeout;

    NSMutableArray *m_pendingTokens;
    NSMutableArray *m_sentTokens;
    
    GDSXAMFRequest *m_request;
}

#pragma mark -
#pragma mark Properties

@property (readwrite, retain) NSString *id;
@property (readwrite, retain) NSURL *URL;
@property (readonly) BOOL connected;
@property (readonly) BOOL authenticated;
@property (readwrite) NSTimeInterval timeout;

#pragma mark -
#pragma mark Initialization

+ (id)channelWithId:(NSString *)id url:(NSURL *)url;

- (id)initWithId:(NSString *)id url:(NSURL *)url;

#pragma mark -
#pragma mark Login & Logout Methods

- (void)setCredentials:(NSString *)credentials;

- (void)logoutWithResponder:(GDSAsyncResponder *)responder;

#pragma mark -
#pragma mark Send, Cancel & Restart Method

- (void)sendToken:(GDSAsyncToken *)token;

- (void)cancelRequest;

- (void)clearPendingToken;

- (void)sendPendingToken;

@end


#endif

