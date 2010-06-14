//
//  CreditViewController.m
//  SingtelDining
//
//  Created by Alex Yao on 6/11/10.
//  Copyright 2010 CellCity. All rights reserved.
//

#import "CreditViewController.h"


@implementation CreditViewController

#pragma mark -
- (void)doneButtonClicked {
  // 
}

#pragma mark -
- (id)init {
  if (self = [super init]) {
    //self.title = @"Singtel Dining";
  }
  return self;
}

- (void)dealloc {
	[super dealloc];
}

#pragma mark -
#pragma mark TTViewController
- (void)loadView {
  [super loadView];
  self.view.backgroundColor = [UIColor clearColor];
  
  //UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleBordered target:self action:@selector(doneButtonClicked)];
  UIButton *doneButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 57, 30)];
  [doneButton setImage:[UIImage imageNamed:@"button-done.png"] forState:UIControlStateNormal];
  [doneButton setImage:[UIImage imageNamed:@"button-done.png"] forState:UIControlStateSelected];
  [doneButton addTarget:self action:@selector(doneButtonClicked) forControlEvents:UIControlEventTouchUpInside];
  UIBarButtonItem *barDoneButton = [[UIBarButtonItem alloc] initWithCustomView:doneButton];
  [doneButton release];
  self.navigationItem.rightBarButtonItem = barDoneButton;
  [barDoneButton release];
  
  UILabel *testLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 20)];
  testLabel.textAlignment = UITextAlignmentCenter;
  testLabel.text = @"hello world";
  testLabel.backgroundColor = [UIColor clearColor];
  [self.view addSubview:testLabel];
  [testLabel release];
  
  self.navigationController.navigationBar.backgroundColor = [UIColor clearColor];
}

#pragma mark -

@end
