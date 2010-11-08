//
//  InfoViewController.m
//  SingtelDining
//
//  Created by Alex Yao Cheng on 7/5/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "InfoViewController.h"


@implementation InfoViewController

- (IBAction)backButtonClicked:(id)sender {
  [self.navigationController popViewControllerAnimated:YES];
}

///////////////////////////////////////////////////////////////////////////////////////////////////

- (void)loadView {
  [super loadView];
  
  UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 65, 39)];
  [backButton setImage:[UIImage imageNamed:@"button-back.png"] forState:UIControlStateNormal];
  [backButton addTarget:self action:@selector(backButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
  UIBarButtonItem *barDoneButton = [[UIBarButtonItem alloc] initWithCustomView:backButton];
  [backButton release];
  self.navigationItem.leftBarButtonItem = barDoneButton;
  [barDoneButton release];
  
  UILabel* titleView = [[[UILabel alloc] init] autorelease];
  self.navigationItem.titleView = titleView;
}
  
@end
