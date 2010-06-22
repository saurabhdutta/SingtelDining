//
//  CellItem.m
//  SingtelDining
//
//  Created by Charisse Marie Napeñas on 21/06/10.
//  Copyright 2010 Cellcity Pte Ltd. All rights reserved.
//

#import "CustomTableItem.h"


@implementation CustomTableItem
@synthesize rating;

+ (id)itemWithText:(NSString*)text subtitle:(NSString*)subtitle imageURL:(NSString*)imageURL
               URL:(NSString*)URL andRating:(float ) rating
{
   CustomTableItem *item = [super itemWithText:text subtitle:subtitle imageURL:imageURL URL:URL];
   item.rating = rating;
   
   
	
	return item;
}


@end
