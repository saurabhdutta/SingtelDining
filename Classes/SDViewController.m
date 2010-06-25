//
//  SDViewController.m
//  SingtelDining
//
//  Created by Alex Yao on 6/14/10.
//  Copyright 2010 CellCity. All rights reserved.
//

#import "SDViewController.h"


@implementation SDViewController

- (id)init {
  if (self = [super init]) {
    //self.title = @"test";
    
    UIButton *doneButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 57, 30)];
    [doneButton setImage:[UIImage imageNamed:@"button-done.png"] forState:UIControlStateNormal];
    [doneButton addTarget:self action:@selector(doneButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barDoneButton = [[UIBarButtonItem alloc] initWithCustomView:doneButton];
    [doneButton release];
    self.navigationController.navigationItem.backBarButtonItem = barDoneButton;
    [barDoneButton release];
    
    self.variableHeightRows = YES;
  }
  return self;
}

- (void)loadView {
  [super loadView];
  self.view.backgroundColor = [UIColor clearColor];
  self.navigationController.navigationBar.backgroundColor = [UIColor clearColor];
  
  UIButton *doneButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 57, 30)];
  [doneButton setImage:[UIImage imageNamed:@"button-done.png"] forState:UIControlStateNormal];
  [doneButton addTarget:self action:@selector(doneButtonClicked) forControlEvents:UIControlEventTouchUpInside];
  UIBarButtonItem *barDoneButton = [[UIBarButtonItem alloc] initWithCustomView:doneButton];
  [doneButton release];
  self.navigationController.navigationItem.backBarButtonItem = barDoneButton;
  [barDoneButton release];
  
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  
  // show tabbar
  NSArray *views = [self.tabBarController.view subviews];
  CGRect frame = self.tabBarController.view.frame;
  [self.tabBarController.view setFrame:CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, 480)];
  for(id v in views){
    if([v isKindOfClass:[UITabBar class]]){
      [(UITabBar *)v setHidden:NO];
    }
  }
}

@end
