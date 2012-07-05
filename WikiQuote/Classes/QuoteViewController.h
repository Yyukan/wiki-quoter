//
//  MyViewController.h
//  WikiQuote
//
//  Created by Oleksandr Shtykhno on 25/05/2012.
//  Copyright (c) 2012 shtykhno.net. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "WikiQuoter.h"

@protocol QuoteViewControllerDelegate <NSObject>

- (void) languageHasChanged:(NSString *)language;
- (void) sendToTweetter:(Quote *) quote;
- (void) sendToEMail:(Quote *) quote;
- (void) sendToFacebook:(Quote *) quote;
- (void) sendToGooglePlus:(Quote *) quote;

@end

@interface QuoteViewController : UIViewController <UIScrollViewDelegate>
{
}

@property (nonatomic, retain) Quote *quote;
@property (nonatomic, assign) WikiQuoter *wikiQuoter;

@property (nonatomic, retain) IBOutlet UIButton *label;
@property (nonatomic, retain) IBOutlet UITextView *textView;
@property (nonatomic, retain) IBOutlet UIImageView *imageView;

@property (nonatomic, retain) UIView *dropDownView;
@property (nonatomic, retain) UIActivityIndicatorView *indicator;

@property (nonatomic, assign) id<QuoteViewControllerDelegate, WikiQuoterDelegate> delegate;

- (void) updateByIndex:(int) index;

@end
