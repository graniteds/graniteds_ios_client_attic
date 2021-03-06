/*
 
    Project : GraniteDS iOS Client
    File    : AMFDebugUnarchiver.h
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

#ifndef __AMFDEBUGUNARCHIVER_H__
#define __AMFDEBUGUNARCHIVER_H__


#import <Foundation/Foundation.h>
#import "AMF.h"
#import "AMFUnarchiver.h"
#import "FlexDataTypes.h"


@interface AMFDebugUnarchiver : AMFUnarchiver
{
}
@end

@interface AMF0DebugUnarchiver : AMF0Unarchiver
{
}
@end

@interface AMF3DebugUnarchiver : AMF3Unarchiver
{
}
@end

@interface AMFDebugDataNode : NSObject
{
	AMFVersion version;
	int type;
	NSObject *data;
	NSString *name;
	NSArray *children;
	NSString *objectClassName;
}
@property (nonatomic, assign) AMFVersion version;
@property (nonatomic, assign) int type;
@property (nonatomic, retain) NSObject *data;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, readonly) NSArray *children;
@property (nonatomic, retain) NSString *objectClassName;

- (NSString *)AMFClassName;
- (BOOL)hasChildren;
- (NSUInteger)numChildren;
@end


#endif
