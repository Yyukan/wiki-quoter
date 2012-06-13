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

@interface WikiQuoter : NSObject <Quoter>
{
    NSArray *_quotes;  
    int _currentQuote;
    
    
    
//    NSMutableArray *cache;
    
    NSMutableData *responseData;
	NSURL *baseURL;
}
//@property (nonatomic, retain) NSMutableArray *cache;
@property (nonatomic, retain) NSArray *quotes;

+ (WikiQuoter *) sharedWikiQuoter;

- (Quote *) getByIndex:(int) index;

@end
