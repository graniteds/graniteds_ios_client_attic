/*
 
    Project : GraniteDS iOS Client
    File    : GDSAsyncToken.m
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

#import "FlexDataTypes.h"
#import "GDSAbstractEvent.h"
#import "GDSAsyncResponder.h"

#import "GDSAsyncToken.h"


@implementation GDSAsyncToken

#pragma mark -
#pragma mark Properties

@synthesize message=m_message;
@synthesize responders=m_responders;

#pragma mark -
#pragma mark Initialization & Deallocation

+ (id)tokenWithMessage:(FlexAbstractMessage *)message
{
    return [[[GDSAsyncToken alloc] initWithMessage:message] autorelease];
}

- (id)initWithMessage:(FlexAbstractMessage *)message
{
    if (message == nil)
        @throw [NSException exceptionWithName:NSInvalidArgumentException
                                       reason:@"Parameter message cannot be null"
                                     userInfo:nil];
    if ((self = [self init]))
    {
        m_message = [message retain];
        m_responders = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)dealloc
{
    [m_message release];
    [m_responders release];
    
    [super dealloc];
}

#pragma mark -
#pragma mark Add & Call Responders

- (void)addResponder:(GDSAsyncResponder *)responder
{
    [m_responders addObject:responder];
}

- (void)callResponders:(GDSAbstractEvent *)event
{
    if (m_responders != nil && [m_responders count] > 0)
    {
        const NSUInteger count = [m_responders count];
        for (NSUInteger i = 0; i < count; i++)
        {
            GDSAsyncResponder *responder = [m_responders objectAtIndex:i];
            [responder callWithEvent:event];
        }
    }
}

@end
