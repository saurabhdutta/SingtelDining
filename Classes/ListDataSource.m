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

@implementation TTTableMoreButtonCell(SDCategory)
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString*)identifier {
  if (self = [super initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier]) {
    self.textLabel.font = [UIFont boldSystemFontOfSize:20];
    self.textLabel.textColor = [UIColor grayColor];
    self.textLabel.textAlignment = UITextAlignmentCenter;
  }
  
  return self;
}

- (void)layoutSubviews {
  [super layoutSubviews];
  CGRect f = _activityIndicatorView.frame;
  CGPoint o;
  o.x = 40 - (_activityIndicatorView.frame.size.width + kTableCellSmallMargin);
  o.y = floor(self.contentView.frame.size.height/2 - _activityIndicatorView.frame.size.height/2);
  _activityIndicatorView.frame = CGRectMake(o.x, o.y, f.size.width, f.size.height);
  
  self.textLabel.frame = CGRectMake(40, 0,
                                    self.contentView.frame.size.width - (40 + 40 + kTableCellSmallMargin),
                                    self.textLabel.frame.size.height);
  self.detailTextLabel.frame = CGRectMake(40, self.detailTextLabel.frame.origin.y,
                                          self.contentView.frame.size.width - (40 + kTableCellSmallMargin),
                                          self.detailTextLabel.frame.size.height);
}

@end


@implementation ListDataSource

- (void)dealloc {
  TT_RELEASE_SAFELY(_model);
  [super dealloc];
}

- (id)initWithType:(NSString *)type {
  if (self = [super init]){
     isNearbySearch = FALSE;
    _dataModel = [[ListDataModel alloc] initWithSearchQuery:[URL_ALL_REST stringByAppendingFormat:@"?resultsPerPage=1000"]];
  }
  return self;
}

- (id)initWithType:(NSString *)type andSortBy:(NSString *)sortBy withKeys:(NSArray*) keys andValues:(NSArray*) values {
  if (self = [super init]){
     
     isNearbySearch = FALSE;
     if([sortBy isEqualToString:@"CurrentLocation"])
     {
        isNearbySearch = TRUE;
     
        _dataModel = [[ListDataModel alloc] initWithSearchQuery:URL_SEARCH_NEARBY withSearchParameterValues: values andKeys:keys];
     }
     
     else if([sortBy isEqualToString:@"SelectedLocation"])
        
     _dataModel = [[ListDataModel alloc] initWithSearchQuery:URL_SEARCH_BY_LOCATION withSearchParameterValues: values andKeys:keys];
     
     else if([sortBy isEqualToString:@"Cuisine"])
        
        _dataModel = [[ListDataModel alloc] initWithSearchQuery:URL_GET_REST_BY_CUISINE withSearchParameterValues: values andKeys:keys];
     else if([sortBy isEqualToString:@"Name"])
        _dataModel = [[ListDataModel alloc] initWithSearchQuery:URL_ALL_REST withSearchParameterValues: values andKeys:keys];
     

     
     
     
  }
  return self;
}
- (id)initWithType:(NSString *)type andCategory:(NSString *)category {
  if (self = [super init]){
     isNearbySearch = FALSE;
  }
  return self;
}

- (id)initWithType:(NSString *)type andCategory:(NSString *)category andBank:(NSString *)bank {
  if (self = [super init]){
     isNearbySearch = FALSE;
  }
  return self;
}

- (id)initWithSearchKeyword:(NSString*)keyword {
  if (self = [super init]){
     isNearbySearch = FALSE;
    _dataModel = [[ListDataModel alloc] initWithSearchKeyword:keyword];
  }
  return self;
}

- (id)initWithQuery:(NSDictionary*)query {
  if (self = [super init]) {
    _dataModel = [[ListDataModel alloc] initWithQuery:query];
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
   NSMutableArray* data = [[NSMutableArray alloc] init];
  
  UIImage *defaultImage = [UIImage imageNamed:@"icon.png"];
  
  for (ListObject *post in _dataModel.posts) {
    
    NSString *url = [NSString stringWithFormat:@"tt://details/%i", [post.uid intValue]];
    AppDelegate* ad = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    NSString * distance = @"";
    if(post.distance > 0.0 && ad.isLocationServiceAvailiable == YES)
      distance = [NSString stringWithFormat:@"%0.1f km",post.distance];
    //NSLog(@"item link to: %@", url);
    
    /*[items addObject:[TTTableSubtitleItem itemWithText:post.title 
                                              subtitle:post.address 
                                              imageURL:post.image 
                                          defaultImage:defaultImage 
                                                   URL:url 
                                          accessoryURL:nil]];*/
     
     [items addObject:[CustomTableItem itemWithText:post.title 
                                           subtitle:post.address 
                                           imageURL:post.image 
                                       defaultImage:defaultImage 
                                                URL:url 
                                        andDistance:distance]];
     
     [data addObject:post];
     
  }
  
   
   //if ( [dataDelegate respondsToSelector:@selector(setARData:)] && isNearbySearch) 
//    {
//       [dataDelegate setARData:data];
//    }
   
  self.items = items;
  TT_RELEASE_SAFELY(items);
  
  if (_dataModel.page * 20 < _dataModel.totalResults) {
    [self.items addObject:[TTTableMoreButton itemWithText:@"Load More..." subtitle:nil]];
  }
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
- (NSString*)titleForError:(NSError*)error { 
  return @"Sorry"; 
} 
- (NSString*)subtitleForError:(NSError*)error {
  return NSLocalizedString(@"There was an problem loading the information.\nPlease check your internet connection.", @"");
}

- (Class)tableView:(UITableView*)tableView cellClassForObject:(id) object { 
	
	if ([object isKindOfClass:[CustomTableItem class]]) { 
		return [CustomTableCell class]; 		
	} else { 
		return [super tableView:tableView cellClassForObject:object]; 
	}
}

#pragma mark -
#pragma mark Function Delegates

- (void) setDelegate:(id) val
 {
 dataDelegate = val;
 }
 
 - (id) delegate
 {
 return dataDelegate;
 }

@end
