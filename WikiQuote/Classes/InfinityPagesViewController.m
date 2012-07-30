//
//  ViewController.m
//  WikiQuote
//
//  Created by Oleksandr Shtykhno on 24/05/2012.
//  Copyright (c) 2012 shtykhno.net. All rights reserved.
//

#import "InfinityPagesViewController.h"

#define PAGE_PREVIOS 0
#define PAGE_CURRENT 1
#define PAGE_NEXT 2

#define FACEBOOK_APP_ID @"247204855382301"

@implementation InfinityPagesViewController

@synthesize scrollView = _scrollView;

@synthesize previosView = _previosView;
@synthesize currentView = _currentView;

@synthesize nextView = _nextView;

@synthesize previosIndex = _previosIndex;
@synthesize currentIndex = _currentIndex;
@synthesize nextIndex = _nextIndex;

@synthesize facebook = _facebook;

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
    [controller setDelegate:self];
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
    [_facebook release];
    [_previosView release];
    [_currentView release];
    [_nextView release];
    [_scrollView release];
    [super dealloc];
}

- (Facebook *)facebook
{
    if (!_facebook)
    {
        self.facebook = [[[Facebook alloc] initWithAppId:FACEBOOK_APP_ID andDelegate:self] autorelease];
    }
    return _facebook;
}

