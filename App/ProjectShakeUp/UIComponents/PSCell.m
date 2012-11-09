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

@interface PSCell()
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

- (void)load
{
    [self.title setText:self.article.title];
    NSURL* url = [NSURL URLWithString:self.article.url];
    [self.image setImageWithURL:url placeholderImage:[UIImage imageNamed:@"placeholder.jpg"]];
}

- (IBAction)tapped:(id)sender
{
    [self.delegate cellTappedWithCell:self];
}
@end
