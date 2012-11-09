//
//  PSViewController.m
//  ProjectShakeUp
//
//  Created by Martin Lloyd on 08/11/2012.
//  Copyright (c) 2012 News International. All rights reserved.
//

#import "PSViewController.h"
#import "TSFeed.h"
#import "TSArticle.h"
#import "Logging.h"
#import "PSCell.h"
#import "UIImageView+AFNetworking.h"

@interface PSViewController ()
@property (strong, nonatomic) NSArray* psCells;
@property (strong, nonatomic) TSFeed* feed;
@end

@implementation PSViewController
@synthesize psCells = _psCells;
@synthesize feed = _feed;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(feedDataAvailableNotificationReceived:)
                                                 name:FEED_UPDATE_NOTIFICATION
                                               object:nil];

    CGSize size = CGSizeMake(100, 125);
    CGFloat border = 10;
    
    // Top Left
    PSCell* topLeftView = [[PSCell alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.view.frame) + border,
                                                                   CGRectGetMinY(self.view.frame) + border,
                                                                   size.width, size.height)];
    // Top Right
    PSCell* topRightView = [[PSCell alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.view.frame) - (border + size.width),
                                                                    CGRectGetMinY(topLeftView.frame),
                                                                    size.width, size.height)];
    // Middle
    PSCell* middleView = [[PSCell alloc] initWithFrame:CGRectMake(CGRectGetMaxX(topLeftView.frame),
                                                                  CGRectGetMaxY(topLeftView.frame) + border,
                                                                  size.width, size.height)];
    // Bottom Left
    PSCell* bottomLeftView = [[PSCell alloc] initWithFrame:CGRectMake(CGRectGetMinX(topLeftView.frame),
                                                                      CGRectGetMaxY(middleView.frame) + border,
                                                                      size.width, size.height)];
    // Bottom Right
    PSCell* bottonRightView = [[PSCell alloc] initWithFrame:CGRectMake(CGRectGetMinX(topRightView.frame),
                                                                       CGRectGetMaxY(middleView.frame) + border,
                                                                       size.width, size.height)];
    
    self.psCells = [[NSArray alloc] initWithObjects:topLeftView, topRightView, middleView, bottomLeftView, bottonRightView, nil];
    
    for (UIView* cell in self.psCells) {
        [self.view addSubview:cell];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated
{
    [self becomeFirstResponder];
}

- (BOOL)canBecomeFirstResponder
{
    return YES;
}

#pragma mark Gesture recognizer actions

-(void)feedDataAvailableNotificationReceived:(NSNotification *)notification
{    
    if ([[[notification userInfo] objectForKey:kNOTIFICATION_KEYPATH] isEqual: kKEYPATH_FEED_FEED]) {
        self.feed = (TSFeed*)[[notification userInfo] objectForKey:kNOTIFICATION_DATA];
        TSArticle* article = (TSArticle*)[self.feed.articles objectAtIndex:0];
//        Debug(@"%@", article.title);
//        Debug(@"%@", article.url);
//        Debug(@"%@", article.story);
        
        int i=0;
        
        for( PSCell* cell in self.psCells) {
            article = [self.feed.articles objectAtIndex:i];
            i++;
            [cell.title setText:article.title];
            NSURL* url = [NSURL URLWithString:article.url];
            [cell.image setImageWithURL:url];
        }
    }
}

- (void)viewDidUnload {
    [super viewDidUnload];
}

- (IBAction)shakeButtonPressed:(id)sender {
    UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Shaking!"
                                                      message:@"This will load another 5 random articles."
                                                     delegate:nil
                                            cancelButtonTitle:@"OK"
                                            otherButtonTitles:nil];
    [message show];
}

#pragma mark
#pragma Shaking-Motion Events
- (void)motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
}

- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Shake" message:@"Ended" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
}

- (void)motionCancelled:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
}

@end
