//
//  UIUtils.h
//  WikiQuote
//
//  Created by Oleksandr Shtykhno on 01/07/2012.
//  Copyright (c) 2012 shtykhno.net. All rights reserved.
//

#import <Foundation/Foundation.h>

#define isPhone568 ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone && [UIScreen mainScreen].bounds.size.height == 568)

@interface UIUtils : NSObject

+ (void)setBackgroundImage:(UIView *)view image:(NSString *)image;
+ (UIColor *) colorFromHexString:(NSString *)hexString;


@end
