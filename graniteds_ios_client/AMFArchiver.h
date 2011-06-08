/*
 
    Project : GraniteDS iOS Client
    File    : AMFArchiver.h
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

#ifndef __AMFARCHIVER_H__
#define __AMFARCHIVER_H__


#import <Foundation/Foundation.h>
#import "AMF.h"
#import "AMFUnarchiver.h"
#import "ASObject.h"
#import "FlexDataTypes.h"


@interface AMFArchiver : NSCoder 
{
	NSMutableData *m_data;
	uint8_t *m_bytes;
	uint32_t m_position;
	NSMutableArray *m_objectTable;
	NSMutableArray *m_serializationStack;
	NSMutableArray *m_writeStack;
	NSMutableDictionary *m_registeredClasses;
	ASObject *m_currentObjectToSerialize;
	NSObject *m_currentObjectToWrite;
}

//--------------------------------------------------------------------------------------------------
//	Usual NSCoder methods
//--------------------------------------------------------------------------------------------------

- (id)initForWritingWithMutableData:(NSMutableData *)data encoding:(AMFVersion)encoding;
+ (NSData *)archivedDataWithRootObject:(id)rootObject encoding:(AMFVersion)encoding;
+ (BOOL)archiveRootObject:(id)rootObject encoding:(AMFVersion)encoding toFile:(NSString *)path;

- (BOOL)allowsKeyedCoding;
- (NSData *)data;
- (NSMutableData *)archiverData;
- (void)encodeRootObject:(id)rootObject;
- (void)setClassName:(NSString *)codedName forClass:(Class)cls;
+ (void)setClassName:(NSString *)codedName forClass:(Class)cls;
- (NSString *)classNameForClass:(Class)cls;
+ (NSString *)classNameForClass:(Class)cls;
+ (void)setOptions:(uint16_t)options;
+ (uint16_t)options;

- (void)encodeBool:(BOOL)value forKey:(NSString *)key;
- (void)encodeDouble:(double)value forKey:(NSString *)key;
- (void)encodeFloat:(float)value forKey:(NSString *)key;
- (void)encodeInt32:(int32_t)value forKey:(NSString *)key;
- (void)encodeInt64:(int64_t)value forKey:(NSString *)key;
- (void)encodeInt:(int)value forKey:(NSString *)key;
- (void)encodeObject:(id)value forKey:(NSString *)key;
- (void)encodeValueOfObjCType:(const char *)valueType at:(const void *)address;

//--------------------------------------------------------------------------------------------------
//	AMF Extensions for writing specific data and serializing externalizable classes
//--------------------------------------------------------------------------------------------------

- (void)encodeBool:(BOOL)value;
- (void)encodeChar:(int8_t)value;
- (void)encodeDouble:(double)value;
- (void)encodeFloat:(float)value;
- (void)encodeInt:(int32_t)value;
- (void)encodeShort:(int16_t)value;
- (void)encodeUnsignedChar:(uint8_t)value;
- (void)encodeUnsignedInt:(uint32_t)value;
- (void)encodeUnsignedShort:(uint16_t)value;
- (void)encodeUnsignedInt29:(uint32_t)value;
- (void)encodeDataObject:(NSData *)value;
- (void)encodeMultiByteString:(NSString *)value encoding:(NSStringEncoding)encoding;
- (void)encodeObject:(NSObject *)value;
- (void)encodeUTF:(NSString *)value;
- (void)encodeUTFBytes:(NSString *)value;
@end


@interface AMF0Archiver : AMFArchiver
{
	AMFArchiver *m_avmPlusByteArray;
}
@end


@interface AMF3Archiver : AMFArchiver
{
	NSMutableArray *m_stringTable;
	NSMutableArray *m_traitsTable;
}
@end


#endif
