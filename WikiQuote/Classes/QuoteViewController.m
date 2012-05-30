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
    self.textView.font = [UIFont fontWithName:@"Philosopher" size:32];
}

- (void) updateByIndex:(int) index
{
    int i = abs(index % 8);
    
    Quote * quote = [[WikiQuoter sharedWikiQuoter] getByIndex:i];
    self.label.text = [NSString stringWithFormat:@"%i %@", index, [quote author]];
    self.textView.text = [quote text];
}

@end


