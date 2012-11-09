//
//  FLGenerator.m
//  floatingLayers
//
//  Created by Smith, Benjamin Terry on 11/8/12.
//  Copyright (c) 2012 News Int. All rights reserved.
//

#import "FloatingLayerGenerator.h"
#import <QuartzCore/QuartzCore.h>
#import  "TSLayerVisuals.h"

CGFloat DegreesToRadians(CGFloat degrees) {return degrees * M_PI / 180;};
CGFloat RadiansToDegrees(CGFloat radians) {return radians * 180/M_PI;};

@implementation FloatingLayerGenerator

-(UIView*)generateFloatingLayerWithRect:(CGRect)rect andRotation:(CGFloat)rotation
{
    UIView *newFLView = [[UIView alloc]initWithFrame:rect];
    [newFLView setBackgroundColor:[UIColor whiteColor]];
    
//    [TSLayerVisuals applyRoundedCorners:newFLView.layer corners:UIRectCornerAllCorners];
    
//    UIImageView *floatingLayerImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"icon.png"]];
//    floatingLayerImage.frame = CGRectMake(0, 0, newFLView.frame.size.width, newFLView.frame.size.height/2);
//     
//    UILabel *floatingLayerLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, floatingLayerImage.frame.size.height, newFLView.frame.size.width, newFLView.frame.size.height/2)];
//    floatingLayerLabel.numberOfLines = 5;
//    [floatingLayerLabel setText:@"This is a test of the floating label view, I am trying to make this text stretch to 5 lines or so...."];
    
//    CGAffineTransform transform = CGAffineTransformMakeRotation(DegreesToRadians(rotation));
//    newFLView.transform = transform;
    
//    floatingLayerImage.transform = transform;
//    floatingLayerLabel.transform = transform;
//    
//    [newFLView addSubview:floatingLayerImage];
//    [newFLView addSubview:floatingLayerLabel];
    
    return newFLView;
}


-(void)rotateView:(UIView*)view
{
    CGFloat rotation = 0.0 - (_lastRotation);
    CGAffineTransform currentTransform = view.transform;
    CGAffineTransform newTransform = CGAffineTransformRotate(currentTransform,rotation);
    
    [view setTransform:newTransform];
    
    _lastRotation = 0.0;//[view. rotation];
}



@end
