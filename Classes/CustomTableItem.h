//
//  CellItem.h
//  SingtelDining
//
//  Created by Charisse Marie Napeñas on 21/06/10.
//  Copyright 2010 Cellcity Pte Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface CustomTableItem : TTTableSubtitleItem {
   NSString* distance;
}

@property (nonatomic,retain) NSString* distance;
+ (id)itemWithText:(NSString*)text subtitle:(NSString*)subtitle imageURL:(NSString*)imageURL defaultImage:(UIImage*)defaultImage
               URL:(NSString*)URL andDistance:(NSString* ) distance;
@end
