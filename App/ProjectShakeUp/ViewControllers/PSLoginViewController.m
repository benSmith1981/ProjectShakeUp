//
//  PSLoginViewController.m
//  ProjectShakeUp
//
//  Created by Martin Lloyd on 26/11/2012.
//  Copyright (c) 2012 News International. All rights reserved.
//

#import "PSLoginViewController.h"
#import <FacebookSDK/FacebookSDK.h>
#import "Logging.h"

@interface PSLoginViewController () <FBLoginViewDelegate>
@property (weak, nonatomic) IBOutlet UIButton *close;
@property (weak, nonatomic) IBOutlet UIView *loginView;
- (IBAction)closeButton:(id)sender;
@end

@implementation PSLoginViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.close.hidden = YES;
    
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = RGB(0, 81, 125);
    
    // Create Login View so that the app will be granted "status_update" permission.
    FBLoginView *login = [FBLoginView new];
    login.delegate = self;
    
    NSArray *permissions = [NSArray arrayWithObjects:@"email", nil];
    login.publishPermissions = permissions;
    login.defaultAudience = FBSessionDefaultAudienceEveryone;
    
    [self.loginView addSubview:login];
    [login sizeToFit];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)closeButton:(id)sender {
    [self dismissModalViewControllerAnimated:YES];
}

#pragma mark - FBLoginViewDelegate

- (void)loginViewShowingLoggedInUser:(FBLoginView *)loginView
{
    self.close.hidden = NO;
}

- (void)loginViewFetchedUserInfo:(FBLoginView *)loginView
                            user:(id<FBGraphUser>)user
{
    NSString* labelFirstName = [NSString stringWithFormat:@"Hello %@! \n %@", user.first_name, [user objectForKey:@"email"]];
                                
    UIAlertView *message = [[UIAlertView alloc] initWithTitle:labelFirstName
                                                      message:@"Logged in with facebook"
                                                     delegate:nil
                                            cancelButtonTitle:@"OK"
                                            otherButtonTitles:nil];
    [message show];
    
    Debug(@"%@", labelFirstName);
}

- (void)loginViewShowingLoggedOutUser:(FBLoginView *)loginView
{
    self.close.hidden = YES;
}

- (void)viewDidUnload
{
    [self setClose:nil];
    [self setLoginView:nil];
    [super viewDidUnload];
}
@end
