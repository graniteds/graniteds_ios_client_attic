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

#ifndef __GDSPERSISTENCE_H__
#define __GDSPERSISTENCE_H__


#import <Foundation/Foundation.h>

@protocol GDSExternalizable;
@class FlexArrayCollection;


@protocol GDSPersistentCollection <GDSExternalizable>

@property (readonly) NSNumber *initialized;

//- (void)initializing();
//- (void)initialize();
//- (void)uninitialize();

@end


@interface GDSPersistentList : FlexArrayCollection <GDSPersistentCollection> {
    
    NSNumber *_initialized;
    NSString *_metadata;
    NSNumber *_dirty;
}

@end


@interface GDSPersistentSet : GDSPersistentList {

}

@end


#endif