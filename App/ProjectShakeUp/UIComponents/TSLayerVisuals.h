//
//  TSRoundCorners.h
//  TheSun
//
//  Created by Martin Lloyd on 11/10/2012.
//
//

#import <Foundation/Foundation.h>

@class CALayer;

@interface TSLayerVisuals : NSObject

+ (void)applyRoundedCorners:(CALayer*)layer corners:(NSUInteger)corners;
+ (void)applyDropShadow:(UIView*)view;

@end
