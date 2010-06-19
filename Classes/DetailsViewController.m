//
//  DetailsViewController.m
//  SingtelDining
//
//  Created by Alex Yao on 6/18/10.
//  Copyright 2010 CellCity. All rights reserved.
//

#import "DetailsViewController.h"


@implementation DetailsViewController

- (void)loadView {
  [super loadView];
  
  UIScrollView *topView = [[UIScrollView alloc] initWithFrame:CGRectMake(5, 0, 310, 140)];
  topView.backgroundColor = [UIColor whiteColor];
  topView.layer.cornerRadius = 6;
  topView.layer.masksToBounds = YES;
  topView.scrollEnabled = YES;
  {
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 220, 150)];
    titleLabel.backgroundColor = [UIColor grayColor];
    titleLabel.text = @"Aans Korea Restaurant";
    [topView addSubview:titleLabel];
    TT_RELEASE_SAFELY(titleLabel);
  }
  [topView setContentSize:CGSizeMake(280, 200)];
  [self.view addSubview:topView];
  TT_RELEASE_SAFELY(topView);
}

@end
