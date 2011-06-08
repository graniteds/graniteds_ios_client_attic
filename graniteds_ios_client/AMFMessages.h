/*
 
    Project : GraniteDS iOS Client
    File    : AMFMessage.h
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


/*
 
 THIS CLASS ISN'T USED YET IN THE PROJECT. THIS IS A WORK IN PROGRESS IN ORDER
 TO IMPROVE AMF3 SERIALIZATION.
 
*/

#ifndef __AMFMESSAGE_H__
#define __AMFMESSAGE_H__


#import <Foundation/Foundation.h>

@protocol GDSRemoteClass;


////////////////////////////////////////////////////////////////////////////////
#pragma mark -

@protocol AMFMessage <NSObject, GDSRemoteClass>

@required

#pragma mark Properties

@property (nonatomic, retain) NSObject *body;
@property (nonatomic, retain) NSObject *clientId;
@property (nonatomic, retain) NSString *destination;
@property (nonatomic, retain) NSMutableDictionary *headers;
@property (nonatomic, retain) NSString *messageId;
@property (nonatomic, assign) NSTimeInterval timeToLive;
@property (nonatomic, assign) NSTimeInterval timestamp;

#pragma mark Header Utilities

- (BOOL)headerValueExistsForKey:(NSString *)key;
- (NSObject *)headerValueForKey:(NSString *)key;
- (void)setHeaderValue:(NSObject *)value forKey:(NSString *)key;

@end


////////////////////////////////////////////////////////////////////////////////
#pragma mark -

@interface AMFAbstractMessage : NSObject <AMFMessage> {

    NSObject *_body;
    NSObject *_clientId;
    NSString *_destination;
    NSMutableDictionary *_headers;
    NSString *_messageId;
    NSTimeInterval _timeToLive;
    NSTimeInterval _timestamp;
}

#pragma mark Constants

+ (NSString *)ENDPOINT_HEADER;
+ (NSString *)REMOTE_CREDENTIALS_HEADER;
+ (NSString *)DS_ID_HEADER;

@end


////////////////////////////////////////////////////////////////////////////////
#pragma mark -

@interface AMFAsyncMessage : AMFAbstractMessage {
    
    NSString *_correlationId;
}

#pragma mark Constants

+ (NSString *)SUBTOPIC_HEADER;
+ (NSString *)DESTINATION_CLIENT_ID_HEADER;

#pragma mark Properties

@property (nonatomic, retain) NSString *correlationId;

@end


////////////////////////////////////////////////////////////////////////////////
#pragma mark -

@interface AMFCommandMessage : AMFAsyncMessage


@end


#endif

