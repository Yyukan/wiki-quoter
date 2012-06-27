//
//  StringUtils.h
//  GTI
//
//  Created by Oleksandr Shtykhno on 07/11/2011.
//  Copyright (c) 2011 shtykhno.net. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StringUtils : NSObject

+ (NSString *) replaceString:(NSString *)string regularExpression:(NSString *)regexp with:(NSString *)pattern;
+ (NSString *) replaceFirstGroupAll:(NSString *)string regularExpression:(NSString *)regularExpression;

+ (NSArray *) findAll:(NSString *)string regularExpression:(NSString *)regularExpression;
+ (NSArray *) findAllByFirstGroup:(NSString *)string regularExpression:(NSString *)regularExpression;

+ (NSString *) cleanQuote:(NSString *)text;
+ (BOOL) isEmptyString:(NSString *) string;

@end


