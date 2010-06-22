//
//  ListDataSource.m
//  SingtelDining
//
//  Created by Alex Yao on 6/19/10.
//  Copyright 2010 CellCity. All rights reserved.
//

#import "ListDataSource.h"
#import "CustomTableItem.h"
#import "CustomTableCell.h"


@implementation ListDataSource

- (id)initWithType:(NSString *)type {
  if (self = [super init]){
  }
  return self;
}
- (id)initWithType:(NSString *)type andSortBy:(NSString *)sortBy {
  if (self = [super init]){
  }
  return self;
}
- (id)initWithType:(NSString *)type andCategory:(NSString *)category {
  if (self = [super init]){
  }
  return self;
}

- (id)initWithType:(NSString *)type andCategory:(NSString *)category andBank:(NSString *)bank {
  if (self = [super init]){
  }
  return self;
}

- (id)initWithSearchQuery:(NSString*)searchQuery {
  if (self = [super init]){
  }
  return self;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)tableViewDidLoadModel:(UITableView*)tableView {
  NSMutableArray* items = [[NSMutableArray alloc] init];
  
  for (int i=0; i<10; i++) {
    [items addObject:/*[TTTableSubtitleItem itemWithText:@"Aans Korea Resturants" 
                                              subtitle:@"Orchard Central, #12-08" 
                                              imageURL:@"bundle://sample-list-image.png" 
                                                   URL:kAppDetailsURLPath]*/
     [CustomTableItem itemWithText:@"Aans Korea Resturants" subtitle:@"Orchard Central, #12-08"
                          imageURL:@"bundle://sample-list-image.png" URL:kAppDetailsURLPath andRating:3]];
  }
  
  self.items = items;
  TT_RELEASE_SAFELY(items);
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (NSString*)titleForLoading:(BOOL)reloading {
  if (reloading) {
    return NSLocalizedString(@"Updating Data...", @"Data updating text");
  } else {
    return NSLocalizedString(@"Loading Data...", @"Data loading text");
  }
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (NSString*)titleForEmpty {
  return NSLocalizedString(@"No data found.", @"Data no results");
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (NSString*)subtitleForError:(NSError*)error {
  return NSLocalizedString(@"Sorry, there was an error loading the Data", @"");
}

- (Class)tableView:(UITableView*)tableView cellClassForObject:(id) object { 
	
	if ([object isKindOfClass:[CustomTableItem class]]) { 
		return [CustomTableCell class]; 		
	} else { 
		return [super tableView:tableView cellClassForObject:object]; 
	}
}

@end
