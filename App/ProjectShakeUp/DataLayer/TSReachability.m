//
//  TSReachability.m
//  TheSun
//
//  Created by Martin Lloyd on 7/26/12.
//  Copyright (c) 2012 NewsInternational. All rights reserved.
//

#import "TSReachability.h"
#import "Reachability.h"

@implementation TSReachability

@synthesize reachability = _reachability;

static TSReachability *tsReachability;

+(TSReachability*) sharedReachability
{
    if (!tsReachability) {
        tsReachability = [[TSReachability alloc] initSingleton];
    }
    
    return tsReachability;
}

-(id)initSingleton
{
    self = [super init];
    if (self) {
        _reachability = [[Reachability alloc] init];
    }
    
    return self;
}

-(id)init
{
    @throw [NSException exceptionWithName:@"ClassCannotBeInstantiatedException" 
                                   reason:@"SingletonObject. Use sharedReachability method instead" 
                                 userInfo:nil];
}
 
#pragma REACHIBILITY METHODS
- (BOOL) connectedToNetwork
{
	Reachability *r = [Reachability reachabilityWithHostName:@"www.google.co.uk"];
	NetworkStatus internetStatus = [r currentReachabilityStatus];
	BOOL internet;
	if ((internetStatus != ReachableViaWiFi) && (internetStatus != ReachableViaWWAN)) {
		internet = NO;
	} else {
		internet = YES;
	}
	return internet;
} 

-(BOOL) checkInternet
{
	//Make sure we have internet connectivity
	if([self connectedToNetwork] != YES)
	{
        UIAlertView *alert = nil;
        
        alert = [[UIAlertView alloc] initWithTitle:@"No Network Connectivity!" 
                                           message:@"No network connection found. An Internet connection is required for this application to work" delegate:nil 
                                 cancelButtonTitle:@"Ok" 
                                 otherButtonTitles:nil, nil];
        [alert show];
        
		return NO;
	}
	else {
		return YES;
	}
}

@end
