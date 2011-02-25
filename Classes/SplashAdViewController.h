//
//  SplashAdViewController.h
//  SingtelDining
//
//  Created by Alex Yao on 2/25/11.
//  Copyright 2011 Cellcity. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface SplashAdViewController : UIViewController <UIWebViewDelegate> {
	UIWebView* adView;
}

@property (nonatomic, retain) UIWebView* adView;

- (void)closeADView;

@end
