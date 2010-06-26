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

- (void)dealloc {
  [super dealloc];
}

- (id) init {
  if (self = [super init]) {
  }
  return self;
}

- (void)loadView {
  [super loadView];
  
  SDBoxView *boxView = [[SDBoxView alloc] initWithFrame:CGRectMake(5, 0, 310, kBoxNormalHeight)];
  
  {
    self.tableView.frame = CGRectMake(5, 40, 300, 310);
    self.tableView.backgroundColor = [UIColor clearColor];
    [boxView addSubview:self.tableView];
  }
  
  {
    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 3, 310, 30)];
    searchBar.delegate = self;
    searchBar.placeholder = @"keyword";
    [[searchBar.subviews objectAtIndex:0] setHidden:YES];
    [boxView addSubview:searchBar];
    TT_RELEASE_SAFELY(searchBar);
  }
  
  [self.view addSubview:boxView];
  [boxView release];
  
}

/////////////////////////////////////////////////////////////////////////////////////
- (void)createModel {
  self.dataSource = [TTListDataSource dataSourceWithItems:[NSMutableArray array]];
}
///////////////////////////////////////////////////////////////////////////////////////////////////
- (id<UITableViewDelegate>)createDelegate {
  return [[[TTTableViewPlainVarHeightDelegate alloc] initWithController:self] autorelease];
}

/////////////////////////////////////////////////////////////////////////////////////
#pragma mark UISearchBarDelegate

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    // Configure our TTModel with the user's search terms
    // and tell the TTModelViewController to reload.
  [searchBar resignFirstResponder];
  self.dataSource = [[[ListDataSource alloc] initWithSearchKeyword:[searchBar text]] autorelease];
  [self reload];
  [self.tableView scrollToTop:YES];
}

@end
