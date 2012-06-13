//
//  WikiQuoteTests.m
//  WikiQuoteTests
//
//  Created by Oleksandr Shtykhno on 31/05/2012.
//  Copyright (c) 2012 shtykhno.net. All rights reserved.
//

#import "WikiQuoteTests.h"
#import "WikiQuoter.h"
#import "WikiQuoteParser.h"

@implementation WikiQuoteTests

- (void)setUp
{
    [super setUp];
    
    // Set-up code here.
}

- (void)tearDown
{
    // Tear-down code here.
    
    [super tearDown];
}

- (void)testExample
{
//    WikiQuoter *quoter = [WikiQuoter sharedWikiQuoter];
//    Quote *quote = [quoter getByIndex:0];
//    
//    while (!quote)
//    {
//        quote = [quoter getByIndex:0];
//        NSLog(@".");
//    }
//    NSLog(@"Author %@", [quote author]);
//    NSLog(@"Quote %@", [quote text]);
}

#define QUOTE_MAX_LENGTH 140

- (NSData *) loadWikiPagesAsXml:(NSString *)language count:(int)count
{
    NSString *url = [NSString stringWithFormat:@"http://%@.wikiquote.org/w/api.php?format=xmlfm&action=query&grnnamespace=0&generator=random&grnlimit=%i&export&exportnowrap", language, count];
    
    NSString* userAgent = @"Mozilla/5.0 (X11; U; Linux i686; en-US) AppleWebKit/534.7 (KHTML, like Gecko) Chrome/7.0.517.41 Safari/534.7";
    NSURL *nsUrl = [NSURL URLWithString:url];
    
    NSMutableURLRequest *request = [[[NSMutableURLRequest alloc] initWithURL:nsUrl]
                                    autorelease];
    [request setValue:userAgent forHTTPHeaderField:@"User-Agent"];
    
    NSLog(@"Sent request %@", url);
    
    // sending request 
    NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSLog(@"Received response [%i] bytes", [response length]);
    
    return response;
}

- (void) testParser
{

    NSData *xml = [self loadWikiPagesAsXml:@"en" count:1];
    
    WikiQuoteParser *parser = [WikiQuoteParser new];
    
    NSArray *quotes = [parser parseWikiPagesAsXml:xml];
    
    for (Quote *quote in quotes) 
    {
        NSLog(@"Author: %@, Text: %@", [quote author], [quote text]);
    }
    NSLog(@"Quotes number [%i]", [quotes count]);
    
    [parser release];
}


@end
