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


@interface DetailsViewController : TTStateAwareViewController <RatingViewDelegate, FBSessionDelegate, FBDialogDelegate> {
  float rating;
  RatingView *ratingView;
  TTStyledTextLabel *restaurantInfo;
  FBSession* _FBSession;
}

- (void)updateInfoView:(NSString *)infoText;

@end
