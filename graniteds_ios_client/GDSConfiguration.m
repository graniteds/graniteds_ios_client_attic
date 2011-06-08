/*
 
    Project : GraniteDS iOS Client
    File    : GDSConfiguration.m
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

#import "GDSConfiguration.h"

#import <objc/runtime.h>

#import "GDSUtil.h"
#import "GDSRemoteProtocols.h"
#import "AMFArchiver.h"
#import "AMFUnarchiver.h"

@implementation GDSConfiguration

+ (void)scanAndRegisterExternalizableClasses
{
    NSLog(@"Scanning application classes...");
    
    int count = objc_getClassList(NULL, 0);
    Class *classes = [GDSUtil alloc:(sizeof(Class) * count)];
    int newCount = objc_getClassList(classes, count);
    while (count < newCount)
    {
        count = newCount;
        classes = [GDSUtil realloc:classes size:(sizeof(Class) * count)];
        newCount = objc_getClassList(classes, count);
    }
    count = newCount;
    
    Class *cursor = classes;
    for (int i = 0; i < count; i++)
    {
        Class clazz = *cursor;
        if (class_respondsToSelector(clazz, @selector(conformsToProtocol:)) &&
            [clazz conformsToProtocol:@protocol(GDSRemoteClass)])
        {
            NSString *alias = nil;
            @try {
                alias = [((Class <GDSRemoteClass>)clazz) __gds__remoteClassAlias];
            }
            @catch (NSException *exception) {
                // ignore...
            }
            if (alias != nil)
            {
                NSLog(@"Class %s is bound to remote alias: %@", class_getName(clazz), alias);

                [AMFArchiver setClassName:alias forClass:clazz];
                [AMFUnarchiver setClass:clazz forClassName:alias];
            }
        }
        
        cursor++;
    }
    
    free(classes);

    NSLog(@"Scanning done.");
}

+ (void)registerExternalizableClass:(Class)clazz forJavaClassName:(NSString *)name
{
    [AMFArchiver setClassName:name forClass:clazz];
    [AMFUnarchiver setClass:clazz forClassName:name];
}

@end
