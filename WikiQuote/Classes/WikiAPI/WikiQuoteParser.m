//
//  WikiQuoteParser.m
//  WikiQuote
//
//  Created by Oleksandr Shtykhno on 13/06/2012.
//  Copyright (c) 2012 shtykhno.net. All rights reserved.
//

#import "Common.h"
#import "WikiQuoteParser.h"


@implementation WikiQuoteParser

@synthesize quotes = _quotes;


//=========================================================== 
// Initialization and memory management
//=========================================================== 
- (id)init
{
    self = [super init];
    if (self) 
    {
        _quotes = [[NSMutableArray array] retain];
    }
    return self;
}

- (void)dealloc 
{
    [_quotes release];
    [super dealloc];
}

- (NSArray *) parseWikiPagesAsXml:(NSData *)xml
{
    // clean all quotes 
    [_quotes removeAllObjects];
    
    // create parser 
    NSXMLParser *parser = [[NSXMLParser alloc] initWithData:xml];
    
    // parse asynchronously 
    [parser setDelegate:self];
    
    // set parser properties 
    [parser setShouldProcessNamespaces:NO];
    [parser setShouldReportNamespacePrefixes:NO];
    [parser setShouldResolveExternalEntities:NO];
    
    // parse XML asynchronuosly
    BOOL success = [parser parse];
    
    if (success)
    {
        NSLog(@"Parsed successfully xml of size [%i] bytes", [xml length]);
    }    
    else
    {
        NSLog(@"Error parsing xml of size [%i] bytes", [xml length]);
    }    

    return self.quotes;
}

//=========================================================== 
// Parsing XML asynchronously
//=========================================================== 
- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qualifiedName
    attributes:(NSDictionary *)attributeDict 
{
    if ([@"title" isEqual:elementName])
    {
        titleElement = YES;
    }
    else if ([@"text" isEqual:elementName])
    {
        textElement = YES;
    }  
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string 
{
    if (titleElement || textElement)
    {
        if(!currentElement)
        {
            currentElement = [[NSMutableString alloc] initWithString:string];
        }
        else
        {
            [currentElement appendString:string];
        }
    }    
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName 
{
    if ([@"title" isEqual:elementName])
    {
        // save general title of the page 
        title = [NSString stringWithString:currentElement];
        
        [currentElement release];
        currentElement = nil;
        titleElement = NO;
    }
    else if ([@"text" isEqual:elementName])
    {
        [self.quotes addObjectsFromArray:[self parseQuotes:currentElement]];
        
        [currentElement release];
        currentElement = nil;
        textElement = NO;
    }
}    

- (NSString *) cleanTitle:(NSString *)text
{
    // TODO:yukan perform title cleaning
    return text;
}

- (NSString *) cleanQuote:(NSString *)text
{
    return [StringUtils cleanQuote:text];
}

- (NSArray *) parseQuotes:(NSString *)text
{
    NSMutableArray *result = [NSMutableArray array];
    
    // find all qoutes by patter {{Q| some text }}
    NSArray *rawQuotes = [StringUtils findAllByFirstGroup:text regularExpression:@"\\{\\s*\\{\\s*[q|Q]\\s*\\|(.*?)\\}\\s*\\}"]; 
    
    for (NSString *item in rawQuotes) {
        
        Quote *quote = [[Quote alloc] initWithText:[self cleanQuote:item] author:[self cleanTitle:title] url:@"" description:@""];
        
        [result addObject:quote];
        [quote release];
    }
        
    return result;
}

@end
