//
//  TSItem.h
//  TheSun
//
//  Created by Martin Lloyd on 8/9/12.
//  Copyright (c) 2012 NewsInternational. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TSArticle : NSObject

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *url;
@property (nonatomic, strong) NSString *story;

-(id)initWithArticleTitle:(NSString*) title;
-(id)initWithArticleTitle:(NSString*) title Url:(NSString*)url;
-(id)initWithArticleTitle:(NSString*) title Url:(NSString*)url Story:(NSString*)story;

@end
