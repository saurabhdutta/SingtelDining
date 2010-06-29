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
  // RatingView * ratingView;
   NSString* distance;
   UILabel * distancelbl;
    

}
//@property (nonatomic,retain) RatingView * ratingView;
@property (nonatomic,retain) UILabel * distancelbl;
@end

