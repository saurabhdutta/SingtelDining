//
//  BlockViewController.m
//  SingtelDining
//
//  Created by Alex Yao Cheng on 7/8/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "BlockViewController.h"


@implementation BlockViewController

- (void)loadView {
  self.view = [[[UIView alloc] initWithFrame:TTApplicationFrame()] autorelease];
  self.view.backgroundColor = [UIColor clearColor];
  self.navigationController.navigationBar.backgroundColor = [UIColor clearColor];
  
  UILabel* msg = [[UILabel alloc] initWithFrame:TTApplicationFrame()];
  msg.backgroundColor = [UIColor clearColor];
  msg.textColor = [UIColor whiteColor];
  msg.textAlignment = UITextAlignmentCenter;
  msg.text = @"This service is available only on a Singtel mobile network.";
  msg.numberOfLines = 0;
  [self.view addSubview:msg];
  [msg release];
}

@end
