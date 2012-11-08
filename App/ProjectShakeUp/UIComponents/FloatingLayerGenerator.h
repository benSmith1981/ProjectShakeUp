//
//  FLGenerator.h
//  floatingLayers
//
//  Created by Smith, Benjamin Terry on 11/8/12.
//  Copyright (c) 2012 News Int. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FloatingLayerGenerator : UIView{
    CGFloat _lastRotation;

}

-(UIView*)generateFloatingLayerWithRect:(CGRect)rect andRotation:(CGFloat)rotation;

@end
