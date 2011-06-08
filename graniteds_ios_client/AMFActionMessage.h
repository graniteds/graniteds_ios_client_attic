/*
 
    Project : GraniteDS iOS Client
    File    : AMFActionMessage.h
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

#ifndef __AMFACTIONMESSAGE_H__
#define __AMFACTIONMESSAGE_H__


#import <Foundation/Foundation.h>
#import "AMF.h"
#import "AMFArchiver.h"
#import "AMFUnarchiver.h"
#import "AMFDebugUnarchiver.h"

@class AMFMessageHeader, AMFMessageBody;

@interface AMFActionMessage : NSObject 
{
	AMFVersion m_version;
	NSMutableArray *m_headers;
	NSMutableArray *m_bodies;
	BOOL m_useDebugUnarchiver;
}
@property (nonatomic, assign) AMFVersion version;
@property (nonatomic, retain) NSArray *headers;
@property (nonatomic, retain) NSArray *bodies;

- (id)initWithData:(NSData *)data;
- (id)initWithDataUsingDebugUnarchiver:(NSData *)data;
- (NSData *)data;

- (NSUInteger)messagesCount;
- (AMFMessageBody *)bodyAtIndex:(NSUInteger)index;
- (AMFMessageHeader *)headerAtIndex:(NSUInteger)index;

- (void)addBodyWithTargetURI:(NSString *)targetURI responseURI:(NSString *)responseURI data:(id)data;
- (void)addHeaderWithName:(NSString *)name mustUnderstand:(BOOL)mustUnderstand data:(id)data;

- (void)mergeActionMessage:(AMFActionMessage *)message;
@end


@interface AMFMessageHeader : NSObject 
{
	NSString *m_name;
	BOOL m_mustUnderstand;
	NSObject *m_data;
}
@property (nonatomic, retain) NSString *name;
@property (nonatomic, assign) BOOL mustUnderstand;
@property (nonatomic, retain) NSObject *data;

+ (AMFMessageHeader *)messageHeaderWithName:(NSString *)name data:(NSObject *)data 
	mustUnderstand:(BOOL)mustUnderstand;
@end


@interface AMFMessageBody : NSObject 
{
	NSString *m_targetURI;
	NSString *m_responseURI;
	NSObject *m_data;
}
@property (nonatomic, retain) NSString *targetURI;
@property (nonatomic, retain) NSString *responseURI;
@property (nonatomic, retain) NSObject *data;
@end


#endif
