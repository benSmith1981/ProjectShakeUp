//
//  PSFeedUrlFactory.m
//  ProjectShakeUp
//
//  Created by Martin Lloyd on 13/11/2012.
//  Copyright (c) 2012 News International. All rights reserved.
//

#import "PSFeedUrlFactory.h"
#import "TSServiceKeys.h"

@implementation PSFeedUrlFactory

+(NSString*)getFeedUrlFromKey:(NSString*)key
{
    NSString* urlString = nil;
    
    if([key isEqualToString:kSUN_FEED_SERVICE_KEY]) {
        urlString = @"http://www.thesun.co.uk/sol/homepage/feeds/smartphone/topstories/";
    }
    else if([key isEqualToString:kTIMES_FEED_SERVICE_KEY]) {
        urlString = @"http://m.apps.thetimes.co.uk/tto/feeds/deviceApp/article3015566.ece";
//        urlString = @"http://www.thesun.co.uk/sol/homepage/feeds/smartphone/topstories/";
    }
    else {
        @throw [NSException exceptionWithName:NSInvalidArgumentException
                                       reason:[NSString stringWithFormat:@"Not a valid key -> %@", key]
                                     userInfo:nil];
    }
    
    return urlString;
}

@end
