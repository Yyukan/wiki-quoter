//
//  MyViewController.m
//  WikiQuote
//
//  Created by Oleksandr Shtykhno on 25/05/2012.
//  Copyright (c) 2012 shtykhno.net. All rights reserved.
//

#import "MyViewController.h"
#import "WikiQuoter.h"

static NSArray *__pageControlColorList = nil;

@implementation MyViewController

@synthesize imageView, label, textView;

// Creates the color list the first time this method is invoked. Returns one color object from the list.
+ (UIColor *)pageControlColorWithIndex:(NSUInteger)index {
    if (__pageControlColorList == nil) {
        __pageControlColorList = [[NSArray alloc] initWithObjects:[UIColor redColor], [UIColor greenColor], [UIColor magentaColor],
                                   nil];
    }
    
    // Mod the index by the list length to ensure access remains in bounds.
    return [__pageControlColorList objectAtIndex:index % [__pageControlColorList count]];
}

// Load the view nib and initialize the pageNumber ivar.
- (id)initWithPageNumber:(int)page {
    if (self = [super initWithNibName:@"MyViewController" bundle:nil]) {
        pageNumber = page;
    }
    return self;
}

- (void)dealloc {
    [imageView release];
    [super dealloc];
}

// Set the label and background color when the view has finished loading.
- (void)viewDidLoad {
    //pageNumberLabel.text = [NSString stringWithFormat:@"Page %d", pageNumber + 1];
    self.view.backgroundColor = [UIColor clearColor];
    
    WikiQuoter *quoter = [WikiQuoter new];
    Quote * quote = [[quoter getRandom] retain];
    
    [quoter release];
    
    
    self.label.font = [UIFont fontWithName:@"Philosopher" size:17];

    self.label.text = [quote author];

    self.textView.font = [UIFont fontWithName:@"Philosopher" size:32];
    self.textView.text = [quote text];

    
    [quote release];
    //[MyViewController pageControlColorWithIndex:pageNumber];
}

@end


