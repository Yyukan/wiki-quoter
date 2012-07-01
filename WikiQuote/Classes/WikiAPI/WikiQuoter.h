//
//  WikiQuoter.h
//  WikiQuote
//
//  Created by Oleksandr Shtykhno on 28/05/2012.
//  Copyright (c) 2012 shtykhno.net. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Common.h"
#import "Quoter.h"

#define LANG_RU @"ru"
#define LANG_EN @"en"

#define WIKI_PAGES_COUNT 1

@interface WikiQuoter : NSObject 
{
    NSMutableArray *_quotes;  
    int _currentQuote;
    
    
    NSMutableData *responseData;
	NSURL *baseURL;
}

@property (nonatomic, retain) NSMutableArray *quotes;
@property (nonatomic, retain) NSString *language;

+ (WikiQuoter *) sharedWikiQuoter;

- (Quote *) getByIndex:(int) index;

@end
