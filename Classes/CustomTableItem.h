//
//  CellItem.h
//  SingtelDining
//
//  Created by System Administrator on 21/06/10.
//  Copyright 2010 Cellcity Pte Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RatingView.h"

@interface CustomTableItem : TTTableSubtitleItem {
   RatingView * ratingView;
   float rating;
}
@property (nonatomic,retain) RatingView * ratingView;
@property (readwrite) float rating;
+ (id)itemWithText:(NSString*)text subtitle:(NSString*)subtitle imageURL:(NSString*)imageURL
               URL:(NSString*)URL andRating:(float ) rating;
@end
