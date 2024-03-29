//
//  DetailsViewController.h
//  SingtelDining
//
//  Created by Alex Yao on 6/18/10.
//  Copyright 2010 CellCity. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RatingView.h"
#import "TTStateAwareViewController.h"
#import "HTableView.h"
#import <MessageUI/MFMailComposeViewController.h>

@class DetailsObject;
@class MBProgressHUD;

@interface DetailsViewController : TTTableViewController <RatingViewDelegate, MFMailComposeViewControllerDelegate> {
	float rating;
	RatingView *ratingView;
	UILabel *reviewCount;
	TTStyledTextLabel *restaurantInfo;
	TTImageView *photoView;
	UIScrollView *restaurantBox;
	BOOL isFavorite , isAmexBank;
	DetailsObject *details;
	HTableView* cardTable;
	NSString* tnc;
	int cardIndex;
	
	MBProgressHUD* hud;
}

- (void)updateInfoView:(NSString *)infoText;
- (id)initWithRestaurantId:(int)RestaurantId;
- (IBAction)shareFacebook:(id)sender;
@end
