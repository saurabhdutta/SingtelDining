//
//  MoreViewController.m
//  SingtelDining
//
//  Created by Alex Yao Cheng on 11/29/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "MoreViewController.h"
#import "SDBoxView.h"


@implementation MoreViewController

@synthesize banner;

- (void)loadView {
  [super loadView];
  
  UILabel* titleView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 128, 19)];
  titleView.text = @"More";
  titleView.backgroundColor = [UIColor clearColor];
  titleView.font = [UIFont boldSystemFontOfSize:18];
  titleView.textColor = RGBCOLOR(190, 0, 19);
  titleView.textAlignment = UITextAlignmentCenter;
  //UIImageView *titleView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 128, 19)];
  //titleView.image = [UIImage imageNamed:@"my-favorite.png"];
  SDBoxView *boxView = [[SDBoxView alloc] initWithFrame:CGRectMake(5, 0, 310, kBoxNormalHeight) titleView:titleView];
  [titleView release];
  {
    self.tableView.frame = CGRectMake(5, 40, 300, kBoxNormalHeight-50);
    self.tableView.backgroundColor = [UIColor clearColor];
    [boxView addSubview:self.tableView];
  }
  [self.view addSubview:boxView];
  [boxView release];
}

- (void)createModel {
  self.dataSource = [TTListDataSource dataSourceWithObjects:
                     [TTTableTextItem itemWithText:@"Favourites" URL:kAppFavouritesURLPath],
                     [TTTableTextItem itemWithText:@"Search" URL:kAppSearchURLPath],
                     nil
                     ];
}

- (void) viewDidLoad {
	// UIWebView
	UIWebView * aBanner = [[UIWebView alloc] initWithFrame:CGRectMake(5, 25, 310, 35)];
	self.banner = aBanner;
	[aBanner release];
	[[[banner subviews] lastObject] setScrollEnabled:NO];
	banner.delegate = self;
	banner.layer.cornerRadius = 5;
	banner.layer.masksToBounds = YES;
	banner.alpha = 0.0;
	NSURLRequest* bannerRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:URL_BANNER_AD_MORE]];
	[banner loadRequest:bannerRequest];
	[[TTNavigator navigator].window addSubview:banner];
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  //AppDelegate* ad = (AppDelegate*)[[UIApplication sharedApplication] delegate];
  
  //[[TTNavigator navigator].window bringSubviewToFront:banner];
	
  //NSURLRequest* bannerRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:URL_BANNER_AD_MORE]];
  //[banner loadRequest:bannerRequest];	
	
  banner.hidden = NO;
}

- (void)viewWillDisappear:(BOOL)animated {
  [super viewWillDisappear:animated];
  
  //AppDelegate* ad = (AppDelegate*)[[UIApplication sharedApplication] delegate];
  banner.hidden = YES;
}

#pragma mark -
#pragma mark UIWebViewDelegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)webRequest navigationType:(UIWebViewNavigationType)navigationType {
	
	NSLog(@"AppDelegate: shouldStartLoadWithRequest");	
	
	TTDPRINT(@"webview navigationType: %d", navigationType);
	if (navigationType == UIWebViewNavigationTypeLinkClicked) {
		// Flurry
		NSMutableDictionary* analytics = [[NSMutableDictionary alloc] init];
		[analytics setObject:@"MORE" forKey:@"CATEGORY"];
		[analytics setObject:webRequest.URL forKey:@"URL"];
		[FlurryAPI logEvent:@"BANNER_CLICK" withParameters:analytics];
		[analytics release];
		
		TTOpenURL([NSString stringWithFormat:@"%@", webRequest.URL]);
		return NO;
	}
	return YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
	NSLog(@"AppDelegate: webViewDidFinishLoad");	
	
	NSString * theString = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
	
	if ([theString isEqualToString:@"404 Not Found"]) {
		banner.alpha = 0.0;
	}
	else {
		banner.alpha = 1.0;
	}
	NSLog(@"...............theString=%@",theString);
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
	
	NSLog(@"AppDelegate:didFailLoadWithError: %@", error.description);
	
	//if (error.code == NSURLErrorCancelled) return; 
	
	banner.alpha = 0.0;
}


- (void) dealloc {
	[banner release];
	[super dealloc];
}

@end
