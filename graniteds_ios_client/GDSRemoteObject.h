/*
 
    Project : GraniteDS iOS Client
    File    : GDSRemoteObject.h
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

#ifndef __GDSREMOTEOBJECT_H__
#define __GDSREMOTEOBJECT_H__


#import <Foundation/Foundation.h>

@class GDSChannel;
@class GDSAsyncResponder;


/**
 *
 *
 * @author Franck WOLFF
 */
@interface GDSRemoteObject : NSObject {
    
    GDSChannel *m_channel;
    NSString *m_destination;
}

#pragma mark -
#pragma mark Properties

@property (readonly) GDSChannel *channel;
@property (readonly) NSString *destination;
@property (readonly) BOOL authenticated;

#pragma mark -
#pragma mark Initialization

+ (id)remoteObjectWithChannel:(GDSChannel *)channel
                  destination:(NSString *)destination;

- (id)initWithChannel:(GDSChannel *)channel
          destination:(NSString *)destination;

#pragma mark -
#pragma mark Login & Logout Methods

- (void)setCredentialsWithUsername:(NSString *)username
                          password:(NSString *)password;

- (void)logoutWithTarget:(id)target
                  result:(SEL)result 
                   fault:(SEL)fault;

- (void)logoutWithResponder:(GDSAsyncResponder *)responder;

#pragma mark -
#pragma mark Remote Call Methods

- (void)callMethod:(NSString *)method
            target:(id)target
            result:(SEL)result;

- (void)callMethod:(NSString *)method
         arguments:(NSArray *)arguments
            target:(id)target
            result:(SEL)result;

- (void)callMethod:(NSString *)method
            target:(id)target
            result:(SEL)result
             fault:(SEL)fault;

- (void)callMethod:(NSString *)method
         arguments:(NSArray *)arguments
            target:(id)target
            result:(SEL)result
             fault:(SEL)fault;

- (void)callMethod:(NSString *)method
         responder:(GDSAsyncResponder *)responder;

- (void)callMethod:(NSString *)method
         arguments:(NSArray *)arguments
         responder:(GDSAsyncResponder *)responder;

- (void)callMethod:(NSString *)method
        responders:(NSArray *)responders;

- (void)callMethod:(NSString *)method
         arguments:(NSArray *)arguments
        responders:(NSArray *)responders;

@end


#endif
