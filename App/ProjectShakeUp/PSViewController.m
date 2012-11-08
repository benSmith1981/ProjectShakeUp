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
#import "FloatingLayerGenerator.h"
#define LAYER_HEIGHT 150.0f
#define LAYER_WIDTH 75.0f

@interface PSViewController ()

@end

@implementation PSViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

	// Do any additional setup after loading the view, typically from a nib.
    activeLayer = [[UIView alloc]init];
    
    FloatingLayerGenerator *FLView = [[FloatingLayerGenerator alloc]init];
    
    UIView *tempView = [FLView generateFloatingLayerWithRect:CGRectMake(50, 50, LAYER_HEIGHT, LAYER_HEIGHT) andRotation:45];
    floatingViews = [[NSMutableArray alloc]init];
    [floatingViews addObject:tempView];
    
    tempView = [FLView generateFloatingLayerWithRect:CGRectMake(150, 150, LAYER_HEIGHT, LAYER_HEIGHT) andRotation:180];
    [floatingViews addObject:tempView];
    
    tempView = [FLView generateFloatingLayerWithRect:CGRectMake(200, 250, LAYER_HEIGHT, LAYER_HEIGHT) andRotation:90];
    [floatingViews addObject:tempView];
    
    tempView = [FLView generateFloatingLayerWithRect:CGRectMake(170, 300, LAYER_HEIGHT, LAYER_HEIGHT) andRotation:10];
    [floatingViews addObject:tempView];
    
    for (FloatingLayerGenerator *tempLayer in floatingViews) {
        [self.view addSubview:tempLayer];
    }
    //setup pan gesture to pick up
    
    panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(move:)];
    [panRecognizer setMinimumNumberOfTouches:1];
    [panRecognizer setMaximumNumberOfTouches:1];
    [panRecognizer setDelegate:self];
    [self.view addGestureRecognizer:panRecognizer];
    
    tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped:)];
    [tapRecognizer setNumberOfTapsRequired:1];
    [tapRecognizer setDelegate:self];
    [self.view addGestureRecognizer:tapRecognizer];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(feedDataAvailableNotificationReceived:)
                                                 name:FEED_UPDATE_NOTIFICATION
                                               object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark Gesture recognizer actions

- (void) touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event{
    objectMoving = TRUE;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    
}


-(void)tapped:(id)sender {
    
    CGPoint touchPoint = [(UIGestureRecognizer*)sender locationInView:self.view];
    
    for (FloatingLayerGenerator *floatingView in floatingViews) {
        if (CGRectContainsPoint(floatingView.frame, touchPoint))
        {
            activeLayer = floatingView;
            
        }
    }
    
    [self.view bringSubviewToFront:activeLayer];
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

#pragma mark moveLayer

-(void)move:(id)sender{
    
    CGPoint touchPoint = [(UIGestureRecognizer*)sender locationInView:self.view];
    for (FloatingLayerGenerator *floatingView in floatingViews) {
        if (CGRectContainsPoint(floatingView.frame, touchPoint) && !objectMoving)
        {
            activeLayer = floatingView;
        }
    }
    
    CGPoint translatedPoint = [(UIPanGestureRecognizer*)sender translationInView:self.view];
    
    if([(UIPanGestureRecognizer*)sender state] == UIGestureRecognizerStateBegan) {
        _firstX = [activeLayer center].x;
        _firstY = [activeLayer center].y;
        
    }
    
    translatedPoint = CGPointMake(_firstX+translatedPoint.x, _firstY+translatedPoint.y);
    [activeLayer setCenter:translatedPoint];
    
}

-(void)feedDataAvailableNotificationReceived:(NSNotification *)notification
{    
    if ([[[notification userInfo] objectForKey:kNOTIFICATION_KEYPATH] isEqual: kKEYPATH_FEED_FEED]) {
        TSFeed* feed = (TSFeed*)[[notification userInfo] objectForKey:kNOTIFICATION_DATA];
        TSArticle* article = (TSArticle*)[feed.articles objectAtIndex:0];
        Debug(@"%@", article.title);
        Debug(@"%@", article.url);
        Debug(@"%@", article.story);
    }
}

@end
