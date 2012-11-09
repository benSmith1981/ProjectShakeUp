//
//  PSDetailedViewController.m
//  ProjectShakeUp
//
//  Created by Martin Lloyd on 09/11/2012.
//  Copyright (c) 2012 News International. All rights reserved.
//

#import "PSDetailedViewController.h"

@interface PSDetailedViewController ()

@end

@implementation PSDetailedViewController

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithNibName:@"PSDetailedViewController" bundle:nil];
    if (self) {
        // Custom initialization
        self.view.frame = frame;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)animate
{
    [UIView animateWithDuration:1.0
                     animations:^{
                         self.view.frame = self.view.superview.bounds;
                     }
                     completion:^(BOOL finished) {
                     }];
}

- (IBAction)closeButtonPressed:(id)sender
{
    [UIView animateWithDuration:1.0
                     animations:^{
                         self.view.alpha = 0;
                     }
                     completion:^(BOOL finished) {
                         [self.view removeFromSuperview];
                     }];
}

@end
