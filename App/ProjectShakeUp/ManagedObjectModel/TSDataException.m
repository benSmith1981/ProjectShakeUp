//
//  TSDataException.m
//  TheSun
//
//  Created by Martin Lloyd on 8/7/12.
//  Copyright (c) 2012 NewsInternational. All rights reserved.
//

#import "TSDataException.h"

@implementation TSDataException

+(NSString*) isErrorElementPresentInJSON:(NSDictionary *) parsedJSON RootElementName:(NSString*) rootElementName ServiceKey:(NSString*) serviceKey
{
    NSDictionary *data = [parsedJSON objectForKey:rootElementName];
    NSDictionary *errors = [data objectForKey:@"errors"];
    NSString *errorCategory = nil;
    
    if (!errors) { //if errors element is not present return nil
        return errorCategory;
    }
    else {
        //parse the error element
        NSString* errorText = [errors valueForKey:@"error"];
        
        //categorize the errorDescription
        NSRange rangeOfInvalidParam = [errorText rangeOfString:@"Invalid"];
        NSRange rangeOfNoData = [errorText rangeOfString:@"No data available"];
        
        if (rangeOfInvalidParam.location != NSNotFound && rangeOfInvalidParam.length > 0 ) {
            errorCategory = INVALID_REQUEST_PARAMETER_DATA_ERROR;
        }
        else if (rangeOfNoData.location != NSNotFound && rangeOfNoData.length > 0 )  {
            errorCategory = NO_DATA_AVAILABLE_DATA_ERROR;
        }
        
        return errorCategory;
    }
}

@end
