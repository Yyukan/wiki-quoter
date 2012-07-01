//
//  MyViewController.h
//  WikiQuote
//
//  Created by Oleksandr Shtykhno on 25/05/2012.
//  Copyright (c) 2012 shtykhno.net. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WikiQuoter.h"

@interface QuoteViewController : UIViewController <UIScrollViewDelegate>
{
}

@property (nonatomic, assign) WikiQuoter *wikiQuoter;

@property (nonatomic, retain) IBOutlet UILabel *label;
@property (nonatomic, retain) IBOutlet UITextView *textView;
@property (nonatomic, retain) IBOutlet UIImageView *imageView;

@property (nonatomic, retain) UIView *dropDownView;

- (void) updateByIndex:(int) index;

@end
