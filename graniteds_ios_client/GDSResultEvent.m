/*
 
    Project : GraniteDS iOS Client
    File    : GDSResultEvent.m
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

#import "GDSAbstractEvent.h"
#import "GDSAsyncToken.h"
#import "FlexDataTypes.h"

#import "GDSResultEvent.h"


@implementation GDSResultEvent

#pragma mark -
#pragma mark Properties

@synthesize response=m_response;

- (NSDictionary *)headers
{
    return [m_response headers];
}

- (NSObject *)result
{
    return [m_response body];
}

#pragma mark -
#pragma mark Initialization & Deallocation

+ (id)initWithToken:(GDSAsyncToken *)token response:(FlexAcknowledgeMessage *)response
{
    return [[[GDSResultEvent alloc] initWithToken:token response:response] autorelease];
}

- (id)initWithToken:(GDSAsyncToken *)token response:(FlexAcknowledgeMessage *)response
{
    if (token == nil || response == nil)
        @throw [NSException exceptionWithName:NSInvalidArgumentException
                                       reason:@"Parameters token and response cannot be null"
                                     userInfo:nil];
    if ((self == [super initWithToken:token]))
    {
        m_response = [response retain];
    }
    return self;
}

- (void)dealloc
{
    [m_response release];
    
    [super dealloc];
}

@end
