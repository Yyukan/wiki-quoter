//
//  ViewController.m
//  WikiQuote
//
//  Created by Oleksandr Shtykhno on 24/05/2012.
//  Copyright (c) 2012 shtykhno.net. All rights reserved.
//

#import "ViewController.h"

@implementation ViewController

@synthesize scrollView = _scrollView;

@synthesize previosView = _previosView;
@synthesize currentView = _currentView;
@synthesize nextView = _nextView;

@synthesize previosIndex = _previosIndex;
@synthesize currentIndex = _currentIndex;
@synthesize nextIndex = _nextIndex;

- (void)setBackgroundImage:(UIView *)view image:(NSString *)image;
{
	UIColor *background = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:image]];
    view.backgroundColor = background;
    [background release];
}

- (MyViewController *) createViewController:(int)page
{
    MyViewController *controller = [[MyViewController alloc] initWithPageNumber:0];
    CGRect frame = _scrollView.frame;
    frame.origin.x = frame.size.width * page;
    frame.origin.y = 0;
    controller.view.frame = frame;
    return [controller autorelease];
}

- (void)loadPageWithId:(int)index onPage:(int)page {
	// load data for page
	switch (page) {
		case 0:
			[self.previosView updateByIndex:index];
			break;
		case 1:
            [self.currentView updateByIndex:index];
			break;
		case 2:
            [self.nextView updateByIndex:index];
			break;
	}	
}

/*
 // Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
 */
- (void)viewDidLoad 
{
    [super viewDidLoad];
    
    // create placeholders for each of our documents
	self.previosView = [self createViewController:0];
	self.currentView = [self createViewController:1];
	self.nextView = [self createViewController:2];

    _scrollView.pagingEnabled = YES;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.delegate = self;

    [_scrollView addSubview:_previosView.view];
	[_scrollView addSubview:_currentView.view];
	[_scrollView addSubview:_nextView.view];
    
    [self loadPageWithId:9 onPage:0];
	[self loadPageWithId:0 onPage:1];
	[self loadPageWithId:1 onPage:2];
    
    [self setBackgroundImage:self.view image:@"background@2x.png"];

    // adjust content size for three pages
	[_scrollView setContentSize:CGSizeMake(_scrollView.frame.size.width * 3, _scrollView.frame.size.height)];	
    
    // reposition to central page
	[_scrollView scrollRectToVisible:CGRectMake(_scrollView.frame.size.width,0,_scrollView.frame.size.width,_scrollView.frame.size.height) animated:NO];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)sender {     
	// All data for the documents are stored in an array (documentTitles).     
	// We keep track of the index that we are scrolling to so that we     
	// know what data to load for each page.     
	if(_scrollView.contentOffset.x > _scrollView.frame.size.width) 
    {
        TRC_DBG(@"We are moving forward ");
		// We are moving forward. Load the current doc data on the first page.         
		[self loadPageWithId:_currentIndex onPage:0];         
        
		// Add one to the currentIndex or reset to 0 if we have reached the end.         
		_currentIndex = (_currentIndex >= 100) ? 0 : _currentIndex + 1;         
        
		[self loadPageWithId:_currentIndex onPage:1];         
        
		// Load content on the last page. This is either from the next item in the array         
		// or the first if we have reached the end.         
        
		_nextIndex = (_currentIndex >= 100) ? 0 : _currentIndex + 1;         
		[self loadPageWithId:_nextIndex onPage:2];
        
	}     
	if(_scrollView.contentOffset.x < _scrollView.frame.size.width) {         
        TRC_DBG(@"We are moving backward ");

		// We are moving backward. Load the current doc data on the last page.         
		[self loadPageWithId:_currentIndex onPage:2];         
        
		// Subtract one from the currentIndex or go to the end if we have reached the beginning.         
		_currentIndex = (_currentIndex == 0) ? 100 : _currentIndex - 1;         
		[self loadPageWithId:_currentIndex onPage:1]; 
        
		// Load content on the first page. This is either from the prev item in the array         
		// or the last if we have reached the beginning.
        
		_previosIndex = (_currentIndex == 0) ? 100 : _currentIndex - 1;         

		[self loadPageWithId:_previosIndex onPage:0];     
	}     
	
	// Reset offset back to middle page     
	[_scrollView scrollRectToVisible:CGRectMake(_scrollView.frame.size.width,0,_scrollView.frame.size.width,_scrollView.frame.size.height) animated:NO];
}



//- (void)scrollViewDidScroll:(UIScrollView *)sender {
    // We don't want a "feedback loop" between the UIPageControl and the scroll delegate in
    // which a scroll event generated from the user hitting the page control triggers updates from
    // the delegate method. We use a boolean to disable the delegate logic when the page control is used.
    //if (pageControlUsed) {
        // do nothing - the scroll was initiated from the page control, not the user dragging
    //    return;
    //}
    
    // Switch the indicator when more than 50% of the previous/next page is visible
//    CGFloat pageWidth = scrollView.frame.size.width;
//    int page = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
//    //pageControl.currentPage = page;
//
//    TRC_DBG(@"Current page %i", page);
//    
//    // load the visible page and the page on either side of it (to avoid flashes when the user starts scrolling)
//    [self loadScrollViewWithPage:page - 1];
//    [self loadScrollViewWithPage:page];
//    [self loadScrollViewWithPage:page + 1];
    
    // A possible optimization would be to unload the views+controllers which are no longer visible
//}

// At the begin of scroll dragging, reset the boolean used when scrolls originate from the UIPageControl
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    TRC_ENTRY
    //pageControlUsed = NO;
}

// At the end of scroll animation, reset the boolean used when scrolls originate from the UIPageControl
//- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
//    TRC_ENTRY
//    //pageControlUsed = NO;
//}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc 
{
    [_previosView release];
    [_currentView release];
    [_nextView release];
    [_scrollView release];
    [super dealloc];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}

@end
