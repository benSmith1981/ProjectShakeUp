//
//  TSParser.m
//  TheSun
//
//  Created by Martin Lloyd on 8/14/12.
//  Copyright (c) 2012 NewsInternational. All rights reserved.
//

#import "TSParser.h"

@implementation TSParser

-(BOOL) isValidJSONElement:(id) element
{
    if (element && ![element isEqual:[NSNull null]])
        return true;
    
    return false;
}

-(NSArray *)getArrayOfCommaDelimatedJSONString:(NSString *)element
{    
    if (![self isValidJSONElement:element]) 
        return nil;
    
    return [element componentsSeparatedByString:@","];
}

@end
