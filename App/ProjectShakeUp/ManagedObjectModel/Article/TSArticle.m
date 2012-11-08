//
//  SMTReferee.m
//  TheSun
//
//  Created by Martin Lloyd on 8/9/12.
//  Copyright (c) 2012 NewsInternational. All rights reserved.
//

#import "TSArticle.h"

@implementation TSArticle

@synthesize title = _title;
@synthesize url = _url;
@synthesize story = _story;

-(id)initWithArticleTitle:(NSString*) title
{
    return self = [self initWithArticleTitle:title Url:nil Story:nil];
}

-(id)initWithArticleTitle:(NSString*) title Url:(NSString*)url;
{
    return self = [self initWithArticleTitle:title Url:url Story:nil];   
}

-(id)initWithArticleTitle:(NSString*) title Url:(NSString*)url Story:(NSString*)story
{
    self = [super init];
    if (self) {
        _title = title;
        _url = url;
        _story = story;
    }
    
    return self;
}
@end
