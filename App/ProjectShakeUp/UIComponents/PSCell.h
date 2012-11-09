//
//  PSCell.h
//  ProjectShakeUp
//
//  Created by Martin Lloyd on 08/11/2012.
//  Copyright (c) 2012 News International. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PSCellDelegate;

@interface PSCell : UIView
@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UILabel *title;

@property (weak, nonatomic) id<PSCellDelegate> delegate;

- (IBAction)tapped:(id)sender;
@end

@protocol PSCellDelegate
- (void)cellTappedWithCell:(PSCell*)cell;
@end
