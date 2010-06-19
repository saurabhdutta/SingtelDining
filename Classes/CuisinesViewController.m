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
  
  SDListView *boxView = [[SDListView alloc] initWithFrame:CGRectMake(5, 0, 310, 305)];
  
  {
    self.tableView.frame = CGRectMake(5, 40, 300, 280);
    self.tableView.backgroundColor = [UIColor clearColor];
    self.dataSource = [TTListDataSource dataSourceWithItems:
                       [NSArray arrayWithObjects:
                        [TTTableSubtitleItem itemWithText:@"Aans Korea Resturants" subtitle:@"Orchard Central, #12-08" imageURL:@"bundle://sample-list-image.png" URL:kAppLocaltionURLPath],
                        [TTTableSubtitleItem itemWithText:@"Aans Korea Resturants" subtitle:@"Orchard Central, #12-08" imageURL:@"bundle://sample-list-image.png" URL:kAppLocaltionURLPath],
                        [TTTableSubtitleItem itemWithText:@"Aans Korea Resturants" subtitle:@"Orchard Central, #12-08" imageURL:@"bundle://sample-list-image.png" URL:kAppLocaltionURLPath],
                        [TTTableSubtitleItem itemWithText:@"Aans Korea Resturants" subtitle:@"Orchard Central, #12-08" imageURL:@"bundle://sample-list-image.png" URL:kAppLocaltionURLPath],
                        [TTTableSubtitleItem itemWithText:@"Aans Korea Resturants" subtitle:@"Orchard Central, #12-08" imageURL:@"bundle://sample-list-image.png" URL:kAppLocaltionURLPath],
                        [TTTableSubtitleItem itemWithText:@"Aans Korea Resturants" subtitle:@"Orchard Central, #12-08" imageURL:@"bundle://sample-list-image.png" URL:kAppLocaltionURLPath],
                        [TTTableSubtitleItem itemWithText:@"Aans Korea Resturants" subtitle:@"Orchard Central, #12-08" imageURL:@"bundle://sample-list-image.png" URL:kAppLocaltionURLPath],
                        [TTTableSubtitleItem itemWithText:@"Aans Korea Resturants" subtitle:@"Orchard Central, #12-08" imageURL:@"bundle://sample-list-image.png" URL:kAppLocaltionURLPath],
                        nil]];
    
    [boxView addSubview:self.tableView];
  }
  
  [self.view addSubview:boxView];
  [boxView release];
}

@end
