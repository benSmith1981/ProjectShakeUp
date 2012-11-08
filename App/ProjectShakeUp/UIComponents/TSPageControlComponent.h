//
//  TSPageControlComponent.h
//  TheSun
//
//  Created by Martin Lloyd on 01/10/2012.
//
//

#import <Foundation/Foundation.h>

@protocol TSPageControlComponentDelegate;

@interface TSPageControlComponent : UIView
{
@private
    NSInteger _currentPage;
    NSInteger _numberOfPages;
    UIColor *dotColorCurrentPage;
    UIColor *dotColorOtherPage;
    NSObject<TSPageControlComponentDelegate> *delegate;
}

// Set these to control the PageControl.
@property (nonatomic) NSInteger currentPage;
@property (nonatomic) NSInteger numberOfPages;

// Customize these as well as the backgroundColor property.
@property (nonatomic, strong) UIColor *dotColorCurrentPage;
@property (nonatomic, strong) UIColor *dotColorOtherPage;

// Optional delegate for callbacks when user taps a page dot.
@property (nonatomic, strong) NSObject<TSPageControlComponentDelegate> *delegate;

@end

@protocol WelcomePageControlDelegate<NSObject>
@optional
- (void)pageControlPageDidChange:(TSPageControlComponent *)pageControl;
@end
