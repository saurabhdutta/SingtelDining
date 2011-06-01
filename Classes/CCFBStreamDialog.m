//
//  CCFBStreamDialog.m
//  SingtelDining
//
//  Created by DBS Mobile Apps on 5/18/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CCFBStreamDialog.h"


@implementation CCFBStreamDialog
@synthesize message;

- (void)dealloc {
	self.message = nil;
	[super dealloc];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView 

{
	
	[super webViewDidFinishLoad:webView];
	
	if (message)
		
	{
		
		[webView stringByEvaluatingJavaScriptFromString:
		 
		 [NSString stringWithFormat:@"document.getElementsByName('feedform_user_message')[0].value = decodeURIComponent('%@')",
		  
		  [[message stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] stringByReplacingOccurrencesOfString:@"'" withString:@"\\'"]
		  
		  ]
		 
		 ];
		
		[webView stringByEvaluatingJavaScriptFromString:@"document.getElementsByName('feedform_user_message')[0].style.height='100px'"];
		
	}
	
}


@end
