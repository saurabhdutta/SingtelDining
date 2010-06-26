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
  TT_RELEASE_SAFELY(searchBox);
  [super dealloc];
}

- (void)loadView {
  [super loadView];
  
  SDBoxView *boxView = [[SDBoxView alloc] initWithFrame:CGRectMake(5, 0, 310, kBoxNormalHeight)];
  
  {
    self.tableView.frame = CGRectMake(5, 40, 300, 280);
    self.tableView.backgroundColor = [UIColor clearColor];
    [boxView addSubview:self.tableView];
  }
  
  {
    // refresh button
    {
      UIButton *refreshButton = [[UIButton alloc] initWithFrame:CGRectMake(2, 0, 34, 33)];
      [refreshButton setImage:[UIImage imageNamed:@"button-refresh.png"] forState:UIControlStateNormal];
      [refreshButton addTarget:self action:nil forControlEvents:UIControlEventTouchUpInside];
      [boxView addSubview:refreshButton];
      [refreshButton release];
    }
    
    // search box
    {
      searchBox = [[UITextField alloc] initWithFrame:CGRectMake(37, 2, 160, 30)];
      //searchBox.style = [[TTStyleSheet globalStyleSheet] styleWithSelector:@"searchTextField"];
      [searchBox setBorderStyle:UITextBorderStyleRoundedRect];
      [searchBox setDelegate:self];
      [searchBox setReturnKeyType:UIReturnKeySearch];
      [boxView addSubview:searchBox];
      TT_RELEASE_SAFELY(searchBox);
    }
    
    // search button
    {
      UIButton *searchButton = [[UIButton alloc] initWithFrame:CGRectMake(200, 2, 100, 30)];
      [searchButton setTitle:@"Search" forState:UIControlStateNormal];
      [boxView addSubview:searchButton];
      TT_RELEASE_SAFELY(searchButton);
    }
  }
  
  [self.view addSubview:boxView];
  [boxView release];
  
}

////////////////////////////////////////////////////////////////////////////////
- (void)createModel {
  self.dataSource = [[[TTTableViewInterstitialDataSource alloc] init] autorelease];
}
///////////////////////////////////////////////////////////////////////////////////////////////////
- (id<UITableViewDelegate>)createDelegate {
  return [[[TTTableViewPlainVarHeightDelegate alloc] initWithController:self] autorelease];
}
////////////////////////////////////////////////////////////////////////////////
- (BOOL)textFieldShouldClear:(UITextField *)textField {
  return YES;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
  [textField resignFirstResponder];
  return YES;
}

- (IBAction)startSearch:(id)sender {
  self.dataSource = [[[ListDataSource alloc] initWithSearchQuery:[searchBox text]] autorelease];
}

@end
