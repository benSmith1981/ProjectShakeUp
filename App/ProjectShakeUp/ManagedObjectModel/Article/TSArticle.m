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

-(id)initWithArticleTitle:(NSString*) title;
{
    self = [super init];
    if (self) {
        _title = title;
    }
    
    return self;
}
@end
