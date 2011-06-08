/*
 
    Project : GraniteDS iOS Client
    File    : GDSAsyncResponder.m
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

#import "GDSAsyncResponder.h"

#import "GDSResultEvent.h"


@implementation GDSAsyncResponder

#pragma mark -
#pragma mark Properties

@synthesize target=m_target;
@synthesize result=m_result;
@synthesize fault=m_fault;

#pragma mark -
#pragma mark Initialization & Deallocation

+ (id)responderWithTarget:(id)target result:(SEL)result fault:(SEL)fault
{
    return [[[GDSAsyncResponder alloc] initWithTarget:target result:result fault:fault] autorelease];
}

- (id)initWithTarget:(id)target result:(SEL)result fault:(SEL)fault
{
    if (target == nil || result == nil)
        @throw [NSException exceptionWithName:NSInvalidArgumentException
                                       reason:@"Parameters target and result cannot be null"
                                     userInfo:nil];
    
    if ((self = [self init]))
    {
        m_target = [target retain];
        m_result = result;
        m_fault = fault;
    }
    return self;
}

- (void)dealloc
{
    [m_target release];
    
    [super dealloc];
}

#pragma mark -
#pragma mark Responder Selector Call

- (void)callWithEvent:(GDSAbstractEvent *)event;
{
    if ([event isKindOfClass:[GDSResultEvent class]])
        [m_target performSelector:m_result withObject:event];
    else if (m_fault != nil)
        [m_target performSelector:m_fault withObject:event];
}

@end
