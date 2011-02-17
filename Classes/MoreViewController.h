//
//  MoreViewController.h
//  SingtelDining
//
//  Created by Alex Yao Cheng on 11/29/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "SDViewController.h"
#import "FlurryAPI.h"


@interface MoreViewController : SDViewController <UIWebViewDelegate>{
	UIWebView * banner;
}

@property(nonatomic,retain) UIWebView * banner;

@end