- (void)loadPageByIndex:(int)index onPage:(int)page 
{
	// load data for page
	switch (page) 
    {
		case PAGE_PREVIOS:
			[self.previosView updateByIndex:index];
			break;
		case PAGE_CURRENT:
            [self.currentView updateByIndex:index];
			break;
		case PAGE_NEXT:
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
	self.previosView = [self createViewController:PAGE_PREVIOS];
	self.currentView = [self createViewController:PAGE_CURRENT];
	self.nextView = [self createViewController:PAGE_NEXT];

    self.scrollView.pagingEnabled = YES;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.delegate = self;
    self.scrollView.scrollEnabled = NO;

    [self.scrollView addSubview:_previosView.view];
	[self.scrollView addSubview:_currentView.view];
	[self.scrollView addSubview:_nextView.view];

    [UIUtils setBackgroundImage:self.view image:@"background@2x"];

    // adjust content size for three pages
	[_scrollView setContentSize:CGSizeMake(_scrollView.frame.size.width * 3 , _scrollView.frame.size.height)];	
    
    // reposition to central page
	[_scrollView scrollRectToVisible:CGRectMake(_scrollView.frame.size.width,0,_scrollView.frame.size.width,_scrollView.frame.size.height) animated:NO];
    
    // initialize all indexes for previos, current and next pages
    self.previosIndex = -1;
    self.currentIndex = 0;
    self.nextIndex = 1;
    
    _previosIndexRu = -1;
    _currentIndexRu = 0;
    _nextIndexRu = 1;

    _previosIndexEn = -1;
    _currentIndexEn = 0;
    _nextIndexEn = 1;

    // load current page
	[self loadPageByIndex:self.currentIndex onPage:PAGE_CURRENT];
    // load next page
	[self loadPageByIndex:self.nextIndex onPage:PAGE_NEXT];
    
    // load sound file to notify about facebook posting
    NSString *path = [[NSBundle mainBundle] pathForResource:@"mail-sent" ofType:@"caf"];
    AudioServicesCreateSystemSoundID((CFURLRef) [NSURL fileURLWithPath:path], &mailSentSound);
}

- (void)viewDidUnload 
{
    TRC_ENTRY
    self.scrollView = nil;
    [super viewDidUnload];
}

// to intercept shaking motion
- (BOOL)canBecomeFirstResponder
{
    return YES;
}

// method is called when device is shaking
- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    // check if device has been shaked 
    if (motion == UIEventSubtypeMotionShake) 
    {
        self.scrollView.scrollEnabled = NO;
        // reset all indexes to default values    
        self.previosIndex = -1;
        self.currentIndex = 0;
        self.nextIndex = 1;
        
        // reload current view (reset all quotes cache)
        [self.currentView reload]; 
        
        // load current page and next page
        [self loadPageByIndex:self.currentIndex onPage:PAGE_CURRENT];
        [self loadPageByIndex:self.nextIndex onPage:PAGE_NEXT];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (self.currentIndex == 0)
    {
        // contect offset is changing to the left
        if (scrollView.contentOffset.x < _scrollView.frame.size.width)
        {
            // disable scrolling to the left
            scrollView.bounces = NO;
            [scrollView setContentOffset:CGPointMake(_scrollView.frame.size.width, 0) animated:NO];
        }
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
	if (_scrollView.contentOffset.x > _scrollView.frame.size.width)
    {
        _previosIndex = (_previosIndex == QUOTES_HISTORY_SIZE - 1) ? QUOTES_HISTORY_SIZE - 1 : _previosIndex + 1;
		_currentIndex = (_currentIndex == QUOTES_HISTORY_SIZE) ? QUOTES_HISTORY_SIZE : _currentIndex + 1;
		_nextIndex = (_nextIndex == QUOTES_HISTORY_SIZE + 1) ? QUOTES_HISTORY_SIZE + 1: _nextIndex + 1;

        [self loadPageByIndex:_previosIndex onPage:PAGE_PREVIOS];
        [self loadPageByIndex:_currentIndex onPage:PAGE_CURRENT];
        [self loadPageByIndex:_nextIndex onPage:PAGE_NEXT];
	}
	if (_scrollView.contentOffset.x < _scrollView.frame.size.width)
    {
		_previosIndex = (_previosIndex == -1) ? -1 : _previosIndex - 1;
		_currentIndex = (_currentIndex == 0) ? 0 : _currentIndex - 1;
		_nextIndex = (_nextIndex == 1) ? 1 : _nextIndex - 1;
        
        [self loadPageByIndex:_previosIndex onPage:PAGE_PREVIOS];
        [self loadPageByIndex:_currentIndex onPage:PAGE_CURRENT];
        [self loadPageByIndex:_nextIndex onPage:PAGE_NEXT];
	}
	// reset offset back to middle page
	[_scrollView scrollRectToVisible:CGRectMake(_scrollView.frame.size.width,0,_scrollView.frame.size.width,_scrollView.frame.size.height) animated:NO];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    [self adjustFrame:self.previosView page:PAGE_PREVIOS];
    [self adjustFrame:self.currentView page:PAGE_CURRENT];
    [self adjustFrame:self.nextView page:PAGE_NEXT];
    
    [self.currentView shouldAutorotateToInterfaceOrientation:interfaceOrientation];
    [self.previosView shouldAutorotateToInterfaceOrientation:interfaceOrientation];
    [self.nextView shouldAutorotateToInterfaceOrientation:interfaceOrientation];

    // adjust content size for three pages
	[_scrollView setContentSize:CGSizeMake(_scrollView.frame.size.width * 3, _scrollView.frame.size.height)];	
    
    // reposition to central page
	[_scrollView scrollRectToVisible:CGRectMake(_scrollView.frame.size.width,0,_scrollView.frame.size.width,_scrollView.frame.size.height) animated:NO];

    return YES;
}

- (void)languageHasChanged:(NSString *)language
{
    TRC_DBG(@"Language has changed %@", language);

    if ([language isEqual:LANG_RU])
    {
        _previosIndexEn = self.previosIndex;
        _currentIndexEn = self.currentIndex;
        _nextIndexEn = self.nextIndex;
        
        _previosIndex = _previosIndexRu;
        _currentIndex = _currentIndexRu;
        _nextIndex = _nextIndexRu;
    }
    else if ([language isEqual:LANG_EN])
    {
        _previosIndexRu = self.previosIndex;
        _currentIndexRu = self.currentIndex;
        _nextIndexRu = self.nextIndex;
        
        _previosIndex = _previosIndexEn;
        _currentIndex = _currentIndexEn;
        _nextIndex = _nextIndexEn;
    }    
    
    [self loadPageByIndex:_previosIndex onPage:PAGE_PREVIOS];
	[self loadPageByIndex:_currentIndex onPage:PAGE_CURRENT];
	[self loadPageByIndex:_nextIndex onPage:PAGE_NEXT];
}

- (void) quotesAreAvailable
{
    TRC_ENTRY
    if (self.previosIndex >= 0)
    {
        [self loadPageByIndex:self.previosIndex onPage:PAGE_PREVIOS];
    }    
	[self loadPageByIndex:self.currentIndex onPage:PAGE_CURRENT];
	[self loadPageByIndex:self.nextIndex onPage:PAGE_NEXT];

    if (!self.scrollView.scrollEnabled) 
    {
        self.scrollView.scrollEnabled = YES;
    }
}

- (void) sendToTweetter:(Quote *) quote
{
    int quoteMaximumLength = (140 - 3 - [quote.author length]);
    
    NSString *text = quote.text;
    if ([text length] > quoteMaximumLength)
    {
        text = [quote.text substringToIndex:quoteMaximumLength];
    }
    
    TWTweetComposeViewController *tweeter = [[TWTweetComposeViewController alloc] init];
    [tweeter setInitialText:[NSString stringWithFormat:@"%@ (%@)", text, quote.author]];
    [self presentModalViewController:tweeter animated:YES];
    [tweeter release];
}

- (void) sendToEMail:(Quote *) quote
{
    MFMailComposeViewController *controller = [[MFMailComposeViewController alloc] init];
    [controller.navigationBar setTintColor:[UIUtils colorFromHexString:@"#55707d"]];
    [controller setMailComposeDelegate:self];
    [controller setSubject:@"WikiQuoter"];
    [controller setMessageBody:[NSString stringWithFormat:@"%@<br/>(%@)", quote.text, quote.author] isHTML:YES];
    [self presentModalViewController:controller animated:YES];
    [controller release];
}

- (void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    [self dismissModalViewControllerAnimated:YES];
}

- (void)doSendToFacebook:(NSMutableDictionary *)parameters
{
    NSString *encodedToken = [self.facebook.accessToken stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *graphPath = [NSString stringWithFormat:@"me/feed?access_token=%@", encodedToken];
    [self.facebook requestWithGraphPath:graphPath
                              andParams:parameters 
                          andHttpMethod:@"POST" 
                            andDelegate:self];
    TRC_DBG(@"Sent post message to the wall");
}


- (void) sendToFacebook:(Quote *) quote
{
    if (![self.facebook isSessionValid]) 
    {
        // if user is not logged in
        [self.facebook authorize:[NSArray arrayWithObjects:@"read_stream", @"publish_stream", nil]];
        
        
    } 
    else 
    {
        NSString *text = [NSString stringWithFormat:@"%@ (%@)", quote.text, quote.author];
        
        
        // Create the parameters dictionary that will keep the data that will be posted.
        NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                       @"WikiQuoter app for iPhone!", @"caption",
                                       text, @"message",
                                       nil];
        
        [self doSendToFacebook:parameters];
    }
}

/**
 * Facebook delegate
 */
- (void)fbDidLogin 
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[self.facebook accessToken] forKey:@"FBAccessTokenKey"];
    [defaults setObject:[self.facebook expirationDate] forKey:@"FBExpirationDateKey"];
    [defaults synchronize];
}

