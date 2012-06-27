//
//  MyViewController.h
//  WikiQuote
//
//  Created by Oleksandr Shtykhno on 25/05/2012.
//  Copyright (c) 2012 shtykhno.net. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WikiQuoter.h"

@interface QuoteViewController : UIViewController
{
    UIImageView *imageView;
}

@property (nonatomic, retain) IBOutlet UILabel *label;
@property (nonatomic, retain) IBOutlet UITextView *textView;
@property (nonatomic, retain) IBOutlet UIImageView *imageView;

- (void) updateByIndex:(int) index;

@end