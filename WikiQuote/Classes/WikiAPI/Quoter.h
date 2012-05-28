//
//  NSObject+Quoter.h
//  WikiQuote
//
//  Created by Oleksandr Shtykhno on 28/05/2012.
//  Copyright (c) 2012 shtykhno.net. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Quote.h"

@protocol Quoter <NSObject>

- (Quote *) getRandom;

@end 
