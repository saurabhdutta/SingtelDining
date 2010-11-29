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
#import "CouponListModel.h"
#import "CouponObject.h"
#import "CouponDetailsViewController.h"


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

- (void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
  AppDelegate* ad = (AppDelegate*)[[UIApplication sharedApplication] delegate];
  
  [[TTNavigator navigator].window bringSubviewToFront:ad.banner];
  ad.banner.hidden = NO;
}

- (void)viewWillDisappear:(BOOL)animated {
  [super viewWillDisappear:animated];
  
  AppDelegate* ad = (AppDelegate*)[[UIApplication sharedApplication] delegate];
  ad.banner.hidden = YES;
}

#pragma mark -
#pragma mark UITableViewDelegate
- (void)didSelectObject:(id)object atIndexPath:(NSIndexPath *)indexPath {
  
  if ([object isKindOfClass:[TTTableMoreButton class]]) 
    return;
  
  CouponObject* theCoupon = [((CouponListModel*)self.model).list objectAtIndex:indexPath.row];
  CouponDetailsViewController* c = [[CouponDetailsViewController alloc] initWithCoupon:theCoupon];
  [self.navigationController pushViewController:c animated:YES];
  [c release];
}

- (BOOL)shouldOpenURL:(NSString *)URL {
  return NO;
}

@end

