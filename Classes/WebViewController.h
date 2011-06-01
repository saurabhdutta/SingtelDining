//
//  SplashAdViewController.h
//  SingtelDining
//
//  Created by Alex Yao on 2/25/11.
//  Copyright 2011 Cellcity. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface WebViewController : UIViewController <UIWebViewDelegate> {
	UIWebView* webView1;
}

@property (nonatomic, retain) UIWebView* webView1;

- (void)createWebViewWithHTML:(NSString *)bodyText;
- (IBAction)backButtonClicked:(id)sender;
@end
