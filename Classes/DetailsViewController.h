//
//  DetailsViewController.h
//  SingtelDining
//
//  Created by Alex Yao on 6/18/10.
//  Copyright 2010 CellCity. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RatingView.h"
#import "FBConnect/FBConnect.h"
#import "TTStateAwareViewController.h"

@class DetailsObject;

@interface DetailsViewController : TTStateAwareViewController <RatingViewDelegate, FBSessionDelegate, FBDialogDelegate> {
  float rating;
  RatingView *ratingView;
  TTStyledTextLabel *restaurantInfo;
  FBSession* _FBSession;
  BOOL isFavorite;
   DetailsObject *details;
}

- (void)updateInfoView:(NSString *)infoText;
- (id)initWithRestaurantId:(int)RestaurantId;
@end
