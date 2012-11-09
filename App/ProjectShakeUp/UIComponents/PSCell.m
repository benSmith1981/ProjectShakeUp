//
//  PSCell.m
//  ProjectShakeUp
//
//  Created by Martin Lloyd on 08/11/2012.
//  Copyright (c) 2012 News International. All rights reserved.
//

#import "PSCell.h"
#import "TSLayerVisuals.h"

@implementation PSCell

- (id)initWithFrame:(CGRect)frame
{
    self = [[[NSBundle mainBundle] loadNibNamed:@"PSCell" owner:self options:nil] objectAtIndex:0];
    if (self) {
        // Initialization code
        self.frame = frame;
//        [TSLayerVisuals applyRoundedCorners:self.image.layer corners:UIRectCornerAllCorners];
//        [TSLayerVisuals applyRoundedCorners:self.layer corners:UIRectCornerAllCorners];
        [TSLayerVisuals applyDropShadow:self];
    }
    return self;
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
