//
//  NSString+Format.h
//  TheSun
//
//  Created by Martin Lloyd on 7/23/12.
//  Copyright (c) 2012 NewsInternational. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Format)
+(NSString*) stringFromDate:(NSDate*) date;
+(NSString*) stringFromDateISO8601:(NSDate *)date;
@end
