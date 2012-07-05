//
//  Quote.m
//  WikiQuote
//
//  Created by Oleksandr Shtykhno on 28/05/2012.
//  Copyright (c) 2012 shtykhno.net. All rights reserved.
//

#import "Quote.h"

@implementation Quote

@synthesize text = _text;
@synthesize author = _author;
@synthesize identifier = _identifier;
@synthesize description = _description;

#pragma mark -
#pragma mark Initialization and memory management 

- (id)initWithText:(NSString*)text author:(NSString*)author identifier:(NSString*)identifier description:(NSString*)description
{
    self = [super init];
    if (self) 
    {
        self.text = text;
        self.author = author;
        self.identifier = identifier;
        self.description = description;
    }
    return self;
}

+ (Quote *) quoteWithText:(NSString *)text fromAuthor:(NSString *)author
{
    Quote *quote = [[Quote alloc] initWithText:text author:author identifier:nil description:nil];
    return [quote autorelease];
}

- (void) dealloc
{
    [_text release];
    [_author release];
    [_identifier release];
    [_description release];
    
    [super dealloc];
}


@end
