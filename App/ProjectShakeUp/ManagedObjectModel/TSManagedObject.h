//
//  TSManagedObject.h
//  TheSun
//
//  Created by Martin Lloyd on 8/6/12.
//  Copyright (c) 2012 NewsInternational. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TSHTTPRequest.h"
#import "TSDataException.h"
#import "TSParser.h"

#define kNOTIFICATION_DATA @"data"
#define kNOTIFICATION_SERVICEKEY @"serviceKey"
#define kNOTIFICATION_KEYPATH @"keyPath" 
#define kNOTIFICATION_ERROR @"error"
#define kNOTIFICATION_ERROR_MESSAGE @"errorMsg"

@interface TSManagedObject : NSObject<TSHTTPRequestDelegate, TSParserDelegate, TSDataExceptionDelegate>

+ (NSMutableDictionary*) getActiveRequests;
+ (id) internalManagedObject;
+ (void) FireOffAsynRequestToURL:(NSString*) url WithServiceRequestKey:(NSString*) serviceReqKey ResponseHandler:(id) responseHandler;
+ (BOOL) CheckFileExistsWithFileName:(NSString*)fileName;
+ (void) WriteDataToDisk:(NSData*)data withFileName:(NSString*)fileName;
+ (NSData*) FetchDataFromDiskWithFileName:(NSString*)fileName;
- (void) raiseErrorNotificationForHTTPError:(NSString *)errorName ServiceRequestKey:(NSString *)serviceRequestKey;
- (void) raiseErrorNotificationForDataError:(NSString *)errorName ServiceRequestKey:(NSString *)serviceRequestKey;
- (NSString*) getKeyPathByServiceKey:(NSString*) serviceKey;

@end

