//
//  PSViewController.h
//  ProjectShakeUp
//
//  Created by Martin Lloyd on 08/11/2012.
//  Copyright (c) 2012 News International. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PSCell.h"

@interface PSViewController : UIViewController<UIGestureRecognizerDelegate, PSCellDelegate>
- (void)refresh;
- (void)showLoginView;
@end