- (void)fbDidNotLogin:(BOOL)cancelled
{

}

- (void)fbDidExtendToken:(NSString*)accessToken
               expiresAt:(NSDate*)expiresAt;
{

}

- (void) fbDidLogout 
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults objectForKey:@"FBAccessTokenKey"]) 
    {
        [defaults removeObjectForKey:@"FBAccessTokenKey"];
        [defaults removeObjectForKey:@"FBExpirationDateKey"];
        [defaults synchronize];
    }
}
- (void)fbSessionInvalidated
{
    TRC_ENTRY
    [self fbDidLogout];
}

-(void)request:(FBRequest *)request didReceiveResponse:(NSURLResponse *)response 
{
    TRC_ENTRY
}

-(void)request:(FBRequest *)request didLoad:(id)result
{
    TRC_ENTRY
    // With this method we’ll get any Facebook response in the form of an array.
    // In this example the method will be used twice. Once to get the user’s name to
    // when showing the welcome message and next to get the ID of the published post.
    // Inside the result array there the data is stored as a NSDictionary.    
    if ([result isKindOfClass:[NSArray class]]) {
        // The first object in the result is the data dictionary.
        result = [result objectAtIndex:0];
    }
    
    if ([result objectForKey:@"id"]) {
        
        // If the result contains the "id" key then the data have been posted and the id of the published post have been returned.
        AudioServicesPlaySystemSound(mailSentSound);
    }
}


-(void)request:(FBRequest *)request didFailWithError:(NSError *)error
{
    TRC_DBG(@"Error description: %@", [error localizedDescription]);
    TRC_DBG(@"Error details: %@", [error description]);
}


@end
