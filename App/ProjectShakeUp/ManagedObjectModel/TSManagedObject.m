//
//  TSManagedObject.m
//  TheSun
//
//  Created by Martin Lloyd on 8/6/12.
//  Copyright (c) 2012 NewsInternational. All rights reserved.
//

#import "TSManagedObject.h"
#import "Logging.h"

@implementation TSManagedObject

// static(Class level) private variables
static NSMutableDictionary *activeRequestList;

#pragma SMTHTTPRequestDelegate methods
-(void)requestFinishedWithData:(NSData *)responseData ServiceRequestKey:(NSString *)serviceRequestKey HttpHeaders:(NSDictionary*)headers 
{
    // remove the request from activeReqList
    if ([[[self class] getActiveRequests] objectForKey:serviceRequestKey])
        [[[self class] getActiveRequests] removeObjectForKey:serviceRequestKey];
}

-(void)requestFailedWithHTTPError:(NSString *)errorName ServiceRequestKey:(NSString *)serviceRequestKey HttpHeaders:(NSDictionary*)headers
{
    // remove the request from activeReqList
    if ([[[self class] getActiveRequests] objectForKey:serviceRequestKey])
        [[[self class] getActiveRequests]  removeObjectForKey:serviceRequestKey];
    
    //raise the error notification for HTTP error
    [self raiseErrorNotificationForHTTPError:errorName ServiceRequestKey:serviceRequestKey];
}

-(void) raiseErrorNotificationForHTTPError:(NSString *)errorName ServiceRequestKey:(NSString *)serviceRequestKey
{
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:[NSString stringWithFormat:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)]
                                 userInfo:nil];
}

#pragma SMTDataErrorDelegate  method
-(void)requestFailedWithDataError:(NSString *)errorName ServiceRequestKey:(NSString *)serviceRequestKey
{
    //raise the error notification for DATA error
    [self raiseErrorNotificationForDataError:errorName ServiceRequestKey:serviceRequestKey];
}

-(void) raiseErrorNotificationForDataError:(NSString *)errorName ServiceRequestKey:(NSString *)serviceRequestKey
{
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:[NSString stringWithFormat:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)]
                                 userInfo:nil];
}

#pragma SMTParserDelegate
-(void)didFinishParsing:(id)parsedData ForServiceKey:(NSString *)serviceKey
{
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:[NSString stringWithFormat:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)]
                                 userInfo:nil];
}

-(void)parseErrorOccurred:(NSString *)errorDescription ForServiceKey:(NSString *)serviceKey
{
    Debug(@"error:%@ for serviceReqKey:%@", errorDescription, serviceKey);
}

#pragma HELPER INSTANCE METHODS
-(NSString*) getKeyPathByServiceKey:(NSString*) serviceKey
{
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:[NSString stringWithFormat:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)]
                                 userInfo:nil];
}

#pragma HELPER STATIC METHODS

+(void) FireOffAsynRequestToURL:(NSString*) url WithServiceRequestKey:(NSString*) serviceReqKey ResponseHandler:(id) responseHandler
{
    //first check for the duplicate request
    if ([[[self class] getActiveRequests] objectForKey:serviceReqKey])
        return;
    
    //create the SMTRequest object
    TSHTTPRequest *request = [[TSHTTPRequest alloc]
                               initWithURL:[NSURL URLWithString:url]
                               Delegate:responseHandler
                               ServiceKey:serviceReqKey];
    
    //add request into active requests list
    [[[self class] getActiveRequests] setObject:request forKey:serviceReqKey];
    
    //start off request Asynchronously
    [request startAsynchronous];
    
    //we don't need the request reference anymore, activeRequestList contains it.
    request = nil;
}

+(id) internalManagedObject
{
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:[NSString stringWithFormat:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)]
                                 userInfo:nil];
}


+(NSMutableDictionary*) getActiveRequests
{
    if (!activeRequestList) {
        activeRequestList = [[NSMutableDictionary alloc] init];
    }
    
    return activeRequestList;
}

+(void) WriteDataToDisk:(NSData*)data withFileName:(NSString*)fileName
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [data writeToFile:[[TSManagedObject class] GetPath:fileName] atomically:NO];
    });
}

+(BOOL) CheckFileExistsWithFileName:(NSString*)fileName
{
    return [[NSFileManager defaultManager] fileExistsAtPath:[[TSManagedObject class] GetPath:fileName]];
}

+(NSData*) FetchDataFromDiskWithFileName:(NSString*)fileName
{
    return [NSData dataWithContentsOfFile:[[TSManagedObject class] GetPath:fileName]];
}

+(NSString*) GetPath:(NSString*)fileName
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *dir = [paths objectAtIndex:0];
    NSString *savedPath = [dir stringByAppendingPathComponent:[fileName stringByAppendingString:@".data"]];
    return savedPath;
}


@end
