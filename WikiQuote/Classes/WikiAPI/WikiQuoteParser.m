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

//
//   <page>
//      <title>Title text</title>
//      <ns>0</ns>
//      <id>4502</id>
//      <revision><id>133655</id>
//      <text>Some text</text>
//      ...
//   </page>

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
    else if ([@"revision" isEqual:elementName])
    {
        revisionElement = YES;
    }  
    else if ([@"id" isEqual:elementName] && !revisionElement)
    {
        idElement = YES;
    }
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string 
{
    if (titleElement || textElement || idElement)
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
    else if ([@"id" isEqual:elementName] && !revisionElement)
    {
        identifier = [NSString stringWithString:currentElement];
        
        [currentElement release];
        currentElement = nil;
        idElement = NO;
    }
    else if ([@"revision" isEqual:elementName])
    {
        revisionElement = NO;
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

- (NSArray *) findAllQuotesFromText:(NSString *)text regularExpression:(NSString *)regularExpression
{
    NSMutableArray *result = [NSMutableArray array];

    NSArray *rawQuotes = [StringUtils findAllByFirstGroup:text regularExpression:regularExpression]; 
    
    for (NSString *item in rawQuotes) 
    {
        NSString *cleanedQuote = [self cleanQuote:item];
        NSString *cleanedTitle = [self cleanTitle:title];
        
        if ([StringUtils isEmptyString:cleanedQuote] || [StringUtils isEmptyString:cleanedTitle])
        {
            continue;
        }
        
        Quote *quote = [[Quote alloc] initWithText:cleanedQuote author:cleanedTitle identifier:identifier description:@""];
        
        [result addObject:quote];

        [quote release];
    }
    return result;
}

- (NSArray *) parseQuotes:(NSString *)text
{
    NSMutableArray *result = [NSMutableArray array];
    
    // add all quotes like {{Q|Quote text}}
    [result addObjectsFromArray:[self findAllQuotesFromText:text regularExpression:@"\\{\\s*\\{\\s*[q|Q]\\s*\\|(.*?)\\}\\s*\\}"]];
    // add all quotes like * Quote text
    [result addObjectsFromArray:[self findAllQuotesFromText:text regularExpression:@"(\\s*\\*{1,2}[^\\*]*)"]];
        
    return result;
}

@end
