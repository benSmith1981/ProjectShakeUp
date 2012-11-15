//
//  TSHTTPRequest.m
//  TheSun
//
//  Created by Martin Lloyd on 7/17/12.
//  Copyright (c) 2012 NewsInternational. All rights reserved.
//

#import "TSHTTPRequest.h"
#import "TSReachability.h"
#import "Logging.h"

@implementation TSHTTPRequest

@synthesize url = _url;
@synthesize request = _request;
@synthesize urlRequest = _urlRequest;
@synthesize delegate = _delegate;
@synthesize serviceRequestKey = _serviceRequestKey;

+(NSOperationQueue*) getNetworkQueue
{
    static NSOperationQueue *_networkQueue = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _networkQueue = [[NSOperationQueue alloc] init];
    });
    
    return _networkQueue;
}

-(id) initWithURL:(NSURL*) url
{
    self  = [self initWithURL:url Delegate:nil];    
    return self;
}

-(id) initWithURL:(NSURL*) url Delegate:(id<TSHTTPRequestDelegate>) delegate
{
    self  = [self initWithURL:url Delegate:delegate ServiceKey:nil];
    return self;
}

-(id) initWithURL:(NSURL*) url Delegate:(id<TSHTTPRequestDelegate>) delegate ServiceKey:(NSString*) serviceKey
{
    self  = [self initWithURL:url Delegate:delegate ServiceKey:serviceKey Request:nil];
    return self;
}

-(id) initWithURL:(NSURL*) url Delegate:(id<TSHTTPRequestDelegate>) delegate ServiceKey:(NSString*) serviceKey Request:(NSURLRequest*)urlRequest
{
    self  = [super init];
    if (self) {
        _url = url;
        _delegate = delegate;
        _serviceRequestKey = serviceKey;
        _urlRequest = urlRequest;
    }
    
    return self;
}

-(void) startAsynchronous
{
    //check the internet availability first
    BOOL isInternetAvailable = [[TSReachability sharedReachability] checkInternet];

    if (isInternetAvailable) {
        
        if( self.urlRequest == nil)
            _urlRequest = [NSURLRequest requestWithURL:self.url];
                
        Warn(@"SENDING ASYNC REQUEST FOR %@", [self.urlRequest.URL absoluteString]);
        
        //// - This should not be done like this should use a login!!
        NSMutableURLRequest* mutableUrlRequest = [[NSMutableURLRequest alloc] initWithURL:_url];
        [mutableUrlRequest setValue:@"7RPejQ4YJcG4Ezm"  forHTTPHeaderField:@"X-NewsInternational-Times-Token"];
        #warning Token Bad practice exposes the a way of getting times content
        ////
        
        __unsafe_unretained typeof(self) weakSelf = self;
        
        _request = [[AFHTTPRequestOperation alloc] initWithRequest:mutableUrlRequest];
        
        [_request setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            Warn(@"RECEIVED SUCCESS RESPONSE FOR REQUEST %@", [operation.response.URL absoluteString]);
            
//            Debug(@"%@", operation.response.allHeaderFields);
            
            NSData *data = [operation responseData];
                        
            if (weakSelf.delegate && data && weakSelf.serviceRequestKey) {
                [weakSelf.delegate requestFinishedWithData:data
                                     ServiceRequestKey:weakSelf.serviceRequestKey
                                           HttpHeaders:operation.response.allHeaderFields];
            }
        } failure: ^(AFHTTPRequestOperation *operation, NSError *error) {
            
            Warn(@"\nRECEIVED FAILURE FOR REQUEST %@ \nWITH ERROR CODE %d \nWITH ERROR MESSAGE %@\n",
                  [operation.request.URL absoluteString],
                  operation.error.code,
                  operation.error.description);
            
//            Debug(@"%@", operation.response.allHeaderFields);
            
            //handle the error, categorise it and raise callback to the caller
            [weakSelf handleAllHTTPErrors:[operation error] withHeaders:operation.response.allHeaderFields];
        }];       
        
        [[[self class] getNetworkQueue] addOperation:self.request];
        
        //start the queue if it is not running
        if ([[[self class] getNetworkQueue] isSuspended]) {
//            [[[self class] getNetworkQueue] start];
        }
    }
}

#pragma AFHTTPRequestOperation Failure Block Calls

-(void) handleAllHTTPErrors :(NSError*) error withHeaders:(NSDictionary*)headers
{
    NSString *errorCategory = nil;
    
    Debug(@"Response error code to handle:%d", error.code);
    
    if (error.code == NSURLErrorNotConnectedToInternet) {
        errorCategory = INTERNET_CONNECTION_FAILURE_HTTP_ERROR;
    }
    else if (error.code == NSURLErrorCannotConnectToHost ||
             error.code == NSURLErrorUserAuthenticationRequired ||
             error.code == NSURLErrorResourceUnavailable ||
             error.code == NSURLErrorUnsupportedURL ||
             error.code == NSURLErrorCannotFindHost ||
             error.code == kCFURLErrorBadServerResponse) {
        
        errorCategory = SERVICE_UNAVAILABLE_HTTP_ERROR;
    }
    else if (error.code == kCFURLErrorHTTPTooManyRedirects) {
        errorCategory = TOO_MANY_REDIRECTS_HTTP_ERROR;
    }
    
    //raise the callback for handled error
    if (self.delegate && errorCategory && self.serviceRequestKey) {
        [self.delegate requestFailedWithHTTPError:errorCategory ServiceRequestKey:self.serviceRequestKey HttpHeaders:headers];
    }
    else {
        Debug(@"Data Layer was unable to catch exception. Exception code:%d with detail: %@", error.code, error.description);
    }
}

-(void) cancelRequest
{
    [self.request cancel];
}

@end
