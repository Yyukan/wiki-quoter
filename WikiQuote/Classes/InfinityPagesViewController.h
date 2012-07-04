//
//  ViewController.h
//  WikiQuote
//
//  Created by Oleksandr Shtykhno on 24/05/2012.
//  Copyright (c) 2012 shtykhno.net. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QuoteViewController.h"

@interface InfinityPagesViewController : UIViewController<UIScrollViewDelegate>

@property (nonatomic, retain) QuoteViewController *previosView;
@property (nonatomic, retain) QuoteViewController *currentView;
@property (nonatomic, retain) QuoteViewController *nextView;
@property (nonatomic, assign) int previosIndex;
@property (nonatomic, assign) int currentIndex;
@property (nonatomic, assign) int nextIndex;

@property (nonatomic, retain) IBOutlet UIScrollView *scrollView;

@end
