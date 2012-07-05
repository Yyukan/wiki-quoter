//
//  Quote.h
//  WikiQuote
//
//  Created by Oleksandr Shtykhno on 28/05/2012.
//  Copyright (c) 2012 shtykhno.net. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Quote : NSObject
{
    NSString *_text;
    NSString *_author;
    NSString *_identifier;
    NSString *_description;
}

@property (nonatomic, retain) NSString *text;
@property (nonatomic, retain) NSString *author;
@property (nonatomic, retain) NSString *identifier;
@property (nonatomic, retain) NSString *description;

- (id)initWithText:(NSString*)text author:(NSString*)author identifier:(NSString*)identifier description:(NSString*)description;

+ (Quote *) quoteWithText:(NSString *)text fromAuthor:(NSString *)author;

@end
