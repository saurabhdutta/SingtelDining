//
//  PickerDataSource.m
//  SingtelDining
//
//  Created by System Administrator on 22/06/10.
//  Copyright 2010 Cellcity Pte Ltd. All rights reserved.
//

#import "PickerDataSource.h"


@implementation PickerDataSource
- (id)init {
   if (self = [super init]) {
      
   }
   return self;
}

- (void)dealloc {
   [super dealloc];
}

#pragma mark -
#pragma mark UITableViewDataSource methods

- (NSArray *)sectionIndexTitlesForTableView:(UITableView*)tableView {
   return [TTTableViewDataSource lettersForSectionsWithSearch:NO summary:NO];
}

#pragma mark -
#pragma mark TTTableViewDataSource methods

- (void)tableViewDidLoadModel:(UITableView*)tableView {
   self.items = [NSMutableArray array];
   self.sections = [NSMutableArray array];
   NSString * name = [NSString stringWithString:@"Alaska"];
   NSMutableDictionary *groups = [NSMutableDictionary dictionary];
   for (int i=0; i < 10; i++) {
      NSString *letter = [NSString stringWithFormat:@"%c", [name characterAtIndex:0]];
      NSMutableArray *section = [groups objectForKey:letter];
      if (!section) {
         section = [NSMutableArray array];
         [groups setObject:section forKey:letter];
      }
      
      TTTableItem *item = [TTTableTextItem itemWithText:name URL:nil];
      [section addObject:item];
   }
   
   NSArray *letters = [groups.allKeys sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
   for (NSString *letter in letters) {
      NSArray *items = [groups objectForKey:letter];
      [_sections addObject:letter];
      [_items addObject:items];
   }
}




@end


