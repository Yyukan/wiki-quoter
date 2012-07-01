//
//  UIUtils.m
//  WikiQuote
//
//  Created by Oleksandr Shtykhno on 01/07/2012.
//  Copyright (c) 2012 shtykhno.net. All rights reserved.
//

#import "UIUtils.h"

@implementation UIUtils

+ (void)setBackgroundImage:(UIView *)view image:(NSString *)image
{
	UIColor *background = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:image]];
    view.backgroundColor = background;
    [background release];
}

@end
