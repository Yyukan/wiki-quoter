//
//  WikiQuoteParser.h
//  WikiQuote
//
//  Created by Oleksandr Shtykhno on 13/06/2012.
//  Copyright (c) 2012 shtykhno.net. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Quote.h"

@interface WikiQuoteParser : NSObject <NSXMLParserDelegate>
{
    @private
    
    BOOL titleElement;
    BOOL textElement;
    
    NSMutableString *currentElement;
    NSString *title;
}
@property (nonatomic, retain) NSMutableArray *quotes;

- (NSArray *) parseWikiPagesAsXml:(NSData *)xml;
- (NSArray *) parseQuotes:(NSString *)text;

@end
