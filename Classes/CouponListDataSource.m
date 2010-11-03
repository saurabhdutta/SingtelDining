//
//  CouponListDataSource.m
//  SingtelDining
//
//  Created by Alex Yao Cheng on 11/2/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "CouponListDataSource.h"

#import "CouponListModel.h"
#import "CouponObject.h"
#import "CouponTableItem.h"
#import "CouponTableItemCell.h"


@implementation CouponListDataSource

- (id)init {
  if (self = [super init]) {
    self.model = [[[CouponListModel alloc] init] autorelease];
    ((CouponListModel*)self.model).pageNum = 1;
    ((CouponListModel*)self.model).resultsPerPage = 10;
  }
  return self;
}

- (void)tableViewDidLoadModel:(UITableView *)tableView {
  
  NSMutableArray* items = [[NSMutableArray alloc] init];
  
  UIImage* placeHolder = [UIImage imageNamed:@"icon.png"];
  
  CouponListModel* couponModel = self.model;
  
  for (CouponObject* couponObject in couponModel.list) {
    //NSString* url = [NSString stringWithFormat:@"cc://products/view/%d", couponObject.productId];
    CouponTableItem* item = [CouponTableItem itemWithTitle:couponObject.restaurantName 
                                                   caption:couponObject.cuisineType 
                                                      text:couponObject.address 
                                                 timestamp:[NSDate date] 
                                                  imageURL:couponObject.imageUrl 
                                                       URL:@"http://google.com"];
    item.rightLabel = @"distance";
    /*
                                itemWithText:couponObject.cuisineType 
                                                         subtitle:couponObject.address 
                                                         imageURL:couponObject.imageUrl 
                                                     defaultImage:placeHolder 
                                                              URL:@"http://google.com" 
                                                     accessoryURL:nil];
     */
    [items addObject:item];
  }
  
  if (couponModel.totalResult > couponModel.resultsPerPage * couponModel.pageNum) {
    TTDPRINT(@"totalResult: %d > resultsPerPage: %d * pageNum: %d", couponModel.totalResult, couponModel.resultsPerPage, couponModel.pageNum);
    [items addObject:[TTTableMoreButton itemWithText:@"Load More..." subtitle:nil]];
  }
  
  self.items = items;
  TT_RELEASE_SAFELY(items);
}

#pragma mark -
#pragma mark UITableViewDataSource
- (Class)tableView:(UITableView *)tableView cellClassForObject:(id)object {
  if ([object isKindOfClass:[CouponTableItem class]]) {
    return [CouponTableItemCell class];
  } else {
    return [super tableView:tableView cellClassForObject:object];
  }

}

@end
