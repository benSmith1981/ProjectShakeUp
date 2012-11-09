//
//  PSViewController.h
//  ProjectShakeUp
//
//  Created by Martin Lloyd on 08/11/2012.
//  Copyright (c) 2012 News International. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PSViewController : UIViewController<UIGestureRecognizerDelegate>
{    
NSArray *floatingViews;
UIPanGestureRecognizer *panRecognizer;

//BOOL objectMoving;
UIView *activeLayer;
//
CGFloat _firstX;
CGFloat _firstY;
}
- (IBAction)shakeButtonPressed:(id)sender;
@end
