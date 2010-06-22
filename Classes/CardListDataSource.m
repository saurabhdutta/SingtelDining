//
//  CardListDataSource.m
//  SingtelDining
//
//  Created by Alex Yao on 6/22/10.
//  Copyright 2010 CellCity. All rights reserved.
//

#import "CardListDataSource.h"


@implementation CardListDataSource

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)tableViewDidLoadModel:(UITableView*)tableView {
  NSMutableArray* items = [[NSMutableArray alloc] initWithObjects:
                           [TTTableRightImageItem itemWithText:@"UOB Visa Infinite Card" imageURL:kImageUnchecked], 
                           [TTTableRightImageItem itemWithText:@"UOB Visa Cold Card" imageURL:kImageUnchecked],
                           [TTTableRightImageItem itemWithText:@"UOB Lady's Card" imageURL:kImageUnchecked],
                           [TTTableRightImageItem itemWithText:@"UOB Master Card Classic Card" imageURL:kImageUnchecked],
                           [TTTableRightImageItem itemWithText:@"UOB Visa Classic Card" imageURL:kImageUnchecked],
                           [TTTableRightImageItem itemWithText:@"UOB Visa Infinite Card" imageURL:kImageUnchecked],
                           [TTTableRightImageItem itemWithText:@"UOB Visa Cold Card" imageURL:kImageUnchecked],
                           [TTTableRightImageItem itemWithText:@"UOB Lady's Card" imageURL:kImageUnchecked],
                           [TTTableRightImageItem itemWithText:@"UOB Master Card Classic Card" imageURL:kImageUnchecked],
                           [TTTableRightImageItem itemWithText:@"UOB Visa Infinite Card" imageURL:kImageUnchecked],
                           nil];
  
  self.items = items;
  TT_RELEASE_SAFELY(items);
}

//
- (void)tableView:(UITableView*)tableView cell:(UITableViewCell*)cell
willAppearAtIndexPath:(NSIndexPath*)indexPath {
  id object = [self tableView:tableView objectForRowAtIndexPath:indexPath];
  if ([object isKindOfClass:[TTTableImageItem class]]) {
    TTTableImageItem *item = (TTTableImageItem *)object;
    if ([item imageURL] == kImageUnchecked){
      [cell setBackgroundColor:[UIColor whiteColor]];
      [cell.textLabel setTextColor:[UIColor blackColor]];
    } else {
      if (indexPath.row == 0) {
        // first row
        [cell setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"table-row-1.png"]]];
      } else if ([tableView numberOfRowsInSection:indexPath.section] == (indexPath.row+1)) {
        // last row
        [cell setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"table-row-3.png"]]];
      } else {
        // other
        [cell setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"table-row-2.png"]]];
      }
      
      [cell.textLabel setTextColor:[UIColor whiteColor]];
      [cell.textLabel setBackgroundColor:[UIColor clearColor]];
      [cell.detailTextLabel setBackgroundColor:[UIColor clearColor]];
    }
  }
}

@end
