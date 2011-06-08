/*
 
    Project : GraniteDS iOS Client
    File    : NSObject-AMFExtensions.m
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

#import "NSObject-AMFExtensions.h"
#import "NSObject-iPhoneExtensions.h"


@implementation NSObject (AMFExtensions)

+ (NSString *)uuid
{
	CFUUIDRef uuidRef = CFUUIDCreate(NULL);
	CFStringRef uuidStringRef = CFUUIDCreateString(NULL, uuidRef);
	CFRelease(uuidRef);
	return [(NSString *)uuidStringRef autorelease];
}

- (id)invokeMethodWithName:(NSString *)methodName arguments:(NSArray *)arguments 
	error:(NSError **)error
{
	return [self invokeMethodWithName:methodName arguments:arguments error:error 
		prependName:nil argument:nil];
}

- (id)invokeMethodWithName:(NSString *)methodName arguments:(NSArray *)arguments 
	error:(NSError **)error prependName:(NSString *)nameToPrepend 
	argument:(id)argumentToPrepend
{
	NSArray *methodNameComponents = [methodName componentsSeparatedByString:@"_"];
	
	if (nameToPrepend != nil)
	{
		if ([arguments count] < 1)
		{
			methodNameComponents = [NSArray arrayWithObject:[nameToPrepend stringByAppendingString:
				[methodName stringByReplacingCharactersInRange:(NSRange){0, 1} 
					withString:[[methodName substringToIndex:1] uppercaseString]]]];
		}
		else
		{
			methodNameComponents = [[NSArray arrayWithObject:nameToPrepend] 
				arrayByAddingObjectsFromArray:methodNameComponents];
		}
	}
	
	NSString *selectorName = [methodNameComponents componentsJoinedByString:@":"];
	if ([arguments count] > 0 || argumentToPrepend != nil)
		selectorName = [selectorName stringByAppendingString:@":"];
	
	SEL selector = NSSelectorFromString(selectorName);
	
	if (![self respondsToSelector:selector])
	{
		*error = [NSError errorWithDomain:kAMFCoreErrorDomain code:kAMFErrorMethodNotFound 
			userInfo:[NSDictionary dictionaryWithObjectsAndKeys:
				[NSString stringWithFormat:@"Service %@ does not respond to selector %@ (%@)", 
					[self className], methodName, selectorName], 
				NSLocalizedDescriptionKey, nil]];
		return nil;
	}

	NSMethodSignature *signature = [self methodSignatureForSelector:selector];	
	if (([signature numberOfArguments] - 2) != 
		(argumentToPrepend == nil ? [arguments count] : [arguments count] + 1))
	{
		*error = [NSError errorWithDomain:kAMFCoreErrorDomain code:kAMFErrorArgumentMismatch
			userInfo:[NSDictionary dictionaryWithObjectsAndKeys:
				[NSString stringWithFormat:@"Number of arguments do not match (%d/%d)", 
					[arguments count], ([signature numberOfArguments] - 2)], 
				NSLocalizedDescriptionKey, nil]];
		return nil;
	}
	
	NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
	[invocation setSelector:selector];
	[invocation setTarget:self];
	uint32_t i = 2;
	if (argumentToPrepend != nil)
		[invocation setArgument:&argumentToPrepend atIndex:i++];
	for (id argument in arguments)
		[invocation setArgument:&argument atIndex:i++];
	[invocation invoke];
	
	return [invocation returnValueAsObject];
}

@end