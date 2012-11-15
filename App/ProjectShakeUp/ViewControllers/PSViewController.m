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
#import "TSServiceKeys.h"

static CGFloat const overHang = 45;

@interface PSViewController ()
{
    BOOL up;
}

@property (weak, nonatomic) IBOutlet UIView *toolMenuView;
@property (weak, nonatomic) IBOutlet UIView *contentMenuView;

@property (strong, nonatomic) UIPanGestureRecognizer* panGesture;

@property (strong, nonatomic) NSArray* psCells;
@property (strong, nonatomic) NSArray* articles;
@property (strong, nonatomic) PSDetailedViewController* detailedView;

- (IBAction)shakeButtonPressed:(id)sender;

@end

@implementation PSViewController
@synthesize psCells = _psCells;
@synthesize articles = _articles;
@synthesize detailedView = _detailedView;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.contentMenuView.backgroundColor = RGB(0, 81, 125);
    self.toolMenuView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"settingsscreen.png"]];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(feedDataAvailableNotificationReceived:)
                                                 name:FEED_UPDATE_NOTIFICATION
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(feedDataFailedNotificationReceived:)
                                                 name:FEED_HTTP_ERROR_NOTIFICATION
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(feedDataFailedNotificationReceived:)
                                                 name:FEED_DATA_ERROR_NOTIFICATION
                                               object:nil];

    CGSize size = CGSizeMake(118, 160);
    CGFloat borderX = 10;
    CGFloat topBorderY = 40;
    CGFloat bottomBorderY = 70;
    
    // Top Left
    PSCell* topLeftView     = [[PSCell alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.view.frame) + borderX,
                                                                       CGRectGetMinY(self.view.frame) + topBorderY,
                                                                       size.width, size.height)];
    // Top Right
    PSCell* topRightView    = [[PSCell alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.view.frame) - (borderX + size.width),
                                                                       CGRectGetMinY(topLeftView.frame),
                                                                       size.width, size.height)];
    // Middle
    PSCell* middleView      = [[PSCell alloc] initWithFrame:CGRectMake(CGRectGetMidX(topLeftView.frame) + 30,
                                                                       CGRectGetMidY(topLeftView.frame) + 60,
                                                                       size.width, size.height)];
    // Bottom Left
    PSCell* bottomLeftView  = [[PSCell alloc] initWithFrame:CGRectMake(CGRectGetMinX(topLeftView.frame),
                                                                       CGRectGetMaxY(middleView.frame) - bottomBorderY,
                                                                       size.width, size.height)];
    // Bottom Right
    PSCell* bottonRightView = [[PSCell alloc] initWithFrame:CGRectMake(CGRectGetMinX(topRightView.frame),
                                                                       CGRectGetMaxY(middleView.frame) - bottomBorderY,
                                                                       size.width, size.height)];
    
    self.psCells = [[NSArray alloc] initWithObjects:topLeftView, topRightView, bottomLeftView, bottonRightView, middleView, nil];
    
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

- (void)viewDidUnload
{
    [self setToolMenuView:nil];
    [self setContentMenuView:nil];
    [self setPanGesture:nil];
    [super viewDidUnload];
}

#pragma mark
#pragma ManagedObject Notification Handlers
- (void)feedDataAvailableNotificationReceived:(NSNotification *)notification
{
    if ([[[notification userInfo] objectForKey:kNOTIFICATION_KEYPATH] isEqual: kKEYPATH_FEED_SUN]) {
        // Fire times request.
        self.articles = [(TSFeed*)[[notification userInfo] objectForKey:kNOTIFICATION_DATA] articles];

        [TSFeed getFeed:kTIMES_FEED_SERVICE_KEY];
    }
    else if ([[[notification userInfo] objectForKey:kNOTIFICATION_KEYPATH] isEqual: kKEYPATH_FEED_TIMES]) {
        // Add self.articles.
        NSMutableArray *newArray = [(TSFeed*)[[notification userInfo] objectForKey:kNOTIFICATION_DATA] articles];
        
        [newArray addObjectsFromArray:self.articles];
        self.articles = nil;
        self.articles = newArray;

        [self randomise];
    }
}

- (void)feedDataFailedNotificationReceived:(NSNotification *)notification
{
    if ([[[notification userInfo] objectForKey:kNOTIFICATION_KEYPATH] isEqual: kKEYPATH_FEED_SUN]) {
        Debug(@"Error no %@ Feed", kKEYPATH_FEED_SUN);
        [TSFeed getFeed:kTIMES_FEED_SERVICE_KEY];
    }
    else if ([[[notification userInfo] objectForKey:kNOTIFICATION_KEYPATH] isEqual: kKEYPATH_FEED_TIMES]) {
        Debug(@"Error no %@ Feed", kKEYPATH_FEED_TIMES);
        
        if([self.articles count] > 0) {
            [self randomise];
        }
    }
}

- (void)refresh
{
    for( PSCell* cell in self.psCells) {
        [cell load];
    }
}

#pragma mark
#pragma Gesture Recogniser Actions
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
    NSUInteger totalArticles = [self.articles count];
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
        article = [self.articles objectAtIndex:index];
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
