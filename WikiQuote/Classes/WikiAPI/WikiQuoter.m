//
//  WikiQuoter.m
//  WikiQuote
//
//  Created by Oleksandr Shtykhno on 28/05/2012.
//  Copyright (c) 2012 shtykhno.net. All rights reserved.
//


#import "WikiQuoter.h"

@implementation WikiQuoter

SYNTHESIZE_SINGLETON_FOR_CLASS(WikiQuoter)

@synthesize quotes = _quotes;

- (id)init
{
    self = [super init];
    if (self) {
        _quotes = [[NSArray arrayWithObjects:
                   [Quote quoteWithText:@"Statistics show that 100% of all divorces start with marriage." fromAuthor:@"Anonymous"],
                   [Quote quoteWithText:@"The happiest time of anyone's life is just after the first divorce." fromAuthor:@"John Kenneth Galbraith"],
                   [Quote quoteWithText:@"Of course there is such a thing as love, or there wouldn't be so many divorces." fromAuthor:@"Ed Howe"],
                   [Quote quoteWithText:@"Macedonia as a whole tended to remain in isolation from the rest of Greece..." fromAuthor:@"Alexander the Great"],
                   [Quote quoteWithText:@"The Radiohead record, The Bends is my all-time favorite record on the planet" fromAuthor:@"Tommy Lee"],
                   [Quote quoteWithText:@"I came, I saw, I conquered." fromAuthor:@"Julius Caesar"],
                   [Quote quoteWithText:@"All Gaul is divided into three parts" fromAuthor:@"Julius Caesar"],
                   [Quote quoteWithText:@"Men willingly believe what they wish." fromAuthor:@"Julius Caesar"],
                   nil] retain];
        
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
    Quote *quote = [self.quotes objectAtIndex:index];
    
    return quote;
}
@end
