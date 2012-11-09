//
//  TSFeedParser.m
//  TheSun
//
//  Created by Martin Lloyd on 7/20/12.
//  Copyright (c) 2012 NewsInternational. All rights reserved.
//

#import "TSFeedParser.h"
#import "NSDate+Format.h"
#import "TSServiceKeys.h"
#import "TSFeed.h"
#import "TSArticle.h"
#import "Logging.h"

@interface TSFeedParser ()
{
    TSArticle* article;
}
@property (nonatomic, strong) TSFeed* feed;
@property (nonatomic, strong) NSString* currentElement;
@property (nonatomic, strong) NSThread* xmlParseThread;

-(void) startParse: (id)param;

@end

@implementation TSFeedParser
@synthesize delegate = _delegate;
@synthesize feed = _feed;
@synthesize currentElement = _currentElement;
@synthesize xmlParseThread = _xmlParseThread;

-(void) parseData:(NSData*) data ServiceKey:(NSString*) serviceKey
{
    if ([serviceKey isEqualToString:kFEED_SERVICE_KEY]) {
        _xmlParseThread = [[NSThread alloc] initWithTarget:self selector:@selector(startParse:) object:data];
        [_xmlParseThread start];
    }
}

-(void) startParse: (id)param
{
    _feed = [[TSFeed alloc] init];
    _feed.articles = [[NSMutableArray alloc] init];
    
    NSXMLParser *parser = [[NSXMLParser alloc] initWithData:param];
    [parser setDelegate:self];
    [parser parse];
}

#pragma XML/ BUSINESS OBJECT SPEICIFIC PARSING METHODS

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    _currentElement = elementName;
    
    if([_currentElement isEqualToString:@"enclosure"] && article.url == nil) {
        [article setUrl:[attributeDict objectForKey:@"url"]];
    }
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    if (_feed.title==nil && [_currentElement isEqualToString:@"title"]) {
        [_feed setTitle:string];
    }
    else if(![string isEqualToString:@"\n"]) {
        if([_currentElement isEqualToString:@"title"]) {
            article = [[TSArticle alloc] initWithArticleTitle:string];
            [self.feed.articles addObject:article];
        }
        else if([_currentElement isEqualToString:@"tol-text:story"]) {
            [article setStory:string];
        }
    }
}

- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError
{
}

- (void)parserDidEndDocument:(NSXMLParser *)parser
{
    if (self.delegate) {
        
        __block id dataBlock = self.feed;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.delegate didFinishParsing:dataBlock ForServiceKey:kFEED_SERVICE_KEY];
        });
    }
 
    _currentElement = nil;
    _feed = nil;
    _xmlParseThread = nil;
}

@end
