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

#define DROP_DOWN_VIEW_HEIGHT 100
#define STATUS_BAR_HEIGHT 20

@implementation QuoteViewController

@synthesize imageView = _imageView;
@synthesize label = _label;
@synthesize textView = _textView;
@synthesize dropDownView = _dropDownView;
@synthesize indicator = _indicator;

@synthesize quote = _quote;
@synthesize wikiQuoter = _wikiQuoter;
@synthesize delegate = _delegate;

#pragma mark -
#pragma mark Initialization and memory management 

- (void)dealloc 
{
    [_quote release];
    [_dropDownView release];
    [_label release];
    [_textView release];
    [_imageView release];
    [super dealloc];
}

- (WikiQuoter *)wikiQuoter
{
    if (_wikiQuoter == nil)
    {
        _wikiQuoter = [WikiQuoter sharedWikiQuoter];
        _wikiQuoter.delegate = [self delegate];
    }
    return _wikiQuoter;
}

- (UIButton *)createButton:(CGRect)frame imageName:(NSString *)imageName title:(NSString *)title selector:(SEL) selector
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];    
    [button addTarget:self action:selector forControlEvents:UIControlEventTouchDown];
    [button setBackgroundColor:[UIColor clearColor]];
    [button setBackgroundImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [button setTitle:title forState:UIControlStateNormal];
    [button.titleLabel setFont:[UIFont fontWithName:@"Philosopher" size:17]];
    [button setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin];
    [button setFrame:frame];
    return button;
}

/**
 * Buttons 20,100,180,260 
 */
- (void) initDropDownView:(CGRect) bounds
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, bounds.size.height - DROP_DOWN_VIEW_HEIGHT, bounds.size.width, DROP_DOWN_VIEW_HEIGHT)];
    
    self.dropDownView = view;
    [view release];
    
    [UIUtils setBackgroundImage:self.dropDownView image:@"v_bottom_background_iphone"];

    [self.dropDownView addSubview:[self createButton:CGRectMake(7, 60, 148, 30) imageName:@"lang_button" title:@"ПО-РУССКИ" selector:@selector(ruLanguageButtonPressed:)]];
    [self.dropDownView addSubview:[self createButton:CGRectMake(165, 60, 148, 30) imageName:@"lang_button" title:@"IN ENGLISH" selector:@selector(enLanguageButtonPressed:)]];

    [self.dropDownView addSubview:[self createButton:CGRectMake(20, 10, 40, 40) imageName:@"facebook_iphone" title:nil selector:@selector(toFacebook:)]];
    [self.dropDownView addSubview:[self createButton:CGRectMake(140, 10, 40, 40) imageName:@"twitter_iphone" title:nil selector:@selector(toTwitter:)]];
    [self.dropDownView addSubview:[self createButton:CGRectMake(260, 10, 40, 40) imageName:@"email_iphone" title:nil selector:@selector(toEmail:)]];
}

- (void)viewDidLoad 
{
    [super viewDidLoad];

    UIScrollView *scrollView = (UIScrollView *) self.view;
    if (isPhone568)
    {
        self.view.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, 568 + DROP_DOWN_VIEW_HEIGHT);
    }
    else
    {
        self.view.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, 480 + DROP_DOWN_VIEW_HEIGHT);
    }
    
    [self initDropDownView : self.view.frame];
    
    [scrollView addSubview:self.dropDownView];
    
    scrollView.pagingEnabled = YES;
    
    scrollView.bounces = NO;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    
    scrollView.contentSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height);
    scrollView.contentOffset = CGPointMake(0, 0);
    scrollView.delegate = self;

    self.view.backgroundColor = [UIColor clearColor];
    
    [self.label.titleLabel setFont:[UIFont fontWithName:@"Philosopher" size:17]];
    [self.label addTarget:self action:@selector(authorTouched:) forControlEvents:UIControlEventTouchDown];

    [self.textView setFont:[UIFont fontWithName:@"Philosopher" size:23]];
    
    // how to center text in text view, notify itself about content size changing
    [self.textView addObserver:self forKeyPath:@"contentSize" options:(NSKeyValueObservingOptionNew) context:NULL];
    
    // activity indicator
    self.indicator = [[[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray] autorelease];
    self.indicator.center = self.view.center;
    self.indicator.autoresizingMask = (UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin);
    self.indicator.hidesWhenStopped = YES;
    [self.view addSubview: self.indicator];
}

