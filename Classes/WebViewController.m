    //
//  SplashAdViewController.m
//  SingtelDining
//
//  Created by Alex Yao on 2/25/11.
//  Copyright 2011 Cellcity. All rights reserved.
//

#import "WebViewController.h"
#import "AppDelegate.h"


@implementation WebViewController

@synthesize webView1;

- (id)initWithURL:(NSString*)urlString {
	if (self = [super init]) {
	//	[UIApplication sharedApplication] setStatusBarHidden:NO];
	//	[self.view setFrame:CGRectMake(0, 20, 320, 460)];
	//	[self.view setBackgroundColor:[UIColor clearColor]];
		
		webView1 = [[UIWebView alloc] initWithFrame:self.view.frame];
		webView1.delegate = self;
		[webView1 setScalesPageToFit:YES];
		[webView1 loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlString]]];
		[self.view addSubview:webView1];
		//[webView1 release];
		//[self.view setAlpha:1];
	}
	return self;
}


- (IBAction)backButtonClicked:(id)sender {
	[self.navigationController popViewControllerAnimated:YES];
}

- (void) createWebViewWithHTML:(NSString *)bodyText{
    //create the string
    NSMutableString *html = [NSMutableString stringWithString: @"<html><head><title></title></head><body style=\"background:transparant;\">"];
	
    //continue building the string
    [html appendString:@"body content here <a><href>http://www.google.com </href> </a>"];
    [html appendString:@"</body></html>"];
	
    
	if(webView1 == nil){
		//instantiate the web view
		webView1 = [[UIWebView alloc] initWithFrame:self.view.frame];
	
		//make the background transparent
		[webView1 setBackgroundColor:[UIColor clearColor]];
		
		//add it to the subview
		[self.view addSubview:webView1];
	}
	
    //pass the string to the webview
    [webView1 loadHTMLString:[html description] baseURL:nil];

	
	//[webView release];
	
}



// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	// back button
	UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 65, 39)];
	[backButton setImage:[UIImage imageNamed:@"button-back.png"] forState:UIControlStateNormal];
	[backButton addTarget:self action:@selector(backButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
	UIBarButtonItem *barDoneButton = [[UIBarButtonItem alloc] initWithCustomView:backButton];
	[backButton release];
	self.navigationItem.leftBarButtonItem = barDoneButton;
	[barDoneButton release];
}


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
	[webView1 release];
	self.webView1 = nil;
    [super dealloc];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)webRequest navigationType:(UIWebViewNavigationType)navigationType {
	if (navigationType == UIWebViewNavigationTypeLinkClicked) {
		//TTOpenURL([NSString stringWithFormat:@"%@", webRequest.URL]);
		//[self performSelector:@selector(closeADView)];
		//return NO;
	}
	return YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
	
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
	NSLog(@"AppDelegate:didFailLoadWithError: %@", error.description);
}

@end
