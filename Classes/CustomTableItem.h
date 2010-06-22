//
//  CellItem.h
//  SingtelDining
//
//  Created by Charisse Marie Napeñas on 21/06/10.
//  Copyright 2010 Cellcity Pte Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface CustomTableItem : TTTableSubtitleItem {
   float rating;
}

@property (readwrite) float rating;
+ (id)itemWithText:(NSString*)text subtitle:(NSString*)subtitle imageURL:(NSString*)imageURL
               URL:(NSString*)URL andRating:(float ) rating;
@end
