//
//  NSDate+Format.m
//  TheSun
//
//  Created by Martin Lloyd on 7/20/12.
//  Copyright (c) 2012 NewsInternational. All rights reserved.
//

#import "NSDate+Format.h"

@implementation NSDate (Format)

+(NSDate *)dateFromString:(NSString *) strDate
{
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    [dateFormat setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    NSDate *date = [dateFormat dateFromString:strDate]; 
    
    return date;
}

@end
