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

#define DROP_DOWN_VIEW_HEIGHT 116

@implementation QuoteViewController

@synthesize imageView = _imageView;
@synthesize label = _label;
@synthesize textView = _textView;
@synthesize dropDownView = _dropDownView;

// Creates the color list the first time this method is invoked. Returns one color object from the list.
+ (UIColor *)pageControlColorWithIndex:(NSUInteger)index {
    return [UIColor greenColor];
}

//
// Memory management
//

- (void)dealloc {
    [_dropDownView release];
    [_label release];
    [_textView release];
    [_imageView release];
    [super dealloc];
}


- (UIButton *)createButton:(CGRect)frame imageName:(NSString *)imageName title:(NSString *)title selector:(SEL) selector
{
    // ru language button 
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];    
    [button addTarget:self action:selector forControlEvents:UIControlEventTouchDown];
    [button setBackgroundColor:[UIColor clearColor]];
    [button setBackgroundImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [button setTitle:title forState:UIControlStateNormal];
    button.frame = frame;
    return button;
}

- (void) initDropDownView:(CGRect) bounds
{
    self.dropDownView = [[UIView alloc] initWithFrame:CGRectMake(0, bounds.size.height + 20 , bounds.size.width, DROP_DOWN_VIEW_HEIGHT)];
    
    [UIUtils setBackgroundImage:self.dropDownView image:@"v_bottom_background_iphone"];

    [self.dropDownView addSubview:[self createButton:CGRectMake(7, 60, 148, 30) imageName:@"lang_button" title:@"ПО-РУССКИ" selector:@selector(ruLanguageButtonPressed:)]];
    [self.dropDownView addSubview:[self createButton:CGRectMake(165, 60, 148, 30) imageName:@"lang_button" title:@"IN ENGLISH" selector:@selector(enLanguageButtonPressed:)]];

    [self.dropDownView addSubview:[self createButton:CGRectMake(20, 10, 40, 40) imageName:@"facebook_iphone" title:nil selector:@selector(toFacebook:)]];
    [self.dropDownView addSubview:[self createButton:CGRectMake(100, 10, 40, 40) imageName:@"twitter_iphone" title:nil selector:@selector(toTwitter:)]];
    [self.dropDownView addSubview:[self createButton:CGRectMake(180, 10, 40, 40) imageName:@"googleplus_iphone" title:nil selector:@selector(toGooglePlus:)]];
    [self.dropDownView addSubview:[self createButton:CGRectMake(260, 10, 40, 40) imageName:@"email_iphone" title:nil selector:@selector(toEmail:)]];
    
}

- (void)viewDidLoad 
{
    [super viewDidLoad];

    CGRect bounds = self.view.bounds;
    
    UIScrollView *scrollView = (UIScrollView *) self.view;
    scrollView.contentOffset = CGPointMake(0, 0);
    
    [self initDropDownView : bounds];
    
    [scrollView addSubview:self.dropDownView];
    
    scrollView.pagingEnabled = TRUE;
    
    scrollView.bounces = FALSE;
    scrollView.showsHorizontalScrollIndicator = FALSE;
    scrollView.showsVerticalScrollIndicator = NO;
    
    scrollView.contentSize = CGSizeMake(bounds.size.width, bounds.size.height + DROP_DOWN_VIEW_HEIGHT);
    scrollView.delegate = self;

    self.view.backgroundColor = [UIColor clearColor];
    
    self.label.font = [UIFont fontWithName:@"Philosopher" size:17];
    self.textView.font = [UIFont fontWithName:@"Philosopher" size:23];
    
    // how to center text in text view, notify itself about content size changing
    [self.textView addObserver:self forKeyPath:@"contentSize" options:(NSKeyValueObservingOptionNew) context:NULL];
}

- (void)viewDidUnload
{
    [self.dropDownView release];
    
    [super viewDidUnload];
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

- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if (UIInterfaceOrientationIsPortrait(interfaceOrientation))
    {
        self.imageView.image = [UIImage imageNamed:@"v_frame_iphone"];

        CGRect textViewFrame = CGRectMake(38, 66, 246, 344);
        CGRect labelViewFrame = CGRectMake(20, 439, 280, 21);
        
        self.textView.frame = textViewFrame;
        self.label.frame = labelViewFrame;
    }
    else if (UIInterfaceOrientationIsLandscape(interfaceOrientation))
    {
        self.imageView.image = [UIImage imageNamed:@"h_frame_iphone"];

        CGRect labelViewFrame = CGRectMake(100, 290, 280, 21);
        CGRect textViewFrame = CGRectMake(115, 65, 250, 195);
        
        self.textView.frame = textViewFrame;
        self.label.frame = labelViewFrame;
    }
    
    return YES;
}

- (IBAction)ruLanguageButtonPressed:(id)sender
{
    TRC_ENTRY
}

- (IBAction)enLanguageButtonPressed:(id)sender
{
    TRC_ENTRY
}

- (IBAction)toFacebook:(id)sender
{
    TRC_ENTRY
}

- (IBAction)toTwitter:(id)sender
{
    TRC_ENTRY
}

- (IBAction)toEmail:(id)sender
{
    TRC_ENTRY
}

- (IBAction)toGooglePlus:(id)sender
{
    TRC_ENTRY
}

@end


