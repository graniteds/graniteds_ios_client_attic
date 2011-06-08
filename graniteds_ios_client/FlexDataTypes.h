/*
 
    Project : GraniteDS iOS Client
    File    : FlexDataTypes.h
    Author  : Marc BAUER
 
    Original code from https://github.com/nesium/cocoa-amf/ with the following
    license:

    ------------------------------------------------------------------------------

    CocoaAMF is available under the terms of the MIT license. The full text of the
    MIT license is included below.

    MIT License
    ===========

    Copyright (c) 2008-2009 Marc Bauer. All rights reserved.

    Permission is hereby granted, free of charge, to any person obtaining a copy
    of this software and associated documentation files (the "Software"), to deal
    in the Software without restriction, including without limitation the rights
    to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
    copies of the Software, and to permit persons to whom the Software is
    furnished to do so, subject to the following conditions:

    The above copyright notice and this permission notice shall be included in all
    copies or substantial portions of the Software.

    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
    IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
    FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
    AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
    LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
    OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
    SOFTWARE. 
 
*/

#ifndef __FLEXDATATYPES_H__
#define __FLEXDATATYPES_H__


#import <Foundation/Foundation.h>

#import "NSObject-AMFExtensions.h"

#if TARGET_OS_IPHONE
#import "NSObject-iPhoneExtensions.h"
#endif

typedef enum _FlexCommandMessageOperationType
{
	kFlexCommandMessageSubscribeOperation = 0, 
	kFlexCommandMessageUnsubscribeOperation = 1, 
	kFlexCommandMessagePollOperation = 2, 
	kFlexCommandMessageClientSyncOperation = 4, 
	kFlexCommandMessageClientPingOperation = 5, 
	kFlexCommandMessageClusterRequestOperation = 7, 
	kFlexCommandMessageLoginOperation = 8, 
	kFlexCommandMessageLogoutOperation = 9, 
	kFlexCommandMessageSubscriptionInvalidateOperation = 10, 
	kFlexCommandMessageMultiSubscribeOperation = 11, 
	kFlexCommandMessageDisconnectOperation = 12, 
	kFlexCommandMessageTriggerConnectOperation = 13, 
	kFlexCommandMessageUnknownOperation = 1000
} FlexCommandMessageOperationType;


@interface FlexArrayCollection : NSObject <NSCoding>
{
	NSArray *source;
}
@property (nonatomic, retain) NSArray *source;
+ (NSString *)AMFClassAlias;
- (id)initWithSource:(NSArray *)obj;
- (NSUInteger)count;
@end


@interface FlexObjectProxy : NSObject <NSCoding>
{
	NSObject *object;
}
@property (nonatomic, retain) NSObject *object;
+ (NSString *)AMFClassAlias;
- (id)initWithObject:(NSObject *)obj;
@end


@interface FlexAbstractMessage : NSObject <NSCoding>
{
	NSObject *body;
	NSString *clientId;
	NSString *destination;
	NSDictionary *headers;
	NSString *messageId;
	NSTimeInterval timeToLive;
	NSTimeInterval timestamp;
}
@property (nonatomic, retain) NSObject *body;
@property (nonatomic, retain) NSString *clientId;
@property (nonatomic, retain) NSString *destination;
@property (nonatomic, retain) NSDictionary *headers;
@property (nonatomic, retain) NSString *messageId;
@property (nonatomic, assign) NSTimeInterval timeToLive;
@property (nonatomic, assign) NSTimeInterval timestamp;
+ (NSString *)AMFClassAlias;
@end


@interface FlexAsyncMessage : FlexAbstractMessage
{
	NSString *correlationId;
}
@property (nonatomic, retain) NSString *correlationId;
@end


@interface FlexCommandMessage : FlexAsyncMessage
{
	FlexCommandMessageOperationType operation;
}
@property (nonatomic, assign) FlexCommandMessageOperationType operation;
@end


@interface FlexAcknowledgeMessage : FlexAsyncMessage
{
}
@end


@interface FlexErrorMessage : FlexAcknowledgeMessage
{
	NSObject *extendedData;
	NSString *faultCode;
	NSString *faultDetail;
	NSString *faultString;
	NSObject *rootCause;
}
@property (nonatomic, retain) NSObject *extendedData;
@property (nonatomic, retain) NSString *faultCode;
@property (nonatomic, retain) NSString *faultDetail;
@property (nonatomic, retain) NSString *faultString;
@property (nonatomic, retain) NSObject *rootCause;
+ (FlexErrorMessage *)errorMessageWithError:(NSError *)error;
@end


@interface FlexRemotingMessage : FlexAbstractMessage
{
	NSString *operation;
	NSString *source;
}
@property (nonatomic, retain) NSString *operation;
@property (nonatomic, retain) NSString *source;
@end


#endif
