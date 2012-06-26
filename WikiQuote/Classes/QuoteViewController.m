//
//  MyViewController.m
//  WikiQuote
//
//  Created by Oleksandr Shtykhno on 25/05/2012.
//  Copyright (c) 2012 shtykhno.net. All rights reserved.
//

#import "QuoteViewController.h"
#import "Common.h"
#import "WikiQuoter.h"

@implementation QuoteViewController

@synthesize imageView, label, textView;

// Creates the color list the first time this method is invoked. Returns one color object from the list.
+ (UIColor *)pageControlColorWithIndex:(NSUInteger)index {
    return [UIColor greenColor];
}

// Load the view nib and initialize the pageNumber ivar.

- (void)dealloc {
    [imageView release];
    [super dealloc];
}

// Set the label and background color when the view has finished loading.
- (void)viewDidLoad {
    self.view.backgroundColor = [UIColor clearColor];
    
    self.label.font = [UIFont fontWithName:@"Philosopher" size:17];
    self.textView.font = [UIFont fontWithName:@"Philosopher" size:28];
    
    // how to center text in text view, notify itself about content size changing
    [textView addObserver:self forKeyPath:@"contentSize" options:(NSKeyValueObservingOptionNew) context:NULL];
}

- (void) updateByIndex:(int) index
{
    Quote *quote = [[WikiQuoter sharedWikiQuoter] getByIndex:index];
    self.label.text = [NSString stringWithFormat:@"%i %@", index, [quote author]];
    self.textView.text = [quote text];
}

/**
 * Method centers text in text view by correcting content offset 
 */
- (void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context 
{
    UITextView *txtView = object;
    CGFloat topCorrect = ([txtView bounds].size.height - [txtView contentSize].height * [txtView zoomScale])  / 2.0;
    topCorrect = (topCorrect < 0.0 ? 0.0 : topCorrect );
    txtView.contentOffset = (CGPoint){.x = 0, .y = -topCorrect};
}

@end


