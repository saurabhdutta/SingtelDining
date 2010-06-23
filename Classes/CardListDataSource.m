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

- (id)initWithBank:(NSString *)bankName {
  if (self = [super init]) {
    _bankName = bankName;
  }
  return self;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)tableViewDidLoadModel:(UITableView*)tableView {
  NSDictionary *cardList = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"CreditCard" ofType:@"plist"]];
  //NSLog(@"card: %@", cardList);
  NSArray *bankCard = [cardList objectForKey:_bankName];
  for (NSDictionary *card in bankCard) {
    [self.items addObject:[TTTableRightImageItem itemWithText:[card objectForKey:@"Title"] imageURL:kImageUnchecked]];
  }
  /*
  NSMutableArray* items = [[NSMutableArray alloc] initWithObjects:
                           [TTTableRightImageItem itemWithText:[NSString stringWithFormat:@"%@ Visa Infinite Card", _bankName] imageURL:kImageUnchecked], 
                           [TTTableRightImageItem itemWithText:[NSString stringWithFormat:@"%@ Visa Cold Card", _bankName] imageURL:kImageUnchecked],
                           [TTTableRightImageItem itemWithText:[NSString stringWithFormat:@"%@ Lady's Card", _bankName] imageURL:kImageUnchecked],
                           [TTTableRightImageItem itemWithText:[NSString stringWithFormat:@"%@ Master Card Classic Card", _bankName] imageURL:kImageUnchecked],
                           [TTTableRightImageItem itemWithText:[NSString stringWithFormat:@"%@ Visa Classic Card", _bankName] imageURL:kImageUnchecked],
                           [TTTableRightImageItem itemWithText:[NSString stringWithFormat:@"%@ Visa Infinite Card", _bankName] imageURL:kImageUnchecked],
                           [TTTableRightImageItem itemWithText:[NSString stringWithFormat:@"%@ Visa Cold Card", _bankName] imageURL:kImageUnchecked],
                           [TTTableRightImageItem itemWithText:[NSString stringWithFormat:@"%@ Lady's Card", _bankName] imageURL:kImageUnchecked],
                           [TTTableRightImageItem itemWithText:[NSString stringWithFormat:@"%@ Master Card Classic Card", _bankName] imageURL:kImageUnchecked],
                           [TTTableRightImageItem itemWithText:[NSString stringWithFormat:@"%@ Visa Infinite Card", _bankName] imageURL:kImageUnchecked],
                           nil];
  for (int i=0; i<items.count; i++) {
    if (i%3==0) {
      [[items objectAtIndex:i] setImageURL:kImageChecked];
    }
  }
  self.items = items;
  TT_RELEASE_SAFELY(items);
  */
}

//
- (void)tableView:(UITableView*)tableView cell:(UITableViewCell*)cell
willAppearAtIndexPath:(NSIndexPath*)indexPath {
  id object = [self tableView:tableView objectForRowAtIndexPath:indexPath];
  if ([object isKindOfClass:[TTTableImageItem class]]) {
    TTTableImageItem *item = (TTTableImageItem *)object;
    if ([item imageURL] == kImageUnchecked){
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
      [cell.textLabel setTextColor:[UIColor blackColor]];
    } else {
      if (indexPath.row == 0) {
        // first row
        [cell setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"table-row-1s.png"]]];
      } else if ([tableView numberOfRowsInSection:indexPath.section] == (indexPath.row+1)) {
        // last row
        [cell setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"table-row-3s.png"]]];
      } else {
        // other
        [cell setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"table-row-2s.png"]]];
      }
      
      [cell.textLabel setTextColor:[UIColor whiteColor]];
    }
    [cell.textLabel setBackgroundColor:[UIColor clearColor]];
    [cell.detailTextLabel setBackgroundColor:[UIColor clearColor]];
  }
}

@end
