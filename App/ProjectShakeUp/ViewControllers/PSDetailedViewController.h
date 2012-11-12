//
//  PSDetailedViewController.h
//  ProjectShakeUp
//
//  Created by Martin Lloyd on 09/11/2012.
//  Copyright (c) 2012 News International. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TSArticle;

@interface PSDetailedViewController : UIViewController

@property (weak, nonatomic) TSArticle *article;

- (id)initWithFrame:(CGRect)frame;
- (void)animate;

@end
