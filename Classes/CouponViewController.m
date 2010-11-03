//
//  CouponViewController.m
//  SingtelDining
//
//  Created by Alex Yao Cheng on 10/29/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "CouponViewController.h"
#import "SDBoxView.h"
#import "FlurryAPI.h"

#import "CouponListDataSource.h"


///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
@implementation CouponViewController


///////////////////////////////////////////////////////////////////////////////////////////////////
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
  if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
    self.variableHeightRows = YES;
  }

  return self;
}

- (void)createModel {
  self.dataSource = [[[CouponListDataSource alloc] init] autorelease];
}

- (id<UITableViewDelegate>)createDelegate {
  return [[[TTTableViewPlainVarHeightDelegate alloc] initWithController:self] autorelease];
}

- (void)loadView {
  [super loadView];
  
  UIButton *editButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 57, 30)];
  [editButton setImage:[UIImage imageNamed:@"button-edit.png"] forState:UIControlStateNormal];
  [editButton addTarget:self action:@selector(editButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
  UIBarButtonItem *barEditButton = [[UIBarButtonItem alloc] initWithCustomView:editButton];
  [editButton release];
  self.navigationItem.rightBarButtonItem = barEditButton;
  [barEditButton release];
  
  UILabel* titleView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 128, 19)];
  titleView.text = @"m-Coupon";
  titleView.backgroundColor = [UIColor clearColor];
  titleView.font = [UIFont boldSystemFontOfSize:18];
  titleView.textColor = RGBCOLOR(190, 0, 19);
  titleView.textAlignment = UITextAlignmentCenter;
  //UIImageView *titleView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 128, 19)];
  //titleView.image = [UIImage imageNamed:@"my-favorite.png"];
  SDBoxView *boxView = [[SDBoxView alloc] initWithFrame:CGRectMake(5, 0, 310, kBoxNormalHeight) titleView:titleView];
  [titleView release];
  {
    self.tableView.frame = CGRectMake(5, 40, 300, kBoxNormalHeight-50);
    self.tableView.backgroundColor = [UIColor clearColor];
    [boxView addSubview:self.tableView];
  }
  [self.view addSubview:boxView];
  [boxView release];
}

- (void)viewDidLoad {
  [super viewDidLoad];
  // Flurry analytics
  [FlurryAPI countPageViews:self.navigationController];
}

@end

