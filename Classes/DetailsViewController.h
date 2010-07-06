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
#import "HTableView.h"

@class DetailsObject;

@interface DetailsViewController : TTTableViewController <RatingViewDelegate, FBSessionDelegate, FBDialogDelegate> {
  float rating;
  RatingView *ratingView;
  UILabel *reviewCount;
  TTStyledTextLabel *restaurantInfo;
  FBSession* _FBSession;
  BOOL isFavorite;
  DetailsObject *details;
  HTableView* cardTable;
  NSString* tnc;
}

- (void)updateInfoView:(NSString *)infoText;
- (id)initWithRestaurantId:(int)RestaurantId;
@end
