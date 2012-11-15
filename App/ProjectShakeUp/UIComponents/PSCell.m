//
//  PSCell.m
//  ProjectShakeUp
//
//  Created by Martin Lloyd on 08/11/2012.
//  Copyright (c) 2012 News International. All rights reserved.
//

#import "PSCell.h"
#import "TSArticle.h"
#import "UIImageView+AFNetworking.h"
#import "TSLayerVisuals.h"
#import <QuartzCore/QuartzCore.h>

CGFloat DegreesToRadians(CGFloat degrees) {return degrees * M_PI / 180;};
CGFloat RadiansToDegrees(CGFloat radians) {return radians * 180/M_PI;};

@interface PSCell()
{
    CGFloat _firstX;
    CGFloat _firstY;
}
@property (weak, nonatomic) IBOutlet UIView *background;
@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UILabel *title;

- (IBAction)tapped:(id)sender;
@end

@implementation PSCell
@synthesize delegate = _delegate;
@synthesize article = _article;

- (id)initWithFrame:(CGRect)frame
{
    self = [[[NSBundle mainBundle] loadNibNamed:@"PSCell" owner:self options:nil] objectAtIndex:0];
    if (self) {
        // Initialization code
        self.frame = frame;

        [TSLayerVisuals applyDropShadow:self];
        [TSLayerVisuals applyRoundedCorners:self.layer corners:UIRectCornerAllCorners];
        [TSLayerVisuals applyRoundedCorners:self.background.layer corners:UIRectCornerAllCorners];

        self.background.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"white-paper-texture-600x400.jpeg"]];
        
        self.title.font = [UIFont fontWithName:@"HelveticaNeue-CondensedBlack" size:12.0];

        self.image.layer.borderWidth = 1.5f;
        self.image.layer.borderColor = RGB(0, 81, 125).CGColor;
        self.image.contentMode = UIViewContentModeScaleAspectFit;
        
        UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(move:)];
        [panRecognizer setMinimumNumberOfTouches:1];
        [panRecognizer setMaximumNumberOfTouches:1];
        [panRecognizer setDelegate:self];
        [self addGestureRecognizer:panRecognizer];        
    }
    return self;
}

-(void)floatingAnimation
{    
    [UIView animateWithDuration:5.0
                          delay:0
                        options: UIViewAnimationOptionRepeat | UIViewAnimationOptionAutoreverse | UIViewAnimationOptionAllowUserInteraction
                     animations:^{                         
                         int randomRotateNumber = 1 + rand() % 5;
                         self.transform = CGAffineTransformMakeRotation(DegreesToRadians(randomRotateNumber));
                     }
                     completion:nil];
}

#pragma mark GestureRecognizerActions
-(void)move:(id)sender{
    
    UIPanGestureRecognizer *gestureRecogniser = (UIPanGestureRecognizer*)sender;
    
    [self.superview bringSubviewToFront:gestureRecogniser.view];
    
    
    CGPoint translatedPoint = [(UIPanGestureRecognizer*)sender translationInView:self];
    
    if([(UIPanGestureRecognizer*)sender state] == UIGestureRecognizerStateBegan) {
        _firstX = [gestureRecogniser.view center].x;
        _firstY = [gestureRecogniser.view center].y;
    }
    
    translatedPoint = CGPointMake(_firstX+translatedPoint.x, _firstY+translatedPoint.y);
    [gestureRecogniser.view setCenter:translatedPoint];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)load
{
    [self.title setText:self.article.title];
    
    NSURL* url = [NSURL URLWithString:self.article.url];
    [self.image setImageWithURL:url placeholderImage:[UIImage imageNamed:@"placeholder.jpg"]];
    [self floatingAnimation];
}

- (IBAction)tapped:(id)sender
{
    [self.superview bringSubviewToFront:self];

    [self.delegate cellTappedWithCell:self];
}
@end
