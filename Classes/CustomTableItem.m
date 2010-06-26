//
//  CellItem.m
//  SingtelDining
//
//  Created by Charisse Marie Napeñas on 21/06/10.
//  Copyright 2010 Cellcity Pte Ltd. All rights reserved.
//

#import "CustomTableItem.h"


@implementation CustomTableItem
@synthesize distance;

+ (id)itemWithText:(NSString*)text subtitle:(NSString*)subtitle imageURL:(NSString*)imageURL defaultImage:(UIImage*)defaultImage
               URL:(NSString*)URL andDistance:(NSString* ) distance
{
   CustomTableItem *item = [super itemWithText:text subtitle:subtitle imageURL:imageURL URL:URL];
  item.defaultImage = defaultImage;
   item.distance = distance;
   
   
	
	return item;
}

- (void) dealloc
{
   [distance release];
   [super dealloc];
}


@end
