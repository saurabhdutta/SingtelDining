//
//  CuisinesViewController.m
//  SingtelDining
//
//  Created by Alex Yao on 6/16/10.
//  Copyright 2010 CellCity. All rights reserved.
//

#import "CuisinesViewController.h"
#import "SDListView.h"


@implementation CuisinesViewController

#pragma mark -

- (void)loadView {
  [super loadView];
  
  SDListView *boxView = [[SDListView alloc] initWithFrame:CGRectMake(5, 0, 310, 300)];
  [self.view addSubview:boxView];
  [boxView release];
   
   // table view
   {
      //TTTableView *tableView = [[TTTableView alloc] initWithFrame:CGRectMake(5, 40, 300, 300)];
      TTTableView *tableView = [[TTTableView alloc] initWithFrame:CGRectMake(5, 40, 300, 280)];
      tableView.delegate = self;
      tableView.tag = 1001;
      tableView.dataSource = [[TTListDataSource dataSourceWithItems:
                               [NSArray arrayWithObjects:
                                [TTTableSubtitleItem itemWithText:@"Aans Korea Resturants" subtitle:@"Orchard Central, #12-08" imageURL:@"bundle://sample-list-image.png" URL:kAppLocaltionURLPath],
                                [TTTableSubtitleItem itemWithText:@"Aans Korea Resturants" subtitle:@"Orchard Central, #12-08" imageURL:@"bundle://sample-list-image.png" URL:kAppLocaltionURLPath],
                                [TTTableSubtitleItem itemWithText:@"Aans Korea Resturants" subtitle:@"Orchard Central, #12-08" imageURL:@"bundle://sample-list-image.png" URL:kAppLocaltionURLPath],
                                [TTTableSubtitleItem itemWithText:@"Aans Korea Resturants" subtitle:@"Orchard Central, #12-08" imageURL:@"bundle://sample-list-image.png" URL:kAppLocaltionURLPath],
                                [TTTableSubtitleItem itemWithText:@"Aans Korea Resturants" subtitle:@"Orchard Central, #12-08" imageURL:@"bundle://sample-list-image.png" URL:kAppLocaltionURLPath],
                                [TTTableSubtitleItem itemWithText:@"Aans Korea Resturants" subtitle:@"Orchard Central, #12-08" imageURL:@"bundle://sample-list-image.png" URL:kAppLocaltionURLPath],
                                [TTTableSubtitleItem itemWithText:@"Aans Korea Resturants" subtitle:@"Orchard Central, #12-08" imageURL:@"bundle://sample-list-image.png" URL:kAppLocaltionURLPath],
                                [TTTableSubtitleItem itemWithText:@"Aans Korea Resturants" subtitle:@"Orchard Central, #12-08" imageURL:@"bundle://sample-list-image.png" URL:kAppLocaltionURLPath],
                                nil]] 
                              retain];
      
      [boxView addSubview:tableView];
      [tableView release];
   }
}

@end
