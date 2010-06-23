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


@interface DetailsViewController : TTViewController <RatingViewDelegate, FBSessionDelegate> {
  float rating;
  RatingView *ratingView;
  TTStyledTextLabel *restaurantInfo;
}

- (void)updateInfoView:(NSString *)infoText;

@end
