//
//  CouponViewController.h
//  SingtelDining
//
//  Created by Alex Yao Cheng on 10/29/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "SDViewController.h"
#import "FlurryAPI.h"

@interface CouponViewController : SDViewController <UIWebViewDelegate>{
	UIWebView * banner;
}

@property(nonatomic,retain) UIWebView * banner;

@end
