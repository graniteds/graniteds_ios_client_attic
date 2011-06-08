/*
 
    Project : GraniteDS iOS Client
    File    : GDSXAMFRequest.m
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


#import "GDSXAMFRequest.h"


////////////////////////////////////////////////////////////////////////////////
// GDSXAMFRequest interface (add NSURLConnection delegate methods).


@interface GDSXAMFRequest (NSURLConnectionDelegate)

#pragma mark -
#pragma mark NSURLConnection delegate methods

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response;
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data;
- (void)connectionDidFinishLoading:(NSURLConnection *)connection;
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error;

#pragma mark -

@end


////////////////////////////////////////////////////////////////////////////////
// GDSXAMFRequest implementation.


@implementation GDSXAMFRequest

#pragma mark -
#pragma mark Initialization & Deallocation

- (id)initWithURL:(NSURL *)url
             body:(NSData *)body
           target:(id)target
           result:(SEL)result
            fault:(SEL)fault
          timeout:(NSTimeInterval)timeout
{
    if ((self = [super init]))
    {
        m_request = [[NSMutableURLRequest alloc] initWithURL:url
                                                 cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData
                                             timeoutInterval:timeout];
		[m_request setHTTPMethod:@"POST"];
		[m_request setValue:@"application/x-amf" forHTTPHeaderField:@"Content-Type"];
        [m_request setHTTPBody:body];
        
        m_receivedData = [[NSMutableData alloc] init];
        
        m_target = [target retain];
        m_result = result;
        m_fault = fault;
        
        m_connection = [[NSURLConnection alloc] initWithRequest:m_request
                                                       delegate:self
                                               startImmediately:YES];
        
        if (m_connection == nil)
        {
            NSError *error = [NSError
                errorWithDomain:NSURLErrorDomain
                code:NSURLErrorUnknown
                userInfo:nil
            ];
            [m_target performSelector:m_fault withObject:error];
        }
    }
    
    return self;
}

- (void)dealloc
{
    [m_request release];
    [m_receivedData release];
    [m_connection release];
    [m_target release];
    
    m_result = nil;
    m_fault = nil;
    
    [super dealloc];
}

#pragma mark -
#pragma mark Cancellation

- (void)cancel
{
    [m_connection cancel];
}

#pragma mark -
#pragma mark NSURLConnection delegate methods implementation

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    [m_receivedData setLength:0];
	
    if ([(NSHTTPURLResponse *)response statusCode] != 200)
	{
        NSError *error = [NSError
            errorWithDomain:NSURLErrorDomain
            code:[(NSHTTPURLResponse *)response statusCode]
            userInfo:nil
        ];
        [m_connection cancel];
        [m_target performSelector:m_fault withObject:error];
	}
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [m_receivedData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    [m_target performSelector:m_result withObject:m_receivedData];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    [m_target performSelector:m_fault withObject:error];
}

@end
