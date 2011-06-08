/*
 
    Project : GraniteDS iOS Client
    File    : ASObject.m
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

#import "ASObject.h"


@implementation ASObject

@synthesize type=m_type, properties=m_properties, isExternalizable=m_isExternalizable, data=m_data;

#pragma mark -
#pragma mark Initialization & Deallocation

- (id)init
{
	if ((self = [super init]))
	{
		m_properties = nil;
		m_data = nil;
		m_type = nil;
		m_isExternalizable = NO;
	}
	return self;
}

+ (ASObject *)asObjectWithDictionary:(NSDictionary *)dict
{
	ASObject *obj = [[[ASObject alloc] init] autorelease];
	NSMutableDictionary *mutableCopy = [dict mutableCopy];
	obj.properties = mutableCopy;
	[mutableCopy release];
	return obj;
}

- (void)dealloc
{
	[m_type release];
	[m_properties release];
	[m_data release];
	[super dealloc];
}

- (BOOL)isEqual:(id)obj
{
	if (![obj isKindOfClass:[ASObject class]])
	{
		return NO;
	}
	ASObject *asObj = (ASObject *)obj;
	return ((asObj.type == nil && m_type == nil) || [asObj.type isEqual:m_type]) && 
		asObj.isExternalizable == m_isExternalizable && 
		(m_isExternalizable 
			? [asObj.data isEqual:m_data] 
			: [asObj.properties isEqual:m_properties]);
}



#pragma mark -
#pragma mark Public methods

- (void)setValue:(id)value forKey:(NSString *)key
{
	if (m_properties == nil)
		m_properties = [[NSMutableDictionary alloc] init];
	[m_properties setValue:value forKey:key];
}

- (id)valueForKey:(NSString *)key
{
	return [m_properties valueForKey:key];
}

- (void)addObject:(id)obj
{
	if (m_data == nil)
	{
		m_data = [[NSMutableArray alloc] init];
		m_isExternalizable = YES;
	}
	[m_data addObject:obj];
}

- (NSUInteger)count
{
	return m_isExternalizable ? [m_data count] : [m_properties count];
}

- (NSString *)description
{
	return [NSString stringWithFormat:@"<%@ = 0x%08X | type: %@>\n%@\ndata: %@", 
		[self class], (long)self, m_type, m_properties, m_data];
}

@end