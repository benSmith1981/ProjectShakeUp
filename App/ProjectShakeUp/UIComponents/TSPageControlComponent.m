//
//  TSPageControlComponent.m
//  TheSun
//
//  Created by Martin Lloyd on 01/10/2012.
//
//

#import "TSPageControlComponent.h"

#define kDotDiameter 9.0
#define kDotSpacer 9.0

@implementation TSPageControlComponent

@synthesize dotColorCurrentPage;
@synthesize dotColorOtherPage;
@synthesize delegate;

- (NSInteger)currentPage
{
    return _currentPage;
}

- (void)setCurrentPage:(NSInteger)page
{
    _currentPage = MIN(MAX(0, page), _numberOfPages-1);
    [self setNeedsDisplay];
}

- (NSInteger)numberOfPages
{
    return _numberOfPages;
}

- (void)setNumberOfPages:(NSInteger)pages
{
    _numberOfPages = MAX(0, pages);
    _currentPage = MIN(MAX(0, _currentPage), _numberOfPages-1);
    [self setNeedsDisplay];
}

- (id)initWithFrame:(CGRect)frame
{
    if ((self = [super initWithFrame:frame]))
    {
        // Default colors.
        self.backgroundColor = [UIColor clearColor];
        self.dotColorCurrentPage = [UIColor blackColor];
        self.dotColorOtherPage = [UIColor lightGrayColor];
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetAllowsAntialiasing(context, true);
    
    CGRect currentBounds = self.bounds;
    CGFloat dotsWidth = self.numberOfPages*kDotDiameter + MAX(0, self.numberOfPages-1)*kDotSpacer;
    CGFloat x = CGRectGetMidX(currentBounds)-dotsWidth/2;
    CGFloat y = CGRectGetMidY(currentBounds)-kDotDiameter/2;
    for (int i=0; i<_numberOfPages; i++)
    {
        CGRect circleRect = CGRectMake(x, y, kDotDiameter, kDotDiameter);
        if (i == _currentPage)
        {
            CGContextSetFillColorWithColor(context, self.dotColorCurrentPage.CGColor);
        }
        else
        {
            CGContextSetFillColorWithColor(context, self.dotColorOtherPage.CGColor);
        }
        CGContextFillEllipseInRect(context, circleRect);
        x += kDotDiameter + kDotSpacer;
    }
}

//- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
//    
//    CGPoint touchPoint = [[[event touchesForView:self] anyObject] locationInView:self];
//    
//    CGRect currentBounds = self.bounds;
//    CGFloat x = touchPoint.x - CGRectGetMidX(currentBounds);
//    
//    if(x<0 && self.currentPage>=0){
//        self.currentPage--;
//        [self.delegate pageControlPageDidChange:self];
//    }
//    else if(x>0 && self.currentPage<self.numberOfPages-1){
//        self.currentPage++;
//        [self.delegate pageControlPageDidChange:self];
//    }
//}
@end