- (void)viewDidUnload
{
    TRC_ENTRY
    self.indicator = nil;
    self.dropDownView = nil;
    [super viewDidUnload];
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

- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
//    CGRect bounds = self.view.bounds;
//
//    UIScrollView *scrollView = (UIScrollView *) self.view;
//
//    if (UIInterfaceOrientationIsPortrait(interfaceOrientation))
//    {
//        self.imageView.image = [UIImage imageNamed:@"v_frame_iphone"];
//
//        CGRect textViewFrame = CGRectMake(38, 66, 246, 344);
//        CGRect labelViewFrame = CGRectMake(20, 439, 280, 21);
//        
//        self.textView.frame = textViewFrame;
//        self.label.frame = labelViewFrame;
//    }
//    else if (UIInterfaceOrientationIsLandscape(interfaceOrientation))
//    {
//        self.imageView.image = [UIImage imageNamed:@"h_frame_iphone"];
//
//        CGRect labelViewFrame = CGRectMake(100, 290, 280, 21);
//        CGRect textViewFrame = CGRectMake(90, 65, 295, 193);
//        
//        self.textView.frame = textViewFrame;
//        self.label.frame = labelViewFrame;
//        
//    }    
//    
//    scrollView.contentSize = CGSizeMake(bounds.size.width, bounds.size.height + DROP_DOWN_VIEW_HEIGHT);
//
//    self.dropDownView.frame = CGRectMake(0, bounds.size.height + STATUS_BAR_HEIGHT , bounds.size.width, DROP_DOWN_VIEW_HEIGHT);
    
    return interfaceOrientation == UIInterfaceOrientationPortrait;
}

- (void) updateByIndex:(int) index
{
    self.quote = [self.wikiQuoter getByIndex:index];
    
    if ([self.quote.text isEqual:@""])
    {
        [self.indicator startAnimating];
    } 
    else 
    {
        [self.indicator stopAnimating];
    }
    
    [self.label setTitle:self.quote.author forState:UIControlStateNormal];
    [self.textView setText:self.quote.text];
}

- (void) reload
{
    [self.wikiQuoter reload];
}

- (IBAction)ruLanguageButtonPressed:(id)sender
{
    if (![self.wikiQuoter.language isEqual:LANG_RU])
    {
        [self.wikiQuoter setLanguage:LANG_RU];
        [self.delegate languageHasChanged:LANG_RU];
    }
}

- (IBAction)enLanguageButtonPressed:(id)sender
{
    if (![self.wikiQuoter.language isEqual:LANG_EN])
    {
        [self.wikiQuoter setLanguage:LANG_EN];
        [self.delegate languageHasChanged:LANG_EN];
    }
}

- (IBAction)toFacebook:(id)sender
{
    if (self.quote && ![StringUtils isEmptyString:self.quote.text])
    {
        [self.delegate sendToFacebook:self.quote];
    }    
}

- (IBAction)toTwitter:(id)sender
{
    if (self.quote && ![StringUtils isEmptyString:self.quote.text])
    {
        [self.delegate sendToTweetter:self.quote];
    }    
}

- (IBAction)toEmail:(id)sender
{
    if (self.quote && ![StringUtils isEmptyString:self.quote.text])
    {
        [self.delegate sendToEMail:self.quote];
    }
}

- (IBAction)authorTouched:(id)sender
{
    if (self.quote && ![StringUtils isEmptyString:self.quote.identifier])
    {
        NSString *url = [NSString stringWithFormat:@"http://%@.wikiquote.org/?curid=%@", self.wikiQuoter.language, self.quote.identifier];
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString: url]];
    }
}
@end


