/*
 
    Project : GraniteDS iOS Client
    File    : GDSFaultEvent.h
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

#ifndef __GDSFAULTEVENT_H__
#define __GDSFAULTEVENT_H__


#import <Foundation/Foundation.h>

@class GDSAbstractEvent;
@class GDSAsyncToken;
@class FlexErrorMessage;


/**
 *
 *
 * @author Franck WOLFF
 */
@interface GDSFaultEvent : GDSAbstractEvent {

    FlexErrorMessage *m_response;
}

#pragma mark -
#pragma mark Properties

@property (readonly) FlexErrorMessage *response;
@property (readonly) NSString *faultCode;
@property (readonly) NSString *faultDetail;
@property (readonly) NSString *faultString;
@property (readonly) NSObject *extendedData;
@property (readonly) NSObject *rootCause;

#pragma mark -
#pragma mark Initialization

+ (id)initWithToken:(GDSAsyncToken *)token
           response:(FlexErrorMessage *)response;

- (id)initWithToken:(GDSAsyncToken *)token
           response:(FlexErrorMessage *)response;

@end


#endif

