/*
 
    Project : GraniteDS iOS Client
    File    : AMFDebugUnarchiver.m
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

#import "AMFDebugUnarchiver.h"

@interface AMFUnarchiver (Protected)
- (id)initForReadingWithData:(NSData *)data;
@end

@interface AMF0Unarchiver (Protected)
- (NSObject *)_decodeObjectWithType:(AMF0Type)type;
@end

@interface AMF3Unarchiver (Protected)
- (NSObject *)_decodeObjectWithType:(AMF3Type)type;
@end


@implementation AMFDebugUnarchiver

- (id)initForReadingWithData:(NSData *)data encoding:(AMFVersion)encoding
{
	[[self class] setClass:NULL forClassName:[FlexCommandMessage AMFClassAlias]];
	[[self class] setClass:NULL forClassName:[FlexAcknowledgeMessage AMFClassAlias]];
	[[self class] setClass:NULL forClassName:[FlexRemotingMessage AMFClassAlias]];
	[[self class] setClass:NULL forClassName:[FlexErrorMessage AMFClassAlias]];

	NSZone *temp = [self zone];  // Must not call methods after release
	[self release];              // Placeholder no longer needed

	return (encoding == kAMF0Version)
		? [[AMF0DebugUnarchiver allocWithZone:temp] initForReadingWithData:data]
		: [[AMF3DebugUnarchiver allocWithZone:temp] initForReadingWithData:data];
}

@end



@implementation AMF0DebugUnarchiver

- (NSObject *)_decodeObjectWithType:(AMF0Type)type
{
	if (type == kAMF0AVMPlusObjectType)
	{
		return [AMFDebugUnarchiver unarchiveObjectWithData:[m_data subdataWithRange:
			(NSRange){m_position, [m_data length] - m_position}] encoding:kAMF3Version];
	}
	else
	{
		AMFDebugDataNode *node = [[[AMFDebugDataNode alloc] init] autorelease];
		node.version = kAMF0Version;
		node.type = type;
		node.data = [super _decodeObjectWithType:type];
		return node;
	}
}
@end


@implementation AMF3DebugUnarchiver

- (NSObject *)_decodeObjectWithType:(AMF3Type)type
{
	AMFDebugDataNode *node = [[[AMFDebugDataNode alloc] init] autorelease];
	node.version = kAMF3Version;
	node.type = type;
	node.data = [super _decodeObjectWithType:type];
	return node;
}

@end




@implementation AMFDebugDataNode

@synthesize version, type, data, children, name, objectClassName;

- (id)init
{
	if ((self = [super init]))
	{
		children = nil;
	}
	return self;
}

- (void)setData:(NSObject *)theData
{
	NSArray *newChildren = nil;
	if ([theData isMemberOfClass:[ASObject class]])
	{
		self.objectClassName = [(ASObject *)theData type];
		theData = [(ASObject *)theData properties];
	}
	else if ([theData isMemberOfClass:[FlexArrayCollection class]])
	{
		self.objectClassName = @"ArrayCollection";
		newChildren = [(AMFDebugDataNode *)[(FlexArrayCollection *)theData source] children];
		theData = nil;
	}
	else if ([theData isMemberOfClass:[FlexObjectProxy class]])
	{
		self.objectClassName = @"ObjectProxy";
		newChildren = [(AMFDebugDataNode *)[(FlexObjectProxy *)theData object] children];
		theData = nil;
	}

	if ([theData isKindOfClass:[NSArray class]])
	{
		newChildren = [NSMutableArray array];
		int index = 0;
		for (AMFDebugDataNode *node in (NSArray *)theData)
		{
			node.name = [NSString stringWithFormat:@"%d", index++];
			[(NSMutableArray *)newChildren addObject:node];
		}
	}	
	else if ([theData isKindOfClass:[NSDictionary class]])
	{
		newChildren = [NSMutableArray array];
		for (NSString *key in (NSDictionary *)theData)
		{
			AMFDebugDataNode *node = [(NSDictionary *)theData objectForKey:key];
			node.name = key;
			[(NSMutableArray *)newChildren addObject:node];
		}
	}
	else if (theData != nil)
	{
		[theData retain];
		[data release];
		data = theData;
		return;
	}
	
	[children release];
	children = [newChildren copy];
}

- (BOOL)hasChildren
{
	return [children count] > 0;
}

- (NSUInteger)numChildren
{
	return [children count];
}

- (NSString *)AMFClassName
{
	if (objectClassName != nil)
		return objectClassName;
	
	return version == kAMF0Version 
		? NSStringFromAMF0TypeForDisplay(type) 
		: NSStringFromAMF3TypeForDisplay(type);
}

- (void)dealloc
{
	[children release];
	[data release];
	[name release];
	[objectClassName release];
	[super dealloc];
}

- (NSString *)description
{
	return [NSString stringWithFormat:@"<%@ = 0x%08x> version: %d type: %@ name: %@ data: %@, children: %@", 
		[self className], (long)self, version, [self AMFClassName], name, data, children];
}

@end