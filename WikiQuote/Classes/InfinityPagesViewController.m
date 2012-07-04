//
//  ViewController.m
//  WikiQuote
//
//  Created by Oleksandr Shtykhno on 24/05/2012.
//  Copyright (c) 2012 shtykhno.net. All rights reserved.
//

#import "InfinityPagesViewController.h"

#define PREVIOS_PAGE 0
#define CURRENT_PAGE 1
#define NEXT_PAGE 2

@implementation InfinityPagesViewController

@synthesize scrollView = _scrollView;

@synthesize previosView = _previosView;
@synthesize currentView = _currentView;
@synthesize nextView = _nextView;

@synthesize previosIndex = _previosIndex;
@synthesize currentIndex = _currentIndex;
@synthesize nextIndex = _nextIndex;

- (void) adjustFrame:(QuoteViewController *) controller page:(int)page
{
    CGRect frame = self.scrollView.frame;
    frame.origin.x = frame.size.width * page;
    frame.origin.y = 0;
    controller.view.frame = frame;
}

- (QuoteViewController *) createViewController:(int)page
{
    QuoteViewController *controller = [[QuoteViewController alloc] init];
    [self adjustFrame:controller page:page];
    return [controller autorelease];
}

#pragma mark -
#pragma mark Initialization and memory management 

- (void)didReceiveMemoryWarning 
{
    [super didReceiveMemoryWarning];
}

- (void)dealloc 
{
    [_previosView release];
    [_currentView release];
    [_nextView release];
    [_scrollView release];
    [super dealloc];
}

- (void)loadPageByIndex:(int)index onPage:(int)page 
{
	// load data for page
	switch (page) 
    {
		case PREVIOS_PAGE:
			[self.previosView updateByIndex:index];
			break;
		case CURRENT_PAGE:
            [self.currentView updateByIndex:index];
			break;
		case NEXT_PAGE:
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
	self.previosView = [self createViewController:PREVIOS_PAGE];
	self.currentView = [self createViewController:CURRENT_PAGE];
	self.nextView = [self createViewController:NEXT_PAGE];

    _scrollView.pagingEnabled = YES;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.delegate = self;

    [_scrollView addSubview:_previosView.view];
	[_scrollView addSubview:_currentView.view];
	[_scrollView addSubview:_nextView.view];
    
    [self loadPageByIndex:9 onPage:PREVIOS_PAGE];
	[self loadPageByIndex:0 onPage:CURRENT_PAGE];
	[self loadPageByIndex:1 onPage:NEXT_PAGE];
    
    [UIUtils setBackgroundImage:self.view image:@"background@2x"];

    // adjust content size for three pages
	[_scrollView setContentSize:CGSizeMake(_scrollView.frame.size.width * 3, _scrollView.frame.size.height)];	
    
    // reposition to central page
	[_scrollView scrollRectToVisible:CGRectMake(_scrollView.frame.size.width,0,_scrollView.frame.size.width,_scrollView.frame.size.height) animated:NO];
    
    // activity indicator
    // TODO:yukan introduce indicator 
//    UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
//    activityIndicator.frame = CGRectMake(10.0, 0.0, 40.0, 40.0);
//    activityIndicator.center = _currentView.imageView.center;
//    [_currentView.imageView addSubview: activityIndicator];
    
//    CGAffineTransform transform = CGAffineTransformMakeScale(2.0f, 2.0f);
//    activityIndicator.transform = transform;
//
//    [activityIndicator startAnimating];
//    
//    [activityIndicator release];
}

- (void)viewDidUnload 
{
    self.scrollView = nil;
    [super viewDidUnload];
}

- (void)scrollViewDidScroll:(UIScrollView *)sender 
{
//    TRC_ENTRY
//    int scrollDirection;
//    if (lastContentOffset > sender.contentOffset.x)
//        scrollDirection = RIGHT;
//    else if (lastContentOffset < scrollView.contentOffset.x) 
//        scrollDirection = LEFT;
//    
//    lastContentOffset = scrollView.contentOffset.x;
//    
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    TRC_ENTRY
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)sender 
{
	if(_scrollView.contentOffset.x > _scrollView.frame.size.width) 
    {
		[self loadPageByIndex:_currentIndex onPage:PREVIOS_PAGE];         
        
		_currentIndex++;
        
		[self loadPageByIndex:_currentIndex onPage:CURRENT_PAGE];         
        
		_nextIndex = _currentIndex + 1;         
		[self loadPageByIndex:_nextIndex onPage:NEXT_PAGE];
	}     
	if(_scrollView.contentOffset.x < _scrollView.frame.size.width) 
    {         
		[self loadPageByIndex:_currentIndex onPage:NEXT_PAGE];         
        
		_currentIndex = (_currentIndex == 0) ? 0 : _currentIndex - 1;         
		[self loadPageByIndex:_currentIndex onPage:CURRENT_PAGE]; 
        
		_previosIndex = (_currentIndex == 0) ? 0 : _currentIndex - 1;         

		[self loadPageByIndex:_previosIndex onPage:PREVIOS_PAGE];     
	}     
	
	// reset offset back to middle page     
	[_scrollView scrollRectToVisible:CGRectMake(_scrollView.frame.size.width,0,_scrollView.frame.size.width,_scrollView.frame.size.height) animated:NO];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    [self adjustFrame:self.previosView page:0];
    [self adjustFrame:self.currentView page:1];
    [self adjustFrame:self.nextView page:2];
    
    [self.currentView shouldAutorotateToInterfaceOrientation:interfaceOrientation];
    [self.previosView shouldAutorotateToInterfaceOrientation:interfaceOrientation];
    [self.nextView shouldAutorotateToInterfaceOrientation:interfaceOrientation];

    // adjust content size for three pages
	[_scrollView setContentSize:CGSizeMake(_scrollView.frame.size.width * 3, _scrollView.frame.size.height)];	
    
    // reposition to central page
	[_scrollView scrollRectToVisible:CGRectMake(_scrollView.frame.size.width,0,_scrollView.frame.size.width,_scrollView.frame.size.height) animated:NO];

    return YES;
}

@end
