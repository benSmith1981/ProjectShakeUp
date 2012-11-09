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
    PSCell* topLeftView     = [[PSCell alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.view.frame) + border,
                                                                       CGRectGetMinY(self.view.frame) + border,
                                                                       size.width, size.height)];
    // Top Right
    PSCell* topRightView    = [[PSCell alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.view.frame) - (border + size.width),
                                                                       CGRectGetMinY(topLeftView.frame),
                                                                       size.width, size.height)];
    // Middle
    PSCell* middleView      = [[PSCell alloc] initWithFrame:CGRectMake(CGRectGetMaxX(topLeftView.frame),
                                                                       CGRectGetMaxY(topLeftView.frame) + border,
                                                                       size.width, size.height)];
    // Bottom Left
    PSCell* bottomLeftView  = [[PSCell alloc] initWithFrame:CGRectMake(CGRectGetMinX(topLeftView.frame),
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
    
    //CURRENTLY I CAN'T GET THIS TO WORK SO I COMMENTED IT OUT, MAYBE YOU CAN HELP MARTIN? I AM NOT SURE HOW TO MOVE VIEWS WITH PANGESTURE RECOGNISER, I JUST THOUGHT IT WOUDL BE NICE TO HAVE THIS IN...
//    //Setup array of floating views and active layer
//    activeLayer = [[UIView alloc]init];
//    floatingViews = [[NSArray alloc]initWithObjects:topLeftView,topRightView,middleView,bottomLeftView,bottonRightView, nil];
//
//    //setup pan gesture to pick up
//    panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(move:)];
//    [panRecognizer setMinimumNumberOfTouches:1];
//    [panRecognizer setMaximumNumberOfTouches:1];
//    [panRecognizer setDelegate:self];
//    [self.view addGestureRecognizer:panRecognizer];
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

- (void)feedDataAvailableNotificationReceived:(NSNotification *)notification
{    
    if ([[[notification userInfo] objectForKey:kNOTIFICATION_KEYPATH] isEqual: kKEYPATH_FEED_FEED]) {
        self.feed = (TSFeed*)[[notification userInfo] objectForKey:kNOTIFICATION_DATA];
       
        [self randomise];
    }
}

- (void)viewDidUnload {
    [super viewDidUnload];
}

- (IBAction)shakeButtonPressed:(id)sender {
//    UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Shaking!"
//                                                      message:@"This will load another 5 random articles."
//                                                     delegate:nil
//                                            cancelButtonTitle:@"OK"
//                                            otherButtonTitles:nil];
//    [message show];
    [self randomise];
}

#pragma mark
#pragma Shaking-Motion Events
- (void)motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
}

- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Shake" message:@"Ended" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
//    [alert show];
    
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
    
    
    for(int i=0; i<5; i++) {
        NSUInteger randomIndex = arc4random() % totalArticles;
//        NSLog(@"--->%i", randomIndex);
        [randomNumbers addObject:[NSNumber numberWithInt:randomIndex]];
    }
    
    TSArticle* article = nil;
    int i=0;
    
    for( PSCell* cell in self.psCells) {
        NSUInteger index = [[randomNumbers objectAtIndex:i] integerValue];
        article = [self.feed.articles objectAtIndex:index];
        i++;
        [cell.title setText:article.title];
        NSURL* url = [NSURL URLWithString:article.url];
        [cell.image setImageWithURL:url placeholderImage:[UIImage imageNamed:@"placeholder.jpg"]];
    }
}


#pragma mark UIGestureRegognizerDelegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return ![gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]] && ![gestureRecognizer isKindOfClass:[UITapGestureRecognizer class]];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    
    if ([touch.view isKindOfClass:[UIButton class]]) {      //change it to your condition
        return NO;
    }
    return YES;
}

#pragma mark Gesture recognizer actions

-(void)move:(id)sender{
    
    UIPanGestureRecognizer *gestureRecogniser = (UIPanGestureRecognizer*)sender;
    
    //CGPoint touchPoint = [(UIGestureRecognizer*)sender locationInView:self.view];
//    for (PSCell *floatingView in floatingViews) {
//        if (CGRectContainsPoint(floatingView.frame, touchPoint))
//        {
//            activeLayer = floatingView;
//        }
//    }
//    activeLayer = gestureRecogniser.view;

//    CGPoint translatedPoint = [gestureRecogniser translationInView:self.view];
//    
//    if([gestureRecogniser state] == UIGestureRecognizerStateBegan) {
//        firstX = [activeLayer center].x;
//        firstY = [activeLayer center].y;
//        
//    }
//    
//    translatedPoint = CGPointMake(firstX+translatedPoint.x, firstY+translatedPoint.y);
//    [gestureRecogniser.view setCenter:translatedPoint];

    CGPoint translatedPoint = [(UIPanGestureRecognizer*)sender translationInView:self.view];

    if([(UIPanGestureRecognizer*)sender state] == UIGestureRecognizerStateBegan) {
        _firstX = [gestureRecogniser.view center].x;
        _firstY = [gestureRecogniser.view center].y;
    }
    
    translatedPoint = CGPointMake(_firstX+translatedPoint.x, _firstY+translatedPoint.y);
    [gestureRecogniser.view setCenter:translatedPoint];
}
@end
