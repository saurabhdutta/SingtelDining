//
//  CouponViewController.m
//  SingtelDining
//
//  Created by Alex Yao Cheng on 10/29/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "CouponViewController.h"
#import "SDBoxView.h"
#import "FlurryAPI.h"

#import "CouponListDataSource.h"
#import "CouponListModel.h"
#import "CouponObject.h"
#import "CouponDetailsViewController.h"


///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
@implementation CouponViewController

@synthesize banner;

///////////////////////////////////////////////////////////////////////////////////////////////////
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
  if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
    self.variableHeightRows = YES;
  }

  return self;
}

- (void)createModel {
  self.dataSource = [[[CouponListDataSource alloc] init] autorelease];
}

- (id<UITableViewDelegate>)createDelegate {
  return [[[TTTableViewPlainVarHeightDelegate alloc] initWithController:self] autorelease];
}

- (void)loadView {
  [super loadView];
    
  UILabel* titleView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 128, 19)];
  titleView.text = @"m-Coupons";
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

- (void)viewDidLoad {
  [super viewDidLoad];
  // Flurry analytics
  [FlurryAPI countPageViews:self.navigationController];
	
	// UIWebView
	UIWebView * aBanner = [[UIWebView alloc] initWithFrame:CGRectMake(5, 25, 310, 35)];
	self.banner = aBanner;
	[aBanner release];
	[[[banner subviews] lastObject] setScrollEnabled:NO];
	banner.delegate = self;
	banner.layer.cornerRadius = 5;
	banner.layer.masksToBounds = YES;
	banner.alpha = 0.0;
	NSURLRequest* bannerRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:URL_BANNER_AD_M_COUPONS]];
	[banner loadRequest:bannerRequest];
	[[TTNavigator navigator].window addSubview:banner];
	
	
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  [self invalidateModel];
  //AppDelegate* ad = (AppDelegate*)[[UIApplication sharedApplication] delegate];
  
  //[[TTNavigator navigator].window bringSubviewToFront:banner];
	
  //NSURLRequest* bannerRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:URL_BANNER_AD_M_COUPONS]];
  //[banner loadRequest:bannerRequest];
	
  banner.hidden = NO;
}

- (void)viewWillDisappear:(BOOL)animated {
  [super viewWillDisappear:animated];
  
  //AppDelegate* ad = (AppDelegate*)[[UIApplication sharedApplication] delegate];
  banner.hidden = YES;
}

#pragma mark -
#pragma mark UITableViewDelegate
- (void)didSelectObject:(id)object atIndexPath:(NSIndexPath *)indexPath {
  
  if ([object isKindOfClass:[TTTableMoreButton class]]) 
    return;
  
  CouponObject* theCoupon = [((CouponListModel*)self.model).list objectAtIndex:indexPath.row];
  CouponDetailsViewController* c = [[CouponDetailsViewController alloc] initWithCoupon:theCoupon];
  [self.navigationController pushViewController:c animated:YES];
  [c release];
}

- (BOOL)shouldOpenURL:(NSString *)URL {
  return NO;
}

#pragma mark -
#pragma mark UIWebViewDelegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)webRequest navigationType:(UIWebViewNavigationType)navigationType {
	
	NSLog(@"AppDelegate: shouldStartLoadWithRequest");	
	
	TTDPRINT(@"webview navigationType: %d", navigationType);
	if (navigationType == UIWebViewNavigationTypeLinkClicked) {
		// Flurry
		NSMutableDictionary* analytics = [[NSMutableDictionary alloc] init];
		[analytics setObject:@"M_COUPONS" forKey:@"CATEGORY"];
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
	
	//banner.alpha = 0.0;
}


- (void)dealloc {
	[banner release];
	[super dealloc];
}

@end

