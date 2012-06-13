//
//  WikiQuoter.m
//  WikiQuote
//
//  Created by Oleksandr Shtykhno on 28/05/2012.
//  Copyright (c) 2012 shtykhno.net. All rights reserved.
//

#define QUOTES_SIZE 100

#import "WikiQuoter.h"

typedef enum 
{
    EN, 
    RU
    
} WikiLanguages ;

@implementation WikiQuoter

SYNTHESIZE_SINGLETON_FOR_CLASS(WikiQuoter)

@synthesize quotes = _quotes;

#pragma mark -
#pragma Initialization and memory management

- (void) loadQuotesFromWiki:(WikiLanguages)language
{
    responseData = [[NSMutableData data] retain];
    
    // TODO:yukan apply language to the request 
    NSString *requestUrl = @"http://en.wikiquote.org/w/api.php?&grnnamespace=0&format=xmlfm&action=query&generator=random&grnlimit=5&export&exportnowrap";
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:requestUrl]];
        [[[NSURLConnection alloc] initWithRequest:request delegate:self] autorelease];
    TRC_ENTRY
}


- (NSURLRequest *)connection:(NSURLConnection *)connection
             willSendRequest:(NSURLRequest *)request
            redirectResponse:(NSURLResponse *)redirectResponse
{
    TRC_ENTRY
    
    [baseURL autorelease];
    baseURL = [[request URL] retain];
    return request;
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    TRC_ENTRY
    [responseData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    TRC_ENTRY
    [responseData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    TRC_ENTRY
    NSLog(@"Error with request %@", error);
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    TRC_ENTRY
    NSLog(@"Response size %i", responseData.length);
//    [self parseResponseData];
//    [self notifyDataAvailable];
}


- (id)init
{
    self = [super init];
    if (self) 
    {

        _quotes = [NSMutableArray arrayWithCapacity:QUOTES_SIZE];
        
        [self loadQuotesFromWiki:EN];
        
//        _quotes = [[NSArray arrayWithObjects:
//                   [Quote quoteWithText:@"Statistics show that 100% of all divorces start with marriage." fromAuthor:@"Anonymous"],
//                   [Quote quoteWithText:@"The happiest time of anyone's life is just after the first divorce." fromAuthor:@"John Kenneth Galbraith"],
//                   [Quote quoteWithText:@"Of course there is such a thing as love, or there wouldn't be so many divorces." fromAuthor:@"Ed Howe"],
//                   [Quote quoteWithText:@"Macedonia as a whole tended to remain in isolation from the rest of Greece..." fromAuthor:@"Alexander the Great"],
//                   [Quote quoteWithText:@"The Radiohead record, The Bends is my all-time favorite record on the planet" fromAuthor:@"Tommy Lee"],
//                   [Quote quoteWithText:@"I came, I saw, I conquered." fromAuthor:@"Julius Caesar"],
//                   [Quote quoteWithText:@"All Gaul is divided into three parts" fromAuthor:@"Julius Caesar"],
//                   [Quote quoteWithText:@"Men willingly believe what they wish." fromAuthor:@"Julius Caesar"],
//                   nil] retain];
        
        
        _currentQuote = 0;     
    }
    return self;
}

- (void) dealloc
{
    [_quotes release];
    [super dealloc];
}

- (Quote *) getRandom;
{
    Quote *quote = [self.quotes objectAtIndex:_currentQuote];
    _currentQuote++;
    if (_currentQuote >= [self.quotes count])
    {
        _currentQuote = 0;
    }
    
    return quote;
}

- (Quote *) getByIndex:(int) index
{
    if (responseData.length == 0)
    {
        return nil;
    }

    return [[[Quote alloc] initWithText:@"0" author:@"0" url:@"0" description:@"0"] autorelease];
    
    NSLog(@"Responce data length %i", responseData.length);
    
    return [[Quote alloc] initWithText:@"1" author:@"1" url:@"1" description:@"1"];
//    Quote *quote = [self.quotes objectAtIndex:index];
    
//    return quote;
}
@end
