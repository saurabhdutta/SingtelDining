//
//  HTableDataSource.m
//  HTable
//
//  Created by Alex Yao Cheng on 6/28/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "HTableDataSource.h"
#import "HTableItem.h"
#import "HTableItemCell.h"


@implementation HTableDataSource

- (id)init {
  if (self = [super init]) {
    
    [_items removeAllObjects];
    
    NSMutableArray *selectedCardList = [NSMutableArray array];
    NSDictionary *cardList = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"CreditCard" ofType:@"plist"]];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *selectedCards = [defaults objectForKey:K_UD_SELECT_CARDS];
    BOOL selectedAll = [defaults boolForKey:K_UD_SELECT_ALL];
    
    if (selectedAll) {
      for (NSString* bankName in [cardList keyEnumerator]) {
        for (NSDictionary* card in [cardList objectForKey:bankName]) {
          NSMutableDictionary *theCard = [NSMutableDictionary dictionaryWithDictionary:card];
          [theCard setObject:bankName forKey:@"bank"];
          [selectedCardList addObject:theCard];
        }
      }
    } else {
      NSArray *bankKeys = [[selectedCards allKeys] sortedArrayUsingSelector:@selector(compare:)];
      for (NSString *bankName in bankKeys) {
        NSArray *selected = [selectedCards objectForKey:bankName];
        for (id index in selected) {
          NSArray *cardInBank = [cardList objectForKey:bankName];
          NSDictionary *card = [cardInBank objectAtIndex:[(NSNumber*)index intValue]];
          NSMutableDictionary *theCard = [NSMutableDictionary dictionaryWithDictionary:card];
          [theCard setObject:bankName forKey:@"bank"];
          [selectedCardList addObject:theCard];
        }
      }
    }
    
    for (NSDictionary *card in selectedCardList) {
      NSString *imageUrl = [NSString stringWithFormat:@"bundle://%@", [card objectForKey:@"Icon"]];
      NSString *altImageUrl = [NSString stringWithFormat:@"bundle://%@_label.png", [card objectForKey:@"Title"]];
      HTableItem *item = [HTableItem itemWithText:[card objectForKey:@"Title"] imageURL:imageUrl URL:@"#hello"];
      item.tickURL = @"bundle://tick-mark.png";
      item.selectedImageURL = altImageUrl;
      //item.unSelectedImageURL = imageUrl;
      item.userInfo = [card objectForKey:@"bank"];
      item.selected = YES;
      [self.items addObject:item];
    }
    
    HTableItem *item = [HTableItem itemWithText:@"All Card" imageURL:@"bundle://SelectAllCards.png" URL:@"#hello"];
    item.tickURL = @"bundle://tick-mark.png";
    item.selectedImageURL = @"bundle://SelectAllCards.png";
    //item.unSelectedImageURL = @"bundle://SelectAllCards.png";
    item.userInfo = @"All";
    item.selected = YES;
    [self.items addObject:item];
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