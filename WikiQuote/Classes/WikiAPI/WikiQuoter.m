//
//  WikiQuoter.m
//  WikiQuote
//
//  Created by Oleksandr Shtykhno on 28/05/2012.
//  Copyright (c) 2012 shtykhno.net. All rights reserved.
//

#import "WikiQuoter.h"

@implementation WikiQuoter

- (Quote *) getRandom;
{
    Quote *quote = [[Quote alloc] initWithText:@"Давно пора заменить идеал успеха идеалом служения." author:@"Альберт Эйнштейн" url:@"url" description:@"no description"];
    return [quote autorelease];
}

@end
