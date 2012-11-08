//
//  TSFeed.m
//  TheSun
//
//  Created by Martin Lloyd on 7/18/12.
//  Ported from TheSunMatchCentre by Martin Lloyd on 9/25/12.
//  Copyright (c) 2012 NewsInternational. All rights reserved.
//

#import "TSFeed.h"
#import "TSServiceKeys.h"

@interface TSFeed ()

@end

@implementation TSFeed
@synthesize parser = _parser;

// static(Class level) private variables
static TSFeed* tsFeed;
static TSFeed *internalManagedObj;

// synthesize properties
@synthesize title = _title;
@synthesize articles = _articles;

/*
//Custom initializer
*/ 
-(id)initWithFeedTitle:(NSString*) title Articles:(NSMutableArray*) articles
{
    self = [super init];
    if (self) {
        _title = title;
        _articles = articles;
        
        //parser init
        _parser = [[TSFeedParser alloc] init]; // TODO: Need to decided if this is best creating many responses. Release this memory.
        _parser.delegate = self;
    }
    
    return self;
}

-(id)init
{
    self = [self initWithFeedTitle:nil Articles:nil];
    return self;
}

#pragma OBJECT PROPERTIES


#pragma STATIC/ CLASS PUBLIC METHODS
+(TSFeed*) getFeed:(NSString*)requestURL
{
    if (!tsFeed) {
        [TSFeed FireOffAsynRequestToURL:requestURL
                  WithServiceRequestKey:kFEED_SERVICE_KEY
                        ResponseHandler:[TSFeed internalManagedObject]];
    }
    
    return tsFeed;
}

#pragma STATIC OVERRIDDEN METHOD
+(id)internalManagedObject
{
    if (!internalManagedObj) {
        internalManagedObj = [[TSFeed alloc] init];
    }
    
    return internalManagedObj;
}

#pragma SMTHTTPRequestDelegate methods
-(void)requestFinishedWithData:(NSData *)responseData ServiceRequestKey:(NSString *)serviceRequestKey HttpHeaders:(NSDictionary *)headers
{ 
    [super requestFinishedWithData:responseData ServiceRequestKey:serviceRequestKey HttpHeaders:headers];
    
    // parse the service data
    if(_parser == nil) {
        @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                       reason:[NSString stringWithFormat:@"TSFeed parser not instantiated"]
                                     userInfo:nil];
    }
    
    [_parser parseData:responseData ServiceKey:serviceRequestKey];
}


#pragma SMTParserDelegate
-(void)didFinishParsing:(id)parsedData ForServiceKey:(NSString *)serviceKey
{
    NSString *keyPath = nil;
    
    if ([serviceKey isEqualToString:kFEED_SERVICE_KEY]) {
        // for this service key, we know the parsedData is Array of TSMenuList objects
        tsFeed = parsedData;
        keyPath = [self getKeyPathByServiceKey:kFEED_SERVICE_KEY];
    }

     NSDictionary *parsedDataDic = [NSDictionary dictionaryWithObjectsAndKeys:
                                    parsedData, kNOTIFICATION_DATA, 
                                    serviceKey, kNOTIFICATION_SERVICEKEY,
                                    keyPath,    kNOTIFICATION_KEYPATH,
                                    nil];
     
     //raise the notification to the caller of Feed object    
    [[NSNotificationCenter defaultCenter] postNotificationName:FEED_UPDATE_NOTIFICATION
                                                        object:self 
                                                      userInfo:parsedDataDic];
}

#pragma HELPER INSTANCE METHODS
-(NSString*) getKeyPathByServiceKey:(NSString*) serviceKey
{
    NSString *keyPath = nil;

    if ([serviceKey isEqualToString:kFEED_SERVICE_KEY]) {
        keyPath = kKEYPATH_FEED_FEED;
    }
    
    return keyPath;

}

-(void) raiseErrorNotificationForHTTPError:(NSString *)errorName ServiceRequestKey:(NSString *)serviceRequestKey
{
    NSString *keyPath = [self getKeyPathByServiceKey:serviceRequestKey];
    NSString *errorMsg = [NSString stringWithFormat:@"%@ %@", @"Error loading",keyPath];
    
    NSDictionary *errorDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                             errorName, kNOTIFICATION_ERROR, 
                                             serviceRequestKey, kNOTIFICATION_SERVICEKEY,
                                             keyPath, kNOTIFICATION_KEYPATH,
                                             errorMsg, kNOTIFICATION_ERROR_MESSAGE,
                                             nil];
    
    //raise the notification to the caller of Competition object    
    [[NSNotificationCenter defaultCenter] postNotificationName:FEED_HTTP_ERROR_NOTIFICATION
                                                        object:self 
                                                      userInfo:errorDictionary];
}


-(void) raiseErrorNotificationForDataError:(NSString *)errorName ServiceRequestKey:(NSString *)serviceRequestKey
{
    NSString *keyPath = [self getKeyPathByServiceKey:serviceRequestKey];
    NSString *errorMsg = [NSString stringWithFormat:@"%@ %@", @"data error found for",keyPath];
    
    NSDictionary *errorDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                     errorName, kNOTIFICATION_ERROR, 
                                     serviceRequestKey, kNOTIFICATION_SERVICEKEY,
                                     keyPath, kNOTIFICATION_KEYPATH,
                                     errorMsg, kNOTIFICATION_ERROR_MESSAGE,
                                     nil];
    
    //raise the notification to the caller of Competition object    
    [[NSNotificationCenter defaultCenter] postNotificationName:FEED_DATA_ERROR_NOTIFICATION
                                                        object:self 
                                                      userInfo:errorDictionary];
}

@end



