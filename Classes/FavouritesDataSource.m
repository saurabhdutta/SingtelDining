//
//  FavouritesDataSource.m
//  SingtelDining
//
//  Created by Alex Yao on 6/21/10.
//  Copyright 2010 CellCity. All rights reserved.
//

#import "FavouritesDataSource.h"
#import "CustomTableItem.h"
#import "CustomTableCell.h"


@implementation FavouritesDataSource

- (id)init {
  if (self = [super init]) {
    
  }
  return self;
}

- (void)tableViewDidLoadModel:(UITableView*)tableView {
  //NSLog(@"tableViewDidLoadModel");
  NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
  
  NSArray *favorite = [defaults objectForKey:@"favorite"];
  //NSLog(@"favorite: %@", favorite);
  
  UIImage *defaultImage = [UIImage imageNamed:@"sample-list-image.png"];
  for (NSDictionary *item in favorite) {
    NSString *url = [NSString stringWithFormat:@"tt://details/%i", [[item objectForKey:@"uid"] intValue]];
    
      CustomTableItem* row = [CustomTableItem itemWithText:[item objectForKey:@"title"] 
                                                   subtitle:[item objectForKey:@"address"] 
                                                   imageURL:[item objectForKey:@"image"] 
                                               defaultImage:defaultImage 
                                                        URL:url 
                                                andDistance:@""];
    row.userInfo = [item objectForKey:@"uid"];
    
    [self.items addObject:row];
    
  }
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath; {
  NSLog(@"datasource commitEditingStyle");
  id object = [self tableView:tableView objectForRowAtIndexPath:indexPath];
  if ([object isKindOfClass:[CustomTableItem class]] ) {
    CustomTableItem *row = (CustomTableItem *)object;
    //NSLog(@"id: %@", row.userInfo);
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSMutableArray *favorite = [NSMutableArray arrayWithArray:[defaults objectForKey:@"favorite"]];
    NSMutableArray *savedIDs = [NSMutableArray arrayWithArray:[defaults objectForKey:@"favoriteSavedIDs"]];
    
    [savedIDs removeObject:row.userInfo];
    //NSLog(@"remove from saved ids");
    for (NSDictionary *item in favorite) {
      if ([[item objectForKey:@"uid"] intValue] == [row.userInfo intValue]) {
        [favorite removeObject:item];
        //NSLog(@"remove from favorite");
        break;
      }
    }
    [self.items removeObject:row];
    //NSLog(@"remove from datasource");
    [tableView reloadData];
    //NSLog(@"reload table");
    
    [defaults setObject:favorite forKey:@"favorite"];
    [defaults setObject:savedIDs forKey:@"favoriteSavedIDs"];
  }
}

- (Class)tableView:(UITableView*)tableView cellClassForObject:(id) object { 
	
	if ([object isKindOfClass:[CustomTableItem class]]) { 
		return [CustomTableCell class]; 		
	} else { 
		return [super tableView:tableView cellClassForObject:object]; 
	}
}

@end
