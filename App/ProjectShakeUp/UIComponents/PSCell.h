//
//  PSCell.h
//  ProjectShakeUp
//
//  Created by Martin Lloyd on 08/11/2012.
//  Copyright (c) 2012 News International. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PSCellDelegate;
@class TSArticle;

@interface PSCell : UIView <UIGestureRecognizerDelegate>

@property (nonatomic)CGFloat _lastRotation;

@property (weak, nonatomic) TSArticle *article;
@property (weak, nonatomic) id<PSCellDelegate> delegate;

- (void)load;
@end

@protocol PSCellDelegate
- (void)cellTappedWithCell:(PSCell*)cell;
@end
