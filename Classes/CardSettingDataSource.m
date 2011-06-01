//
//  CardSettingDataSource.m
//  SingtelDining
//
//  Created by Alex Yao Cheng on 7/5/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//


#import "CardSettingDataSource.h"


@implementation CardSettingDataSource

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)tableViewDidLoadModel:(UITableView*)tableView {
  
  NSMutableArray* groups = [[NSMutableArray alloc] init];
  NSMutableArray* rows = [[NSMutableArray alloc] init];
  
  _cardPlist = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"CreditCard" ofType:@"plist"]];
  [_cardPlist retain];
  
  NSArray* bankArray = [[_cardPlist allKeys] sortedArrayUsingSelector:@selector(compare:)];
  
  for (NSString* bankName in bankArray) {
    
    NSMutableArray* tmpItem = [[NSMutableArray alloc] init];
    
    NSArray* bankArray = [_cardPlist objectForKey:bankName];
    
    for (NSDictionary* card in bankArray) {
      [tmpItem addObject:[TTTableRightImageItem itemWithText:[card objectForKey:@"Title"] imageURL:kImageUnchecked]];
      
    }
    
    [groups addObject:bankName];
    [rows addObject:tmpItem];
    TT_RELEASE_SAFELY(tmpItem);
  }
  
  self.sections = groups;
  self.items = rows;
  
  TT_RELEASE_SAFELY(groups);
  TT_RELEASE_SAFELY(rows);
}

//
- (void)tableView:(UITableView*)tableView cell:(UITableViewCell*)cell
willAppearAtIndexPath:(NSIndexPath*)indexPath {
  id object = [self tableView:tableView objectForRowAtIndexPath:indexPath];
  if ([object isKindOfClass:[TTTableImageItem class]]) {
    TTTableImageItem *item = (TTTableImageItem *)object;
    if (item.imageURL == kImageUnchecked){
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
    [cell.textLabel setAdjustsFontSizeToFitWidth:YES];
    [cell.textLabel setNumberOfLines:1];
    //[cell.textLabel setFont:[UIFont systemFontOfSize:12]];
    [cell.textLabel setMinimumFontSize:12];
    [cell.detailTextLabel setBackgroundColor:[UIColor clearColor]];
  }
}


- (NSArray*)getCardArrayByBankName:(NSString*)bankName {
	NSArray* cardArray = [_cardPlist objectForKey:bankName];
	if (cardArray!=nil) {
		return cardArray;
	}
	return [NSArray array];
}
- (NSString*)getCardNameByBankName:(NSString*)bankName andCardIndex:(NSInteger)cardIndex {
	NSArray* cardArray = [_cardPlist objectForKey:bankName];
	if (cardArray && [cardArray objectAtIndex:cardIndex]) {
		NSDictionary* card = [cardArray objectAtIndex:cardIndex];
		return [card objectForKey:@"Title"];
	}
	return @"";
}
- (NSString*)getCardIdByBankName:(NSString*)bankName andCardIndex:(NSInteger)cardIndex {
	NSArray* cardArray = [_cardPlist objectForKey:bankName];
	if (cardArray && [cardArray objectAtIndex:cardIndex]) {
		NSDictionary* card = [cardArray objectAtIndex:cardIndex];
		return [card objectForKey:@"CardID"];
	}
	return @"";
}


- (void)dealloc {
	[_cardPlist release];
	[super dealloc];
}

@end
