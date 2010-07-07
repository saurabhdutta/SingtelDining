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

- (id)initWithOffers:(NSArray *)offers {
  if (self = [super init]) {
    
    
    NSMutableArray *selectedCardList = [NSMutableArray array];
    NSMutableArray *cardNameArray = [NSMutableArray array];
    NSMutableArray *offerCardList = [NSMutableArray array];
    NSDictionary *cardList = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"CreditCard" ofType:@"plist"]];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *selectedCards = [defaults objectForKey:K_UD_SELECT_CARDS];
    
    
    for (NSDictionary *offer in offers) {
      NSString *bankName = [offer objectForKey:@"bank"];
      if (TTIsStringWithAnyText(bankName)) { // make sure bank name is not null
        
        NSArray* cardInBank = [cardList objectForKey:bankName]; // cards in card.plist with bank name
        NSArray* cardInDefult = [selectedCards objectForKey:bankName]; // cards in user default (user selected)
        
        if ([cardInDefult count] > 0) {
          NSUInteger i, count = [cardInDefult count];
          for (i = 0; i < count; i++) {
            NSNumber* index = [cardInDefult objectAtIndex:i];
            NSDictionary * card = [cardInBank objectAtIndex:[index intValue]];
            NSMutableDictionary *theCard = [NSMutableDictionary dictionaryWithDictionary:card];
            [theCard setObject:bankName forKey:@"bank"];
            [selectedCardList addObject:theCard]; // add to array
            [cardNameArray addObject:[theCard objectForKey:@"Title"]];
          }
        }
        //NSLog(@"selected cardNameArray: %@", cardNameArray);
        
        for (NSDictionary *card in cardInBank) {
          NSMutableDictionary *theCard = [NSMutableDictionary dictionaryWithDictionary:card];
          [theCard setObject:bankName forKey:@"bank"];
          if (![cardNameArray containsObject:[theCard objectForKey:@"Title"]]) {
            // add card to offer card list to make sure it is not duplicate
            [offerCardList addObject:theCard];
            [cardNameArray addObject:[theCard objectForKey:@"Title"]];
          }
        }
      }
    }
    
    [selectedCardList addObjectsFromArray:offerCardList];
    
    for (NSDictionary *card in selectedCardList) {
      NSString *imageUrl = [NSString stringWithFormat:@"bundle://%@", [card objectForKey:@"Icon"]];
      HTableItem *item = [HTableItem itemWithText:[card objectForKey:@"Title"] imageURL:imageUrl URL:@"#hello"];
      item.tickURL = @"bundle://tick-mark.png";
      item.selectedImageURL = imageUrl;
      item.userInfo = [card objectForKey:@"bank"];
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
