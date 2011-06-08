/*
 
    Project : GraniteDS iOS Client
    File    : NSInvocation-AMFExtensions.m
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

#import "NSInvocation-AMFExtensions.h"


@implementation NSInvocation (AMFExtensions)

- (id)returnValueAsObject
{
	const char *methodReturnType = [[self methodSignature] methodReturnType];
	switch (*methodReturnType)
	{
		case 'c':
		{
			int8_t value;
			[self getReturnValue:&value];
			return [NSNumber numberWithChar:value];
		}
		case 'C':
		{
			uint8_t value;
			[self getReturnValue:&value];
			return [NSNumber numberWithUnsignedChar:value];
		}
		case 'i':
		{
			int32_t value;
			[self getReturnValue:&value];
			return [NSNumber numberWithInt:value];
		}
		case 'I':
		{
			uint32_t value;
			[self getReturnValue:&value];
			return [NSNumber numberWithUnsignedInt:value];
		}
		case 's':
		{
			int16_t value;
			[self getReturnValue:&value];
			return [NSNumber numberWithShort:value];
		}
		case 'S':
		{
			uint16_t value;
			[self getReturnValue:&value];
			return [NSNumber numberWithUnsignedShort:value];
		}
		case 'f':
		{
			float value;
			[self getReturnValue:&value];
			return [NSNumber numberWithFloat:value];
		}
		case 'd':
		{
			double value;
			[self getReturnValue:&value];
			return [NSNumber numberWithDouble:value];
		}
		case 'B':
		{
			uint8_t value;
			[self getReturnValue:&value];
			return [NSNumber numberWithBool:(BOOL)value];
		}
		case 'l':
		{
			long value;
			[self getReturnValue:&value];
			return [NSNumber numberWithLong:value];
		}
		case 'L':
		{
			unsigned long value;
			[self getReturnValue:&value];
			return [NSNumber numberWithUnsignedLong:value];
		}
		case 'q':
		{
			long long value;
			[self getReturnValue:&value];
			return [NSNumber numberWithLongLong:value];
		}
		case 'Q':
		{
			unsigned long long value;
			[self getReturnValue:&value];
			return [NSNumber numberWithUnsignedLongLong:value];
		}
//		case '*':
//		{
//			
//		}
		case '@':
		{
			id value;
			[self getReturnValue:&value];
			return value;
		}
		case 'v':
		case 'V':
		{
			return nil;
		}
		default:
		{
			[NSException raise:NSInternalInconsistencyException
						 format:@"[%@ %@] UnImplemented type: %@",
				[self class], NSStringFromSelector(_cmd), methodReturnType];
		}
	}
	return nil;
}

@end