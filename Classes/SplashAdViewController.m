    //
//  SplashAdViewController.m
//  SingtelDining
//
//  Created by Alex Yao on 2/25/11.
//  Copyright 2011 Cellcity. All rights reserved.
//

#import "SplashAdViewController.h"
#import "AppDelegate.h"


@implementation SplashAdViewController

@synthesize adView;

- (id)initWithURL:(NSString*)urlString {
	if (self = [super init]) {
		[[UIApplication sharedApplication] setStatusBarHidden:NO];
		[self.view setFrame:CGRectMake(0, 20, 320, 460)];
		[self.view setBackgroundColor:[UIColor clearColor]];
		
		adView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, 320, 460)];
		adView.delegate = self;
		[adView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlString]]];
		[self.view addSubview:adView];
		
		NSArray* uiGestureClasses = [NSArray arrayWithObjects:
									 NSStringFromClass([UITapGestureRecognizer class]),
									 NSStringFromClass([UIPinchGestureRecognizer class]),
									 NSStringFromClass([UIRotationGestureRecognizer class]),
									 NSStringFromClass([UISwipeGestureRecognizer class]),
									 NSStringFromClass([UIPanGestureRecognizer class]),
									 NSStringFromClass([UILongPressGestureRecognizer class]),
									 nil];
		UIGestureRecognizer* gr;
		for (NSString* cls in uiGestureClasses) {
			gr = [[NSClassFromString(cls) alloc] initWithTarget:self action:@selector(tap:)];
			gr.delegate = self;
			[adView addGestureRecognizer:gr];
			[gr release];
		}
		/*
		UITapGestureRecognizer *tgr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
		tgr.delegate = self;
		[adView addGestureRecognizer:tgr];
		[tgr autorelease];
		*/
		UIButton* closeButton = [[UIButton alloc] initWithFrame:CGRectMake(290, 0, 30, 30)];
		[closeButton setBackgroundImage:[UIImage imageNamed:@"fancy_closebox.png"] forState:UIControlStateNormal];
		[closeButton addTarget:self action:@selector(closeADView) forControlEvents:UIControlEventTouchUpInside];
		[self.view addSubview:closeButton];
		[closeButton release];
		
		
		[self.view setAlpha:0];
	}
	return self;
}

- (void)tap:(UIGestureRecognizer *)gestureRecognizer {
	NSLog(@"gestureRecognizer: %@", [gestureRecognizer class]);
	[adView removeGestureRecognizer:gestureRecognizer];
	[NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(closeADView) object:@"time out"];
}

// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
/*
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization.
    }
    return self;
}
*/


- (void)closeADView {
	[NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(closeADView) object:@"time out"];
	[UIView beginAnimations:@"CloseAD" context:nil];
	[UIView setAnimationDuration:0.5];
	[UIView setAnimationTransition:UIViewAnimationTransitionCurlUp forView:self.view cache:NO];
	[self.view setAlpha:0];
	[UIView commitAnimations];
}

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
}
*/

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
	[adView release];
	self.adView = nil;
    [super dealloc];
}
#pragma mark -
#pragma mark UIWebViewDelegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)webRequest navigationType:(UIWebViewNavigationType)navigationType {
	if (navigationType == UIWebViewNavigationTypeLinkClicked) {
		//TTOpenURL([NSString stringWithFormat:@"%@", webRequest.URL]);
		//[self performSelector:@selector(closeADView)];
		//return NO;
	}
	return YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
	NSString * theString = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
	NSInteger closeAfter = [[webView stringByEvaluatingJavaScriptFromString:@"document.getElementById(\"close-after-second\").content"] intValue];
	
	if ([theString isEqualToString:@"404 Not Found"] || [theString isEqualToString:@"close"]) {
		NSLog(@"ad page %@",theString);
	} else {
		if (webView.canGoBack==NO) {// webView.canGoBack to detect if its first page
			
			[UIView beginAnimations:@"ShowAD" context:nil];
			[UIView setAnimationDuration:0.5];
			[UIView setAnimationTransition:UIViewAnimationTransitionCurlDown forView:self.view cache:NO];
			[self.view setAlpha:1];
			[UIView commitAnimations];
			
			if (!closeAfter) closeAfter = 5;
			[self performSelector:@selector(closeADView) withObject:@"time out" afterDelay:closeAfter];
		}
	}
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
	NSLog(@"AppDelegate:didFailLoadWithError: %@", error.description);
}

#pragma mark -
#pragma mark UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
	return YES;
}
@end
