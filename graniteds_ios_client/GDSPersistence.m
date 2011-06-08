/*
 
    Project : GraniteDS iOS Client
    File    : GDSPersistence.h
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

#import "GDSRemoteProtocols.h"
#import "FlexDataTypes.h"

#import "GDSPersistence.h"


@implementation GDSPersistentList

+ (NSString *)__gds__remoteClassAlias
{
    return @"org.granite.messaging.persistence.ExternalizablePersistentList";
}

@synthesize initialized=_initialized;


- (id)initWithCoder:(NSCoder *)coder
{
    if ((self = [self init]))
    {
        _initialized = [[coder decodeObject] retain];
        _metadata = [[coder decodeObject] retain];
        
        if ([_initialized boolValue] != NO)
        {
            _dirty = [[coder decodeObject] retain];
            
            [super initWithCoder:coder];
        }
    }
	return self;
}

- (void)encodeWithCoder:(NSCoder *)coder
{
    [coder encodeObject:_initialized];
    [coder encodeObject:_metadata];

    if ([_initialized boolValue] != NO)
    {
        [coder encodeObject:_dirty];
        
        [super encodeWithCoder:coder];
    }
}

- (void)dealloc
{
    [_initialized release];
    [_metadata release];
    [_dirty release];
    
    [super dealloc];
}

@end


@implementation GDSPersistentSet

+ (NSString *)__gds__remoteClassAlias
{
    return @"org.granite.messaging.persistence.ExternalizablePersistentSet";
}

@end