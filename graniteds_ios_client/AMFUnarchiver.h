/*
 
    Project : GraniteDS iOS Client
    File    : AMFUnarchiver.h
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

#ifndef __AMFUNARCHIVER_H__
#define __AMFUNARCHIVER_H__


#import <Foundation/Foundation.h>
#import "AMF.h"
#import "ASObject.h"
#import "FlexDataTypes.h"

#if TARGET_OS_IPHONE
#import "NSObject-iPhoneExtensions.h"
#endif

#define AMFInvalidArchiveOperationException @"AMFInvalidArchiveOperationException"

@interface AMFUnarchiver : NSCoder 
{
	NSData *m_data;
	const uint8_t *m_bytes;
	uint32_t m_position;
	AMFVersion m_objectEncoding;
	NSMutableDictionary *m_registeredClasses;
	NSMutableArray *m_objectTable;
	ASObject *m_currentDeserializedObject;
}
@property (nonatomic, readonly) AMFVersion objectEncoding;
@property (nonatomic, readonly) NSData *data;

//--------------------------------------------------------------------------------------------------
//	Usual NSCoder methods
//--------------------------------------------------------------------------------------------------

- (id)initForReadingWithData:(NSData *)data encoding:(AMFVersion)encoding;
+ (id)unarchiveObjectWithData:(NSData *)data encoding:(AMFVersion)encoding;
+ (id)unarchiveObjectWithFile:(NSString *)path encoding:(AMFVersion)encoding;

- (BOOL)allowsKeyedCoding;
- (void)finishDecoding;
- (NSUInteger)bytesAvailable;
- (BOOL)isAtEnd;
- (Class)classForClassName:(NSString *)codedName;
+ (Class)classForClassName:(NSString *)codedName;
- (void)setClass:(Class)cls forClassName:(NSString *)codedName;
+ (void)setClass:(Class)cls forClassName:(NSString *)codedName;
+ (void)setOptions:(uint16_t)options;
+ (uint16_t)options;
- (BOOL)containsValueForKey:(NSString *)key;

- (BOOL)decodeBoolForKey:(NSString *)key;
- (double)decodeDoubleForKey:(NSString *)key;
- (float)decodeFloatForKey:(NSString *)key;
- (int32_t)decodeInt32ForKey:(NSString *)key;
- (int64_t)decodeInt64ForKey:(NSString *)key;
- (int)decodeIntForKey:(NSString *)key;
- (id)decodeObjectForKey:(NSString *)key;
- (void)decodeValueOfObjCType:(const char *)valueType at:(void *)data;

//--------------------------------------------------------------------------------------------------
//	AMF Extensions for reading specific data and deserializing externalizable classes
//--------------------------------------------------------------------------------------------------

//- (void)compress;
// - (void)uncompress;

- (BOOL)decodeBool;
- (int8_t)decodeChar;
- (double)decodeDouble;
- (float)decodeFloat;
- (int32_t)decodeInt;
- (int16_t)decodeShort;
- (uint8_t)decodeUnsignedChar;
- (uint32_t)decodeUnsignedInt;
- (uint16_t)decodeUnsignedShort;
- (uint32_t)decodeUnsignedInt29;
- (NSData *)decodeBytes:(uint32_t)length;
- (NSString *)decodeMultiByteString:(uint32_t)length encoding:(NSStringEncoding)encoding;
- (NSObject *)decodeObject;
- (NSString *)decodeUTF;
- (NSString *)decodeUTFBytes:(uint32_t)length;
@end



@interface AMF0Unarchiver : AMFUnarchiver
{
}
@end



@interface AMF3Unarchiver : AMFUnarchiver
{
	NSMutableArray *m_stringTable;
	NSMutableArray *m_traitsTable;
}
@end



@interface AMF3TraitsInfo : NSObject 
{
	NSString *m_className;
	BOOL m_dynamic;
	BOOL m_externalizable;
	NSUInteger m_count;
	NSMutableArray *m_properties;
}
@property (nonatomic, retain) NSString *className;
@property (nonatomic, assign) BOOL dynamic;
@property (nonatomic, assign) BOOL externalizable;
@property (nonatomic, assign) NSUInteger count;
@property (nonatomic, retain) NSMutableArray *properties;

- (void)addProperty:(NSString *)property;
@end


#endif
