//
//  TSFeedParser.h
//  TheSun
//
//  Created by Martin Lloyd on 7/20/12.
//  Copyright (c) 2012 NewsInternational. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TSDataException.h"
#import "TSParser.h"

@protocol TSCompetitionParserDelegate;
@protocol TSDataExceptionDelegate;

@interface TSFeedParser : TSParser<NSXMLParserDelegate>

@property(nonatomic, unsafe_unretained) id<TSParserDelegate, TSDataExceptionDelegate> delegate;

-(void) parseData:(NSData*) data ServiceKey:(NSString*) serviceKey;

@end

