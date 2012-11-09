//
//  PSCell.m
//  ProjectShakeUp
//
//  Created by Martin Lloyd on 08/11/2012.
//  Copyright (c) 2012 News International. All rights reserved.
//

#import "PSCell.h"
#import "TSLayerVisuals.h"
#import <QuartzCore/QuartzCore.h>

CGFloat DegreesToRadians(CGFloat degrees) {return degrees * M_PI / 180;};
CGFloat RadiansToDegrees(CGFloat radians) {return radians * 180/M_PI;};

@implementation PSCell
@synthesize _lastRotation;

- (id)initWithFrame:(CGRect)frame
{
    self = [[[NSBundle mainBundle] loadNibNamed:@"PSCell" owner:self options:nil] objectAtIndex:0];
    if (self) {
        // Initialization code
        self.frame = frame;
        [TSLayerVisuals applyDropShadow:self];
        [self floatingAnimation];
        
    }
    return self;
}

-(void)floatingAnimation{
    
    [UIView animateWithDuration:3.0
                          delay:0.0
                        options: UIViewAnimationOptionRepeat | UIViewAnimationOptionAutoreverse
                     animations:^{
                         
                         int randomMoveNumber = -3 + rand() % (3+3);

                         self.center = CGPointMake(self.center.x + randomMoveNumber,
                                                             self.center.y);
                         
                         int randomRotateNumber = -10 + rand() % (10+10);
                         CGAffineTransform transform = CGAffineTransformMakeRotation(DegreesToRadians(randomRotateNumber));
                         self.transform = transform;
                     }
                     completion:NULL];
}

-(void)rotateView:(UIView*)view
{
    CGFloat rotation = 0.0 - (_lastRotation);
    CGAffineTransform currentTransform = view.transform;
    CGAffineTransform newTransform = CGAffineTransformRotate(currentTransform,rotation);
    
    [view setTransform:newTransform];
    
    _lastRotation = 0.0;//[view. rotation];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
