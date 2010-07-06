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
#import "CardListDataSource.h"


@implementation FavouritesViewController

- (IBAction)editButtonClicked:(id)sender {
  [self.tableView setEditing:YES animated:YES];
  
  UIButton *editButton = (UIButton *)[self.navigationItem.rightBarButtonItem customView];
  [editButton setImage:[UIImage imageNamed:@"button-done.png"] forState:UIControlStateNormal];
  [editButton addTarget:self action:@selector(cancelButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
}
- (IBAction)cancelButtonClicked:(id)sender {
  [self.tableView setEditing:NO animated:YES];
  
  UIButton *editButton = (UIButton *)[self.navigationItem.rightBarButtonItem customView];
  [editButton setImage:[UIImage imageNamed:@"button-edit.png"] forState:UIControlStateNormal];
  [editButton addTarget:self action:@selector(editButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
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
  
  UIImageView *titleView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 128, 19)];
  titleView.image = [UIImage imageNamed:@"my-favorite.png"];
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
- (void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
  NSLog(@"viewDidAppear");
  self.dataSource = [[[FavouritesDataSource alloc] init] autorelease];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (id<UITableViewDelegate>)createDelegate {
  return [[[TTTableViewPlainVarHeightDelegate alloc] initWithController:self] autorelease];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath; {
  NSLog(@"commitEditingStyle");
}

@end
