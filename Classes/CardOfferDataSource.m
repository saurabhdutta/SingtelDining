//
//  CardOfferDataSource.m
//  SingtelDining
//
//  Created by Alex Yao Cheng on 6/30/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "CardOfferDataSource.h"
#import "HTableItem.h"
#import "HTableItemCell.h"


@implementation CardOfferDataSource

- (id)init {
  if (self = [super init]) {
    
    NSMutableArray *selectedCardList = [NSMutableArray array];
    NSDictionary *cardList = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"CreditCard" ofType:@"plist"]];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *selectedCards = [defaults objectForKey:K_UD_SELECT_CARDS];
    NSArray *bankKeys = [[selectedCards allKeys] sortedArrayUsingSelector:@selector(compare:)];
    for (NSString *bankName in bankKeys) {
      NSArray *selected = [selectedCards objectForKey:bankName];
      for (id index in selected) {
        NSArray *cardInBank = [cardList objectForKey:bankName];
        NSDictionary *card = [cardInBank objectAtIndex:[(NSNumber*)index intValue]];
        [selectedCardList addObject:card];
      }
    }
    
    for (NSDictionary *card in selectedCardList) {
      NSString *imageUrl = [NSString stringWithFormat:@"bundle://%@", [card objectForKey:@"Icon"]];
      HTableItem *item = [HTableItem itemWithText:[card objectForKey:@"Title"] imageURL:imageUrl URL:@"#hello"];
      item.tickURL = @"bundle://tick-mark.png";
      [self.items addObject:item];
    }
  }
  
  return self;
}

- (Class)tableView:(UITableView*)tableView cellClassForObject:(id) object { 
	
	if ([object isKindOfClass:[HTableItem class]]) { 
		return [HTableItemCell class]; 		
	} else { 
		return [super tableView:tableView cellClassForObject:object]; 
	}
}

@end
