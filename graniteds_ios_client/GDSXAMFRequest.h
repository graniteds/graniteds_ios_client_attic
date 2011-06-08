/*
  
    Project : GraniteDS iOS Client
    File    : GDSXAMFRequest.h
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

#ifndef __GDSXAMFREQUEST_H__
#define __GDSXAMFREQUEST_H__

#import <Foundation/Foundation.h>


/**
 * Helper class for sending HTTP POST requests with an "application/x-amf" content type.
 *
 * @author Franck WOLFF
 */
@interface GDSXAMFRequest : NSObject {
    
    NSURLConnection *m_connection;
    NSMutableURLRequest *m_request;
    NSMutableData *m_receivedData;

    id m_target;
    SEL m_result;
    SEL m_fault;
}

#pragma mark -
#pragma mark Initialization

/**
 * Send a POST request with a content type of "application/x-amf" to the url paremeter,
 * filling the request body with the content of the body parameter.
 * 
 * @param url the URL to send the request to.
 * @param body the data to put in the request body.
 * @param target the object that holds the result and fault selectors for notifications.
 * @param result the method called upon success. It must have the form of:
 *      \code - (void)resultHandler:(NSData *)data; \endcode
 * @param fault the method called upon failure. It must have the form of:
 *      \code - (void)faultHandler:(NSError *)error; \endcode
 * @param timeout the timeout interval for the new request in seconds.
 *
 * @return a new GDSXAMFRequest instance.
 */
- (id)initWithURL:(NSURL *)url
             body:(NSData *)body
           target:(id)target
           result:(SEL)result
            fault:(SEL)fault
          timeout:(NSTimeInterval)timeout;

#pragma mark -
#pragma mark Cancellation

/**
 * Cancel this request.
 */
- (void)cancel;

@end

#endif
