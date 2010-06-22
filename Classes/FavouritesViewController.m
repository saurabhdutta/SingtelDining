//
//  FavouritesViewController.m
//  SingtelDining
//
//  Created by Alex Yao on 6/16/10.
//  Copyright 2010 CellCity. All rights reserved.
//

#import "FavouritesViewController.h"
#import "SDBoxView.h"
#import "FavouritesDataSource.h"


@implementation FavouritesViewController

- (IBAction)editButtonClicked:(id)sender {
  [self.tableView setEditing:YES animated:YES];
  
  UIBarButtonItem *editButton = self.navigationItem.rightBarButtonItem;
  [editButton setTitle:@""];
  [editButton setImage:[UIImage imageNamed:@"button-done.png"]];
  [editButton setAction:@selector(cancelButtonClicked:)];
}
- (IBAction)cancelButtonClicked:(id)sender {
  [self.tableView setEditing:NO animated:YES];
  
  UIBarButtonItem *editButton = self.navigationItem.rightBarButtonItem;
  [editButton setTitle:@"Edit"];
  [editButton setAction:@selector(editButtonClicked:)];
}

- (void)loadView {
  [super loadView];
  
  UIBarButtonItem *editButton = [[UIBarButtonItem alloc] initWithTitle:@"Edit" style:UIBarButtonItemStyleBordered target:self action:@selector(editButtonClicked:)];
  self.navigationItem.rightBarButtonItem = editButton;
  TT_RELEASE_SAFELY(editButton);
  
  UIImageView *titleView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 128, 19)];
  titleView.image = [UIImage imageNamed:@"credit-title.png"];
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
///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)createModel {
  self.dataSource = [[[FavouritesDataSource alloc] init] autorelease];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (id<UITableViewDelegate>)createDelegate {
  return [[[TTTableViewPlainDelegate alloc] initWithController:self] autorelease];
}

@end
