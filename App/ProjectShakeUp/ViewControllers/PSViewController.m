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
#import "PSDetailedViewController.h"

static CGFloat const overHang = 40;

@interface PSViewController ()
{
    BOOL up;
}

@property (weak, nonatomic) IBOutlet UIView *toolMenuView;
@property (weak, nonatomic) IBOutlet UIView *contentMenuView;

@property (strong, nonatomic) UIPanGestureRecognizer* panGesture;

@property (strong, nonatomic) NSArray* psCells;
@property (strong, nonatomic) TSFeed* feed;
@property (strong, nonatomic) PSDetailedViewController* detailedView;

@end

@implementation PSViewController
@synthesize psCells = _psCells;
@synthesize feed = _feed;
@synthesize detailedView = _detailedView;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(feedDataAvailableNotificationReceived:)
                                                 name:FEED_UPDATE_NOTIFICATION
                                               object:nil];

    CGSize size = CGSizeMake(125, 150);
    CGFloat border = 10;
    
    // Top Left
    PSCell* topLeftView     = [[PSCell alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.view.frame) + border,
                                                                       CGRectGetMinY(self.view.frame) + border,
                                                                       size.width, size.height)];
    // Top Right
    PSCell* topRightView    = [[PSCell alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.view.frame) - (border + size.width),
                                                                       CGRectGetMinY(topLeftView.frame),
                                                                       size.width, size.height)];
    // Middle
    PSCell* middleView      = [[PSCell alloc] initWithFrame:CGRectMake(CGRectGetMidX(topLeftView.frame) + 20,
                                                                       CGRectGetMidY(topLeftView.frame) + 60,
                                                                       size.width, size.height)];
    // Bottom Left
    PSCell* bottomLeftView  = [[PSCell alloc] initWithFrame:CGRectMake(CGRectGetMinX(topLeftView.frame),
                                                                       CGRectGetMaxY(middleView.frame) - border,
                                                                       size.width, size.height)];
    // Bottom Right
    PSCell* bottonRightView = [[PSCell alloc] initWithFrame:CGRectMake(CGRectGetMinX(topRightView.frame),
                                                                       CGRectGetMaxY(middleView.frame) - border,
                                                                       size.width, size.height)];
    
    self.psCells = [[NSArray alloc] initWithObjects:topLeftView, topRightView, middleView, bottomLeftView, bottonRightView, nil];
    
    for (PSCell* cell in self.psCells) {
        [cell setDelegate:self];
        [self.contentMenuView addSubview:cell];
    }

    self.panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(menuSwipeHandler:)];
    [self.contentMenuView addGestureRecognizer:self.panGesture]; // Should apply
        
//    NSLog(@"-->> %f", CGRectGetMinY(self.contentMenuView.frame));
//    NSLog(@"-->> %f", CGRectGetMaxY(self.contentMenuView.frame));
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

#pragma mark
#pragma Gesture Recogniser Actions
- (void)feedDataAvailableNotificationReceived:(NSNotification *)notification
{    
    if ([[[notification userInfo] objectForKey:kNOTIFICATION_KEYPATH] isEqual: kKEYPATH_FEED_FEED]) {
        self.feed = (TSFeed*)[[notification userInfo] objectForKey:kNOTIFICATION_DATA];
       
        [self randomise];
    }
}

- (void)viewDidUnload
{
    [self setToolMenuView:nil];
    [self setContentMenuView:nil];
    [self setPanGesture:nil];
    [super viewDidUnload];
}

- (IBAction)shakeButtonPressed:(id)sender
{
    [self randomise];
}

- (IBAction)menuSwipeHandler:(UIPanGestureRecognizer *)sender {
    
    if (sender.state == UIGestureRecognizerStateBegan) {
        // Only allow drag from bottom part of view??
        // If icon placed at the bottom.
    }
    else if (sender.state == UIGestureRecognizerStateChanged) {
        
        CGPoint translation = [sender translationInView:self.view];
        CGFloat y = sender.view.center.y + translation.y;
        
        up = (translation.y < 0) ? YES : NO;
        
        if(CGRectGetMaxY(sender.view.frame) < overHang && up)
            return;
        else if(0 <= self.contentMenuView.frame.origin.y+translation.y && !up)
            return;

        sender.view.center = CGPointMake(sender.view.center.x, y);
        
        [sender setTranslation:CGPointMake(0, 0) inView:self.view];
    }
    else if (sender.state == UIGestureRecognizerStateEnded) {
        [UIView animateWithDuration:0.5
                         animations:^(void){
                             CGRect frame = self.contentMenuView.frame;
                             frame.origin.y = (up) ? (overHang - self.contentMenuView.frame.size.height) : 0;
                             self.contentMenuView.frame = frame;
                         }];
    }
}

#pragma mark
#pragma Shaking-Motion Events
- (void)motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
}

- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    [self randomise];
}

- (void)motionCancelled:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
}

#pragma mark
#pragma Random Selection
- (void)randomise
{
    NSUInteger totalArticles = [self.feed.articles count];
    NSMutableArray *randomNumbers = [[NSMutableArray alloc] initWithCapacity:5];
    
    while ( [randomNumbers count] < 5)
    {
        NSUInteger randomIndex = arc4random() % totalArticles;
//        Debug(@"--->%i", randomIndex);
        
        BOOL matchFound = NO;
        
        for (int i=0; i<[randomNumbers count]; i++) {
            if([[randomNumbers objectAtIndex:i] intValue] == randomIndex) {
//                Debug(@"MATCH");
                matchFound = YES;
                break;
            }
        }
        
        if(matchFound == NO) {
            [randomNumbers addObject:[NSNumber numberWithInt:randomIndex]];
        }
    }
    
    TSArticle* article = nil;
    int i=0;
    
    for( PSCell* cell in self.psCells) {
        NSUInteger index = [[randomNumbers objectAtIndex:i] integerValue];
        article = [self.feed.articles objectAtIndex:index];
        i++;
        
        [cell setArticle:article];
        [cell load];
    }
}


#pragma mark
#pragma PSCellDelegate
- (void)cellTappedWithCell:(PSCell*)cell
{
    self.detailedView = nil;
    self.detailedView = [[PSDetailedViewController alloc] initWithFrame:cell.frame];
    [self.detailedView setArticle:cell.article];

    [self.view addSubview:self.detailedView.view];
    
    [self.detailedView animate];
}

@end
