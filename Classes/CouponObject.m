//
//  CouponObject.m
//  SingtelDining
//
//  Created by Alex Yao Cheng on 11/2/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "CouponObject.h"


@implementation CouponObject

@synthesize imageUrl            = _imageUrl;
@synthesize restaurantName      = _restaurantName;
@synthesize cuisineType         = _cuisineType;
@synthesize address             = _address;

@synthesize offerShort          = _offerShort;
@synthesize offerLong           = _offerLong;
@synthesize tnc                 = _tnc;
@synthesize startDate           = _startDate;
@synthesize endDate             = _endDate;
@synthesize officePhone         = _officePhone;

@synthesize couponID            = _couponID;
@synthesize reviews             = _reviews;

@synthesize offerID             = _offerID;
@synthesize redemptionOutlet    = _redemptionOutlet;
@synthesize redemptionUser      = _redemptionUser;
@synthesize redemptionCount     = _redemptionCount;

@synthesize rating              = _rating;
@synthesize latitude            = _latitude;
@synthesize longitude           = _longitude;


- (void)dealloc {
  if (_imageUrl != nil) 
    TT_RELEASE_SAFELY(_imageUrl);
  
  if (_restaurantName != nil) 
    TT_RELEASE_SAFELY(_restaurantName);
  
  if (_cuisineType != nil) 
    TT_RELEASE_SAFELY(_cuisineType);
  
  if (_address != nil) 
    TT_RELEASE_SAFELY(_address);
  
  if (_offerShort != nil) 
    TT_RELEASE_SAFELY(_offerShort);
  
  if (_offerLong != nil) 
    TT_RELEASE_SAFELY(_offerLong);
  
  if (_tnc != nil) 
    TT_RELEASE_SAFELY(_tnc);
  
  if (_startDate != nil) 
    TT_RELEASE_SAFELY(_startDate);
  
  if (_endDate != nil) 
    TT_RELEASE_SAFELY(_endDate);
  
  if (_officePhone != nil) 
    TT_RELEASE_SAFELY(_officePhone);
  
  [super dealloc];
}

@end
