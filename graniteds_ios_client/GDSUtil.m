/*
 
    Project : GraniteDS iOS Client
    File    : GDSUtil.m
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

#import "GDSUtil.h"

#pragma mark Constants & Definitions

static const unsigned char *const BASE64_CHARS = (unsigned char *)"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
#define BASE64_PADDING_CHAR (unsigned char)'='
#define UNSIGNED_CHAR_0 (unsigned char)0

#pragma mark -

@implementation GDSUtil

+ (NSString *)randomUUID
{
	CFUUIDRef uuid = CFUUIDCreate(kCFAllocatorDefault);
	CFStringRef uuidString = CFUUIDCreateString(kCFAllocatorDefault, uuid);
	CFRelease(uuid);
	return [(NSString *)uuidString autorelease];
}

+ (NSString *)encodeBase64:(NSString *)text
{
    return [GDSUtil encodeBase64:text encoding:NSUTF8StringEncoding];
}

+ (NSString *)encodeBase64:(NSString *)text encoding:(NSStringEncoding)encoding
{
    if (text == nil)
        return nil;
    if ([text length] == 0)
        return text;
    
    const unsigned char *pChars = (unsigned char *)[text cStringUsingEncoding:encoding]; // autoreleased.
    size_t length = (size_t)strlen((char *)pChars);
    size_t length64 = (((length + 2) / 3) * 4) + 1;
    if (length64 < length)
        [NSException raise:NSMallocException format:@"Cannot allocate base 64 buffer (overflow)"];
    char *const chars64 = [GDSUtil alloc:length64];

    unsigned char *pChars64 = (unsigned char *)chars64;
    unsigned char c0, c1, c2;
    while (1)
    {
        c0 = *pChars++;
        if (c0 == UNSIGNED_CHAR_0)
            break;
        *pChars64++ = BASE64_CHARS[c0 >> 2];

        c1 = *pChars++;
        if (c1 == UNSIGNED_CHAR_0)
        {
            *pChars64++ = BASE64_CHARS[(c0 & 0x03) << 4];
            *pChars64++ = BASE64_PADDING_CHAR;
            *pChars64++ = BASE64_PADDING_CHAR;
            break;
        }
        *pChars64++ = BASE64_CHARS[((c0 & 0x03) << 4) + (c1 >> 4)];

        c2 = *pChars++;
        if (c2 == UNSIGNED_CHAR_0)
        {
            *pChars64++ = BASE64_CHARS[(c1 & 0x0F) << 2];
            *pChars64++ = BASE64_PADDING_CHAR;
            break;
        }
        *pChars64++ = BASE64_CHARS[((c1 & 0x0F) << 2) + (c2 >> 6)];
        *pChars64++ = BASE64_CHARS[c2 & 0x3F];
    }
    *pChars64 = UNSIGNED_CHAR_0;
    
    NSString *string64 = [NSString stringWithCString:chars64 encoding:NSASCIIStringEncoding];
    free(chars64);
    return string64;
}

+ (void *)alloc:(size_t) size
{
    return [GDSUtil realloc:NULL size:size];
}

+ (void *)realloc:(void *)pointer size:(size_t) size
{
    if (size <= (size_t)0)
        [NSException raise:NSInvalidArgumentException format:@"Size must be > 0"];

    pointer = reallocf(pointer, size);
    if (pointer == nil)
        [NSException raise:NSMallocException format:@"Could not allocate %zu bytes", size];
    return pointer;
}

@end
