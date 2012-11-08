//
//  TSFeed.h
//  TheSun
//
//  Created by Martin Lloyd on 7/18/12.
//  Copyright (c) 2012 NewsInternational. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TSHTTPRequest.h"
#import "TSFeedParser.h"
#import "TSManagedObject.h"

#define kKEYPATH_FEED_FEED @"feed"

#define FEED_UPDATE_NOTIFICATION     @"FEED_UPDATE_NOTIFICATION"
#define FEED_HTTP_ERROR_NOTIFICATION @"FEED_HTTP_ERROR_NOTIFICATION"
#define FEED_DATA_ERROR_NOTIFICATION @"FEED_DATA_ERROR_NOTIFICATION"

@interface TSFeed: TSManagedObject

// instance attributes
@property(nonatomic, strong) NSString *title;
@property(nonatomic, strong) NSMutableArray *articles;

//parser
@property(nonatomic, strong) TSFeedParser *parser;

// custom initialiser
-(id)initWithFeedTitle:(NSString*) title Articles:(NSMutableArray*) articles;

// static competition methods
+(TSFeed*)getFeed:(NSString*)requestURL;

@end

