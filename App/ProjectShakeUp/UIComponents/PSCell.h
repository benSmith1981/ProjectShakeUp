//
//  PSCell.h
//  ProjectShakeUp
//
//  Created by Martin Lloyd on 08/11/2012.
//  Copyright (c) 2012 News International. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PSCell : UIView
@property (nonatomic)CGFloat _lastRotation;
@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UILabel *title;
@end
