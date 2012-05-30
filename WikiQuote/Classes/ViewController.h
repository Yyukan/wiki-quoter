//
//  ViewController.h
//  WikiQuote
//
//  Created by Oleksandr Shtykhno on 24/05/2012.
//  Copyright (c) 2012 shtykhno.net. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyViewController.h"

@interface ViewController : UIViewController<UIScrollViewDelegate>
{
    UIScrollView *_scrollView;
    
    MyViewController *_previosView;
    MyViewController *_currentView;
    MyViewController *_nextView;
    
    int _previosIndex;
	int _currentIndex;
	int _nextIndex;
}

@property (nonatomic, retain) MyViewController *previosView;
@property (nonatomic, retain) MyViewController *currentView;
@property (nonatomic, retain) MyViewController *nextView;
@property (nonatomic, assign) int previosIndex;
@property (nonatomic, assign) int currentIndex;
@property (nonatomic, assign) int nextIndex;

@property (nonatomic, retain) IBOutlet UIScrollView *scrollView;

@end
