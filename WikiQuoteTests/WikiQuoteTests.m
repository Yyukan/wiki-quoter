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
    NSData *xml = [self loadWikiPagesAsXml:@"ru" count:1];
    
    WikiQuoteParser *parser = [WikiQuoteParser new];
    
    NSArray *quotes = [parser parseWikiPagesAsXml:xml];
    
    for (Quote *quote in quotes) 
    {
        NSLog(@"Author: %@, Text: %@", [quote author], [quote text]);
    }
    NSLog(@"Quotes number [%i]", [quotes count]);
    
    [parser release];
}

- (void) ItestParseWiki
{
    NSString *source = @"ношу [[шляпа|шляпы]], чтобы ни [[было|такое]] случилось";

    NSString *result = [StringUtils replaceFirstGroupAll:source  regularExpression:@"\\[\\[[а-яА-Я0-9]+\\|([а-яА-Я0-9]+)\\]\\]"];
    
    NSLog(@"Result %@", result); 
    STAssertTrue([@"ношу шляпы, чтобы ни такое случилось" isEqual:result], @"Text is not equal");
}

- (void) assertClean:(NSString *)source expected:(NSString *)expected
{
    NSString *result = [StringUtils cleanQuote:source];
    
    STAssertTrue([result isEqual:expected], @"Expected [%@] but actual [%@]", expected, result);
}

- (void) testClean00
{
    [self assertClean:@"[[Женщина]] никогда в [[шахматы]] на, [[w:потому что|так как]] она. " expected:@"Женщина никогда в шахматы на, так как она."];
}

- (void) testClean01
{
    [self assertClean:@"Цитата=Если уж издавать трактат — надо в предисловии сказать все, что я думаю о праве ученого искать истину! И о праве невежд судить ученого!…|Автор=|Комментарий=|Оригинал=" expected:@"Если уж издавать трактат — надо в предисловии сказать все, что я думаю о праве ученого искать истину! И о праве невежд судить ученого!…"];
}

- (void) testClean02
{
    [self assertClean:@"* А знаете ли, что у алжирского дея под самым носом шишка?[[Категория:Повести по алфавиту]][[Категория:Произведения Николая Гоголя]]" expected:@"А знаете ли, что у алжирского дея под самым носом шишка?"];
}

@end
