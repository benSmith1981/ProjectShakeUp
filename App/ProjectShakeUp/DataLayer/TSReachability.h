//
//  TSReachability.h
//  TheSun
//
//  Created by Martin Lloyd on 7/26/12.
//  Copyright (c) 2012 NewsInternational. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Reachability.h"

@interface TSReachability : NSObject

- (BOOL) connectedToNetwork;
- (BOOL) checkInternet;

@property(nonatomic, readonly) Reachability *reachability;

+(TSReachability*) sharedReachability;

@end
