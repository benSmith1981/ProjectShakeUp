//
//  PSDetailedViewController.m
//  ProjectShakeUp
//
//  Created by Martin Lloyd on 09/11/2012.
//  Copyright (c) 2012 News International. All rights reserved.
//

#import "PSDetailedViewController.h"
#import "UIImageView+AFNetworking.h"
#import "TSArticle.h"

@interface PSDetailedViewController ()
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UIWebView *story;

- (IBAction)closeButtonPressed:(id)sender;
@end

@implementation PSDetailedViewController
@synthesize article = _article;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithNibName:@"PSDetailedViewController" bundle:nil];
    if (self) {
        // Custom initialization
        self.view.frame = frame;
        
        self.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-CondensedBlack" size:16.0];
        self.story.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"white-paper-texture-600x400.jpeg"]];
        
        self.image.contentMode = UIViewContentModeScaleAspectFit;
        self.story.scrollView.bounces = NO;
        self.story.delegate = self;
        
        self.titleLabel.hidden = YES;
        self.image.hidden = YES;
        self.story.hidden = YES;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.contentView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"white-paper-texture-600x400.jpeg"]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)animate
{
    [self.titleLabel setText:self.article.title];

    [self.image setImageWithURL:[NSURL URLWithString:self.article.url]
               placeholderImage:[UIImage imageNamed:@"placeholder.jpg"]];
    
    NSString *bundlePath = [[NSBundle mainBundle] pathForResource:@"Article" ofType:@"bundle"];
    NSURL *url = [[NSBundle bundleWithPath:bundlePath] URLForResource:@"article" withExtension:@"html"];
    NSString *html = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil];
    html = [html stringByReplacingOccurrencesOfString:@"<<<REPLACE>>>" withString:self.article.story];    
    
    NSURL *baseUrl = [NSURL fileURLWithPath:[[NSBundle mainBundle] bundlePath]];
    [self.story loadHTMLString:html baseURL:baseUrl];
    
    [UIView animateWithDuration:0.5
                     animations:^{
                         self.view.frame = self.view.superview.bounds;
                     }
                     completion:^(BOOL finished) {
                         self.titleLabel.hidden = NO;
                         self.image.hidden = NO;
                         self.story.hidden = NO;
                     }];
}

- (IBAction)closeButtonPressed:(id)sender
{
    [self.image cancelImageRequestOperation];
    
    [UIView animateWithDuration:0.5
                     animations:^{
                         self.view.alpha = 0;
                     }
                     completion:^(BOOL finished) {
                         [self.view removeFromSuperview];
                     }];
}

- (void)viewDidUnload {
    [self setTitle:nil];
    [self setImage:nil];
    [self setTitleLabel:nil];
    [self setStory:nil];
    [self setContentView:nil];
    [super viewDidUnload];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
//    CGRect frame = self.image.frame;
//    
//    CGFloat y = CGRectGetMaxY(self.view.frame) - CGRectGetMaxY(self.image.frame);
//    
//    frame.origin.y = y + 30;
//    
//    self.story.frame = frame;
}

@end
