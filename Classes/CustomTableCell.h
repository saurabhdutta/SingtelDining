//
//  CustomTableCell.h
//  SingtelDining
//
//  Created by Charisse Marie Napeñas on 21/06/10.
//  Copyright 2010 Cellcity Pte Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RatingView.h"


@interface CustomTableCell : TTTableSubtitleItemCell {
   RatingView * ratingView;
   float rating;

}
@property (nonatomic,retain) RatingView * ratingView;
@end

