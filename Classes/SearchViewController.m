//
//  SearchViewController.m
//  SingtelDining
//
//  Created by Alex Yao on 6/21/10.
//  Copyright 2010 CellCity. All rights reserved.
//

#import "SearchViewController.h"
#import "ListDataSource.h"

// Flurry analytics
#import "FlurryAPI.h"

@implementation SearchViewController

- (IBAction)backButtonClicked:(id)sender {
  [self.navigationController popViewControllerAnimated:YES];
}

- (void)dealloc {
  TT_RELEASE_SAFELY(_query);
  [super dealloc];
}

- (id)initWithNavigatorURL:(NSURL*)URL query:(NSDictionary*)query {
  if (self = [super init]) {
    _query = [[NSMutableDictionary alloc] initWithDictionary:query];
    
    // Flurry analytics
    [FlurryAPI logEvent:@"EVENT_SEARCH" withParameters:query];
  }
  return self;
}

- (void)loadView {
  [super loadView];
  
  // back button
  UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 65, 39)];
  [backButton setImage:[UIImage imageNamed:@"button-back.png"] forState:UIControlStateNormal];
  [backButton addTarget:self action:@selector(backButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
  UIBarButtonItem *barDoneButton = [[UIBarButtonItem alloc] initWithCustomView:backButton];
  [backButton release];
  self.navigationItem.leftBarButtonItem = barDoneButton;
  [barDoneButton release];
  
  UIImageView *titleView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 128, 19)];
  titleView.image = [UIImage imageNamed:@"advance-search.png"];
  SDBoxView *boxView = [[SDBoxView alloc] initWithFrame:CGRectMake(5, 0, 310, kBoxNormalHeight) titleView:titleView];
  
  {
    self.tableView.frame = CGRectMake(5, 40, 300, 310);
    self.tableView.backgroundColor = [UIColor clearColor];
    [boxView addSubview:self.tableView];
  }
  
  [self.view addSubview:boxView];
  [boxView release];
  
}

/////////////////////////////////////////////////////////////////////////////////////
- (void)createModel {
  self.dataSource = [[[ListDataSource alloc] initWithQuery:_query] autorelease];
}
///////////////////////////////////////////////////////////////////////////////////////////////////
- (id<UITableViewDelegate>)createDelegate {
  return [[[TTTableViewPlainVarHeightDelegate alloc] initWithController:self] autorelease];
}

@end
