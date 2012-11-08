//
//  NSString+Format.m
//  TheSun
//
//  Created by Martin Lloyd on 7/23/12.
//  Copyright (c) 2012 NewsInternational. All rights reserved.
//

#import "NSString+Format.h"

@implementation NSString (Format)
+(NSString *)stringFromDate:(NSDate *)date
{
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyyMMdd"];
    NSString *dateString = [dateFormat stringFromDate:date];

    return dateString;
}

+(NSString *)stringFromDateISO8601:(NSDate *)date
{
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    [dateFormat setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss'Z'"];
    NSString *dateString = [dateFormat stringFromDate:date];
    
    return dateString;
}
@end
