//
//  WikiQuoter.m
//  WikiQuote
//
//  Created by Oleksandr Shtykhno on 28/05/2012.
//  Copyright (c) 2012 shtykhno.net. All rights reserved.
//

#define QUOTES_SIZE 100

#import "WikiQuoter.h"
#import "WikiQuoteParser.h"

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
    NSString *requestUrl = @"http://ru.wikiquote.org/w/api.php?&grnnamespace=0&format=xmlfm&action=query&generator=random&grnlimit=3&export&exportnowrap";
    
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
    [responseData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [responseData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"Error with request %@", error);
}


- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    TRC_ENTRY
    TRC_DBG(@"Response size %i", responseData.length);

    WikiQuoteParser *parser = [WikiQuoteParser new];
    
    NSArray *array = [parser parseWikiPagesAsXml:responseData];

    TRC_DBG(@"Received [%i] qoutes", [array count]);
    if ([array count] > 0)
    {
        [_quotes addObjectsFromArray:array];
    }    
}

- (id)init
{
    self = [super init];
    if (self) 
    {
        self.quotes = [NSMutableArray array];
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
        [self loadQuotesFromWiki:RU];

        return [[[Quote alloc] initWithText:@"no data" author:@"no data" url:@"" description:@""] autorelease];
    }
    
    // TODO:yukan update this code 
    int size = [self.quotes count];
    if (index > size)
    {
        [self loadQuotesFromWiki:RU];
        
        return [[[Quote alloc] initWithText:@"no data" author:@"no data" url:@"" description:@""] autorelease];
    } 
    else if (index == size)
    {
        [self loadQuotesFromWiki:RU];
        
        return [[[Quote alloc] initWithText:@"no data" author:@"no data" url:@"" description:@""] autorelease];
    }    
    else 
    {
        if (index > size - 5)
        {
            [self loadQuotesFromWiki:RU];
        }
        return [self.quotes objectAtIndex:index];
    }
    
}
@end
