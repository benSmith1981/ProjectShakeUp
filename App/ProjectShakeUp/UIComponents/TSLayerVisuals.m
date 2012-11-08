//
//  TSRoundCorners.m
//  TheSun
//
//  Created by Martin Lloyd on 11/10/2012.
//
//

#import "TSLayerVisuals.h"
#import <QuartzCore/QuartzCore.h>

@implementation TSLayerVisuals

+ (void)applyRoundedCorners:(CALayer*)layer corners:(NSUInteger)corners
{
    [layer setShadowColor: [[UIColor blackColor] CGColor]];
    [layer setShadowOpacity:0.85f];
    [layer setShadowOffset: CGSizeMake(0.0f, 1.5f)];
    [layer setShadowRadius:2.0f];
    [layer setShouldRasterize:YES];
    
    CGRect bounds = layer.bounds;
    bounds.size.height += 10.0f;
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:bounds
                                                   byRoundingCorners:corners
                                                         cornerRadii:CGSizeMake(10.0, 10.0)];
    
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.frame = bounds;
    maskLayer.path = maskPath.CGPath;
    
    [layer addSublayer:maskLayer];
    layer.mask = maskLayer;
}

+ (void)applyDropShadow:(UIView*)view
{
    view.layer.masksToBounds = NO;
    view.layer.cornerRadius = 8;
    view.layer.shadowOffset = CGSizeMake(-15, 0);
    view.layer.shadowRadius = 5;
    view.layer.shadowOpacity = 0.5;
    view.layer.shadowPath = [UIBezierPath bezierPathWithRect:view.bounds].CGPath;
}

@end
