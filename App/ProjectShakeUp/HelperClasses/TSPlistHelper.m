//
//  TSPlistHelper.m
//  TheSun
//
//  Created by Martin Lloyd on 24/10/2012.
//
//

#import "TSPlistHelper.h"

@implementation TSPlistHelper

+ (NSString*)plistLookup:(NSString*)plistName WithKey:(NSString*)key
{
    return [TSPlistHelper getStringPlistHelper:[TSPlistHelper plistHelper:plistName] WithKey:key];
}

+ (NSDictionary*)plistHelper:(NSString*)plist
{
    NSString *path = [[NSBundle mainBundle] pathForResource:plist ofType:@"plist"];
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile: path];
    return dict;
}

+ (NSString*)getStringPlistHelper:(NSDictionary*)plist WithKey:(NSString*)key
{
    id value = [plist objectForKey:key];
    
    if(value == nil) {
        @throw [NSException exceptionWithName:NSObjectNotAvailableException
                                       reason:@"Plist Lookup Error"
                                     userInfo:plist];
    }
    
    return value;
}

@end
