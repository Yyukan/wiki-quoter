//
//  WikiQuoter.h
//  WikiQuote
//
//  Created by Oleksandr Shtykhno on 28/05/2012.
//  Copyright (c) 2012 shtykhno.net. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Common.h"
#import "WikiQuoteParser.h"

#define LANG_RU @"ru"
#define LANG_EN @"en"

#define LANG_RU_INDEX @"ru_index"
#define LANG_EN_INDEX @"en_index"

#define WIKI_PAGES_COUNT 1
#define QUOTES_HISTORY_SIZE 10

@protocol WikiQuoterDelegate <NSObject>

- (void) quotesAreAvailable;

@end

@interface WikiQuoter : NSObject 
{
    NSMutableData *responseData;
	NSURL *baseURL;
}

@property (nonatomic, retain) NSMutableDictionary *langToQuotes;
@property (nonatomic, retain) NSString *language;
@property (nonatomic, retain) WikiQuoteParser *parser;

@property (nonatomic, assign) id<WikiQuoterDelegate> delegate;

+ (WikiQuoter *) sharedWikiQuoter;

- (Quote *) getByIndex:(int) index;
- (void) reload;

@end
