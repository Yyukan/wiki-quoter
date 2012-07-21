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
    _scrollView.scrollEnabled = NO;

    [_scrollView addSubview:_previosView.view];
	[_scrollView addSubview:_currentView.view];
	[_scrollView addSubview:_nextView.view];

    [UIUtils setBackgroundImage:self.view image:@"background@2x"];

    // adjust content size for three pages
	[_scrollView setContentSize:CGSizeMake(_scrollView.frame.size.width * 3 , _scrollView.frame.size.height)];	
    
    // reposition to central page
	[_scrollView scrollRectToVisible:CGRectMake(_scrollView.frame.size.width,0,_scrollView.frame.size.width,_scrollView.frame.size.height) animated:NO];
    
    // initialize all indexes for previos, current and next pages
    self.previosIndex = -1;
    self.currentIndex = 0;
    self.nextIndex = 1;

    // load only current page
	[self loadPageByIndex:self.currentIndex onPage:CURRENT_PAGE];
}

- (void)viewDidUnload 
{
    TRC_ENTRY
    self.scrollView = nil;
    [super viewDidUnload];
}

-(BOOL)canBecomeFirstResponder 
{
    return YES;
}

- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    // check if device has been shaked 
    if (motion == UIEventSubtypeMotionShake) 
    {
        _scrollView.scrollEnabled = NO;
        // reset all indexes to default values    
        self.previosIndex = -1;
        self.currentIndex = 0;
        self.nextIndex = 1;
        
        // reload current view (reset all quotes cache)
        [self.currentView reload]; 
        
        // load current page and next page
        [self loadPageByIndex:self.currentIndex onPage:CURRENT_PAGE];
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    TRC_DBG(@"X = %f", scrollView.contentOffset.x);
    if (self.currentIndex == 0 && scrollView.contentOffset.x < _scrollView.frame.size.width) 
    {
        TRC_ENTRY
        [scrollView setContentOffset:CGPointMake(_scrollView.frame.size.width, 0)];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView 
{
    TRC_DBG(@"X = %f", scrollView.contentOffset.x);
    if (self.currentIndex == 0 && scrollView.contentOffset.x < _scrollView.frame.size.width) 
    {
        TRC_ENTRY
        [scrollView setContentOffset:CGPointMake(_scrollView.frame.size.width, 0)];
    }
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView 
{
    TRC_DBG(@"X = %f", scrollView.contentOffset.x);
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
    [self adjustFrame:self.previosView page:PREVIOS_PAGE];
    [self adjustFrame:self.currentView page:CURRENT_PAGE];
    [self adjustFrame:self.nextView page:NEXT_PAGE];
    
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
    
    // TODO:yukan this does not work
    [self loadPageByIndex:_previosIndex onPage:PREVIOS_PAGE];
	[self loadPageByIndex:_currentIndex onPage:CURRENT_PAGE];
	[self loadPageByIndex:_nextIndex onPage:NEXT_PAGE];
}

- (void) quotesAreAvailable
{
    TRC_ENTRY
    if (self.previosIndex >= 0)
    {
        [self loadPageByIndex:self.previosIndex onPage:PREVIOS_PAGE];
    }    
	[self loadPageByIndex:self.currentIndex onPage:CURRENT_PAGE];
	[self loadPageByIndex:self.nextIndex onPage:NEXT_PAGE];

    if (!self.scrollView.scrollEnabled) 
    {
        self.scrollView.scrollEnabled = YES;
    }
}

- (void) sendToTweetter:(Quote *) quote
{
    TWTweetComposeViewController *tweeter = [[TWTweetComposeViewController alloc] init];
    [tweeter setInitialText:[NSString stringWithFormat:@"%@ - %@", quote.text, quote.author]];
    [self presentModalViewController:tweeter animated:YES];
    [tweeter release];
}

- (void) sendToEMail:(Quote *) quote
{
    MFMailComposeViewController *controller = [[MFMailComposeViewController alloc] init];
    [controller.navigationBar setTintColor:[UIUtils colorFromHexString:@"#55707d"]];
    [controller setMailComposeDelegate:self];
    [controller setSubject:@"WikiQuoter"];
    [controller setMessageBody:[NSString stringWithFormat:@"%@ <br/>- %@", quote.text, quote.author] isHTML:YES];
    [self presentModalViewController:controller animated:YES];
    [controller release];
}

- (void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    [self dismissModalViewControllerAnimated:YES];
}

- (void)doSendToFacebook:(NSDictionary *)dictionary 
{
    NSMutableDictionary *parameters = [dictionary objectForKey:@"parameters"];
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
        NSString *text = [NSString stringWithFormat:@"%@ - %@", quote.text, quote.author];
        
        
        // Create the parameters dictionary that will keep the data that will be posted.
        NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                       @"My test app", @"name",
                                       @"WikiQuote app for iPhone!", @"caption",
                                       @"This is a description of my app", @"description",
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
        UIAlertView *al = [[UIAlertView alloc] initWithTitle:@"My test app" message:@"Your message has been posted on your wall!" 
                                                    delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [al show];
        [al release];
    }
}


-(void)request:(FBRequest *)request didFailWithError:(NSError *)error
{
    NSLog(@"%@", [error localizedDescription]);
}


@end
