//
//  MoreViewController.m
//  SingtelDining
//
//  Created by Alex Yao Cheng on 11/29/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "MoreViewController.h"
#import "SDBoxView.h"


@implementation MoreViewController

- (void)loadView {
  [super loadView];
  
  UILabel* titleView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 128, 19)];
  titleView.text = @"More";
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

- (void)createModel {
  self.dataSource = [TTListDataSource dataSourceWithObjects:
                     [TTTableTextItem itemWithText:@"Favourite" URL:kAppFavouritesURLPath],
                     [TTTableTextItem itemWithText:@"Search" URL:kAppSearchURLPath],
                     nil
                     ];
}

@end
