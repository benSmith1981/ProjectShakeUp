//
//  TSHTTPRequest.h
//  TheSun
//
//  Created by Martin Lloyd on 7/17/12.
//  Copyright (c) 2012 NewsInternational. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFHTTPRequestOperation.h"

// HTTP EXCEPTION CATEGORIES
#define INTERNET_CONNECTION_FAILURE_HTTP_ERROR @"No Network Connectivity"
#define SERVICE_UNAVAILABLE_HTTP_ERROR @"Service Unavailable"
#define TOO_MANY_REDIRECTS_HTTP_ERROR @"Too Many Redirects"


@protocol TSHTTPRequestDelegate;

@interface TSHTTPRequest : NSObject

@property(nonatomic, readonly) NSURL *url;
@property(nonatomic, readonly) NSURLRequest *urlRequest;
@property(nonatomic, unsafe_unretained) id<TSHTTPRequestDelegate> delegate;
@property(nonatomic, retain) NSString *serviceRequestKey;
@property(nonatomic, readonly) AFHTTPRequestOperation *request;

-(id) initWithURL:(NSURL*) url;
-(id) initWithURL:(NSURL*) url Delegate:(id<TSHTTPRequestDelegate>) delegate;
-(id) initWithURL:(NSURL*) url Delegate:(id<TSHTTPRequestDelegate>) delegate ServiceKey:(NSString*) serviceKey;
-(id) initWithURL:(NSURL*) url Delegate:(id<TSHTTPRequestDelegate>) delegate ServiceKey:(NSString*) serviceKey Request:(NSURLRequest*)urlRequest;

-(void) startAsynchronous;
-(void) cancelRequest;

@end


@protocol TSHTTPRequestDelegate

-(void) requestFinishedWithData:(NSData*) responseData ServiceRequestKey:(NSString*) serviceRequestKey HttpHeaders:(NSDictionary*)headers;
-(void) requestFailedWithHTTPError:(NSString*) errorName ServiceRequestKey:(NSString*) serviceRequestKey HttpHeaders:(NSDictionary*)headers;

@end
