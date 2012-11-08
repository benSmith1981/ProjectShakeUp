//
//  TSPlistHelper.h
//  TheSun
//
//  Created by Martin Lloyd on 24/10/2012.
//
//

#import <Foundation/Foundation.h>

@interface TSPlistHelper : NSObject

+ (NSString*)plistLookup:(NSString*)plistName WithKey:(NSString*)key;
+ (NSDictionary*)plistHelper:(NSString*)plist;
+ (NSString*)getStringPlistHelper:(NSDictionary*)plist WithKey:(NSString*)key;

@end
