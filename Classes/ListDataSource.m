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
#import "ListObject.h"
#import "StringTable.h"



@implementation ListDataSource

- (void)dealloc {
  TT_RELEASE_SAFELY(_model);
  [super dealloc];
}

- (id)initWithType:(NSString *)type {
  if (self = [super init]){
    _dataModel = [[ListDataModel alloc] initWithSearchQuery:@"http://uob.dc2go.net/singtel/get_restaurant_list.php"];
  }
  return self;
}

- (id)initWithType:(NSString *)type andSortBy:(NSString *)sortBy withKeys:(NSArray*) keys andValues:(NSArray*) values {
  if (self = [super init]){
     
     if([sortBy isEqualToString:@"CurrentLocation"])
        
     
     _dataModel = [[ListDataModel alloc] initWithSearchQuery:URL_SEARCH_NEARBY withSearchParameterValues: values andKeys:keys];
     
     else
        
     _dataModel = [[ListDataModel alloc] initWithSearchQuery:URL_SEARCH_BY_LOCATION withSearchParameterValues: values andKeys:keys];
     
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
- (id<TTModel>)model {
  return _dataModel;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)tableViewDidLoadModel:(UITableView*)tableView {
   
   NSLog(@"Loading ListDataSource in table\n");
   
  NSMutableArray* items = [[NSMutableArray alloc] init];
  
  UIImage *defaultImage = [UIImage imageNamed:@"sample-list-image.png"];
  
  for (ListObject *post in _dataModel.posts) {
    /*[items addObject:[CustomTableItem itemWithText:post.title 
                                          subtitle:post.address 
                                          imageURL:post.image 
                                      defaultImage:defaultImage 
                                               URL:kAppDetailsURLPath 
                                         andRating:post.rating]];*/
     [items addObject:[TTTableSubtitleItem itemWithText:post.title 
                                           subtitle:post.address 
                                           imageURL:post.image 
                                       defaultImage:defaultImage 
                                                    URL:kAppDetailsURLPath
                                           accessoryURL:@""]];
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
