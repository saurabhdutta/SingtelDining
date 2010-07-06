//
//  SearchViewController.m
//  SingtelDining
//
//  Created by Alex Yao on 6/21/10.
//  Copyright 2010 CellCity. All rights reserved.
//

#import "SearchViewController.h"
#import "ListDataSource.h"


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
  }
  return self;
}

- (void)loadView {
  [super loadView];
  
  // back button
  UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 57, 30)];
  [backButton setImage:[UIImage imageNamed:@"button-back.png"] forState:UIControlStateNormal];
  [backButton addTarget:self action:@selector(backButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
  UIBarButtonItem *barDoneButton = [[UIBarButtonItem alloc] initWithCustomView:backButton];
  [backButton release];
  self.navigationItem.leftBarButtonItem = barDoneButton;
  [barDoneButton release];
  
  SDBoxView *boxView = [[SDBoxView alloc] initWithFrame:CGRectMake(5, 0, 310, kBoxNormalHeight)];
  
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
  
  NSMutableArray* keys = [[NSMutableArray alloc] init];
  NSMutableArray* values = [[NSMutableArray alloc] init];
  
  NSMutableString* type = [NSMutableString stringWithString:@"Location"];
  NSMutableString* sortBy = [NSMutableString stringWithString:@"SelectedLocation"];
  
  for (NSString *keyName in [_query keyEnumerator]) {
    [keys addObject:keyName];
    [values addObject:[_query objectForKey:keyName]];
    if ([keyName isEqualToString:@"latitude"]) {
      sortBy = @"CurrentLocation";
    }
  }
  
  self.dataSource = [[[ListDataSource alloc] initWithType:type andSortBy:sortBy withKeys: keys andValues: values] autorelease];
}
///////////////////////////////////////////////////////////////////////////////////////////////////
- (id<UITableViewDelegate>)createDelegate {
  return [[[TTTableViewPlainVarHeightDelegate alloc] initWithController:self] autorelease];
}

@end
