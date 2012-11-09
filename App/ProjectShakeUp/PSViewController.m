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
#import "PSCell.h"

@interface PSViewController ()
@property (strong, nonatomic) NSArray* psCells;
@end

@implementation PSViewController
@synthesize psCells = _psCells;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
//	// Do any additional setup after loading the view, typically from a nib.
//    activeLayer = [[UIView alloc]init];
//    floatingViews = [[NSMutableArray alloc]init];
//    
//    FloatingLayerGenerator *FLView = [[FloatingLayerGenerator alloc]init];
//    
//    UIView *tempView = [FLView generateFloatingLayerWithRect:CGRectMake(10, 10, LAYER_HEIGHT, LAYER_HEIGHT) andRotation:45];
//    [floatingViews addObject:tempView];
//    
//    tempView = [FLView generateFloatingLayerWithRect:CGRectMake(225, 10, LAYER_HEIGHT, LAYER_HEIGHT) andRotation:180];
//    [floatingViews addObject:tempView];
//    
//    tempView = [FLView generateFloatingLayerWithRect:CGRectMake(10, 250, LAYER_HEIGHT, LAYER_HEIGHT) andRotation:90];
//    [floatingViews addObject:tempView];
//    
//    tempView = [FLView generateFloatingLayerWithRect:CGRectMake(225, 250, LAYER_HEIGHT, LAYER_HEIGHT) andRotation:10];
//    [floatingViews addObject:tempView];
//    
//    tempView = [FLView generateFloatingLayerWithRect:CGRectMake(150, 150, LAYER_HEIGHT, LAYER_HEIGHT) andRotation:10];
//    [floatingViews addObject:tempView];
//       
//    for (FloatingLayerGenerator *tempLayer in floatingViews) {
//        [self.view addSubview:tempLayer];
//    }
//    //setup pan gesture to pick up
//    
//    panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(move:)];
//    [panRecognizer setMinimumNumberOfTouches:1];
//    [panRecognizer setMaximumNumberOfTouches:1];
//    [panRecognizer setDelegate:self];
//    [self.view addGestureRecognizer:panRecognizer];
//    
//    tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped:)];
//    [tapRecognizer setNumberOfTapsRequired:1];
//    [tapRecognizer setDelegate:self];
//    [self.view addGestureRecognizer:tapRecognizer];
    
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
    [self.view addSubview:topLeftView];
    // Top Right
    PSCell* topRightView = [[PSCell alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.view.frame) - (border + size.width),
                                                                    CGRectGetMinY(topLeftView.frame),
                                                                    size.width, size.height)];
    [self.view addSubview:topRightView];
    // Middle
    PSCell* middleView = [[PSCell alloc] initWithFrame:CGRectMake(CGRectGetMaxX(topLeftView.frame),
                                                                  CGRectGetMaxY(topLeftView.frame) + border,
                                                                  size.width, size.height)];
    [self.view addSubview:middleView];
    // Bottom Left
    PSCell* bottomLeftView = [[PSCell alloc] initWithFrame:CGRectMake(CGRectGetMinX(topLeftView.frame),
                                                                      CGRectGetMaxY(middleView.frame) + border,
                                                                      size.width, size.height)];
    [self.view addSubview:bottomLeftView];
    // Bottom Right
    PSCell* bottonRightView = [[PSCell alloc] initWithFrame:CGRectMake(CGRectGetMinX(topRightView.frame),
                                                                       CGRectGetMaxY(middleView.frame) + border,
                                                                       size.width, size.height)];
    [self.view addSubview:bottonRightView];
    
    self.psCells = [[NSArray alloc] initWithObjects:topLeftView, topRightView, middleView, bottomLeftView, bottonRightView, nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark Gesture recognizer actions

//- (void) touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event{
//    objectMoving = TRUE;
//}
//
//- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
//{
//    
//}
//
//
//-(void)tapped:(id)sender {
//    
//    CGPoint touchPoint = [(UIGestureRecognizer*)sender locationInView:self.view];
//    
//    for (FloatingLayerGenerator *floatingView in floatingViews) {
//        if (CGRectContainsPoint(floatingView.frame, touchPoint))
//        {
//            activeLayer = floatingView;
//            
//        }
//    }
//    
//    [self.view bringSubviewToFront:activeLayer];
//}

//#pragma mark UIGestureRegognizerDelegate
//
//- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
//    return ![gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]] && ![gestureRecognizer isKindOfClass:[UITapGestureRecognizer class]];
//}
//
//- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
//    
//    if ([touch.view isKindOfClass:[UIButton class]]) {      //change it to your condition
//        return NO;
//    }
//    return YES;
//}
//
//#pragma mark moveLayer
//
//-(void)move:(id)sender{
//    
//    CGPoint touchPoint = [(UIGestureRecognizer*)sender locationInView:self.view];
//    for (FloatingLayerGenerator *floatingView in floatingViews) {
//        if (CGRectContainsPoint(floatingView.frame, touchPoint) && !objectMoving)
//        {
//            activeLayer = floatingView;
//        }
//    }
//    
//    CGPoint translatedPoint = [(UIPanGestureRecognizer*)sender translationInView:self.view];
//    
//    if([(UIPanGestureRecognizer*)sender state] == UIGestureRecognizerStateBegan) {
//        _firstX = [activeLayer center].x;
//        _firstY = [activeLayer center].y;
//        
//    }
//    
//    translatedPoint = CGPointMake(_firstX+translatedPoint.x, _firstY+translatedPoint.y);
//    [activeLayer setCenter:translatedPoint];
//    
//}

-(void)feedDataAvailableNotificationReceived:(NSNotification *)notification
{    
    if ([[[notification userInfo] objectForKey:kNOTIFICATION_KEYPATH] isEqual: kKEYPATH_FEED_FEED]) {
        TSFeed* feed = (TSFeed*)[[notification userInfo] objectForKey:kNOTIFICATION_DATA];
        TSArticle* article = (TSArticle*)[feed.articles objectAtIndex:0];
//        Debug(@"%@", article.title);
//        Debug(@"%@", article.url);
//        Debug(@"%@", article.story);
        
        int i=0;
        
        for( PSCell* cell in self.psCells) {
            article = [feed.articles objectAtIndex:i];
            i++;
            [cell.title setText:article.title];
        }
    }
}

- (void)viewDidUnload {
    [super viewDidUnload];
}
@end
