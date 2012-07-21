//
//  WikiQuoter.m
//  WikiQuote
//
//  Created by Oleksandr Shtykhno on 28/05/2012.
//  Copyright (c) 2012 shtykhno.net. All rights reserved.
//

#import "WikiQuoter.h"
#import "WikiQuoteParser.h"

@interface WikiQuoter()

- (void) loadQuotesFromWiki;

@end

@implementation WikiQuoter

SYNTHESIZE_SINGLETON_FOR_CLASS(WikiQuoter)

@synthesize language = _language;

@synthesize langToQuotes = _langToQuotes;
@synthesize parser = _parser;
@synthesize delegate = _delegate;

#pragma mark -
#pragma Initialization and memory management

- (id)init
{
    self = [super init];
    if (self) 
    {
        self.parser = [[WikiQuoteParser new] autorelease];
        
        self.langToQuotes = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                             [NSMutableArray arrayWithCapacity:QUOTES_HISTORY_SIZE], LANG_RU, 
                             [NSMutableArray arrayWithCapacity:QUOTES_HISTORY_SIZE], LANG_EN, 
                             [NSNumber numberWithInt:0], LANG_RU_INDEX,
                             [NSNumber numberWithInt:0], LANG_EN_INDEX,
                             nil];
        self.language = LANG_RU;
    }
    return self;
}

- (void) dealloc
{
    [_langToQuotes release];
    [_parser release];
    [super dealloc];
}

- (void) setLanguage:(NSString *)language
{
    // change current language
    [_language release];
    _language = [language retain];
}

- (void) loadQuotesFromWiki
{
    responseData = [[NSMutableData data] retain];
    
    NSString *requestUrl = [NSString stringWithFormat:@"http://%@.wikiquote.org/w/api.php?&grnnamespace=0&format=xmlfm&action=query&generator=random&grnlimit=%i&export&exportnowrap", self.language, WIKI_PAGES_COUNT];
    
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
    // when request is completed response data contains response with wiki XML
    TRC_DBG(@"Response size %i", responseData.length);

    // parse XML to quotes 
    NSArray *parsed = [self.parser parseWikiPagesAsXml:responseData];

    TRC_DBG(@"Received [%i] qoutes for language [%@]", [parsed count], self.language);
    if ([parsed count] > 0)
    {
        NSMutableArray *quotes = [self.langToQuotes objectForKey:self.language];
        [quotes addObjectsFromArray:parsed];
        // notify that quotes are available
        [self.delegate quotesAreAvailable];
    }   
}

- (void)reload
{
    // reset all quotes for current language    
    NSMutableArray *quotes = [self.langToQuotes objectForKey:self.language];
    [quotes removeAllObjects];
    // reset correction index 
    NSString *key = [NSString stringWithFormat:@"%@_index", self.language];
    [self.langToQuotes setValue:[NSNumber numberWithInt:0] forKey:key];
    
    [self loadQuotesFromWiki]; 
}

- (Quote *) getByIndex:(int) index
{
    NSMutableArray *quotes = [self.langToQuotes objectForKey:self.language];
    NSString *key = [NSString stringWithFormat:@"%@_index", self.language];
    NSNumber *number = [self.langToQuotes objectForKey:key];
    
    int correctionIndex = [number intValue];

    int size = [quotes count];

    if (size == 0)
    {
        // load data from wiki page 
        [self loadQuotesFromWiki];
        // return empty quote 
        return [[[Quote alloc] initWithText:@"" author:@"" identifier:@"" description:@""] autorelease];
    }
        
    int realIndex = index;
    
    if ((index - correctionIndex) > (QUOTES_HISTORY_SIZE / 2))
    {
        [quotes removeObjectAtIndex:0];
        correctionIndex++;
    }
    realIndex -= correctionIndex;
    
    if (realIndex < 0)
    {
        realIndex = 0;
        correctionIndex--;
    }
    
    if (realIndex > size - (QUOTES_HISTORY_SIZE / 2))
    {
        [self loadQuotesFromWiki];
    }
    
    TRC_DBG(@"Requested index %i real index %i correction %i", index, realIndex, correctionIndex);
    
    [self.langToQuotes setValue:[NSNumber numberWithInt:correctionIndex] forKey:key];
    return [quotes objectAtIndex:realIndex];
}
@end
