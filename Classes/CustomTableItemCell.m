//
//  CustomTableItemCell.m
//  SingtelDining
//
//  Created by System Administrator on 21/06/10.
//  Copyright 2010 Cellcity Pte Ltd. All rights reserved.
//

#import "CustomTableItemCell.h"



@implementation CustomTableItemCell
@synthesize ratingView,rating;

+ (id)itemWithText:(NSString*)text subtitle:(NSString*)subtitle imageURL:(NSString*)imageURL
               URL:(NSString*)URL andRating:(float ) rating
{
   CustomTableItemCell *item = [[super itemWithText:text subtitle:subtitle imageURL:imageURL URL:URL] autorelease];
   item.rating = rating;
   
   item.ratingView = [[[RatingView alloc] init] autorelease];
   [item.ratingView setImagesDeselected:@"s0.png" partlySelected:@"s1.png" fullSelected:@"s2.png" andDelegate:nil];
   [item.ratingView displayRating:rating];
   [item.ratingView setFrame:CGRectMake(250, 15, 70, 20)];
   [item addSubview:ratingView];
	
	return item;
}

- (void) dealloc
{
   [ratingView release];
   [super dealloc];
}





@end
