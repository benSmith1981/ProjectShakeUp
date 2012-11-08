//
//  TSDataException.h
//  TheSun
//
//  Created by Martin Lloyd on 8/6/12.
//  Copyright (c) 2012 NewsInternational. All rights reserved.
//

#import <Foundation/Foundation.h>

// DATA ERROR CATEGORY
#define INVALID_REQUEST_PARAMETER_DATA_ERROR @"Invalid request parameter"
#define NO_DATA_AVAILABLE_DATA_ERROR @"No data available"

@interface TSDataException : NSObject
+(NSString*) isErrorElementPresentInJSON:(NSDictionary *) parsedJSON RootElementName:(NSString*) rootElementName ServiceKey:(NSString*) serviceKey;
@end

@protocol TSDataExceptionDelegate
-(void) requestFailedWithDataError:(NSString*) errorName ServiceRequestKey:(NSString*) serviceRequestKey;
@end
