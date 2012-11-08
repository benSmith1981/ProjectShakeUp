//
//  TSParser.h
//  TheSun
//
//  Created by Martin Lloyd on 8/14/12.
//  Copyright (c) 2012 NewsInternational. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TSParser : NSObject
-(BOOL) isValidJSONElement:(id) element;
-(NSArray*) getArrayOfCommaDelimatedJSONString:(NSString*) element;
@end

@protocol TSParserDelegate
-(void) didFinishParsing:(id) parsedData ForServiceKey:(NSString*) serviceKey;
-(void) parseErrorOccurred:(NSString*) errorDescription ForServiceKey:(NSString*) serviceKey;
@end
