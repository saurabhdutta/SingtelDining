//
//  CouponObject.h
//  SingtelDining
//
//  Created by Alex Yao Cheng on 11/2/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface CouponObject : NSObject {
  NSString* _imageUrl;
  NSString* _restaurantName;
  NSString* _cuisineType;
  NSString* _address;
  
  /** details **/
  NSString* _photoUrl;
  NSString* _offerShort;
  NSString* _offerLong;
  NSString* _tnc;
  NSString* _startDate;
  NSString* _endDate;
  NSString* _officePhone;
  
  NSInteger _couponID;
  NSInteger _reviews;
  
  /** details **/
  NSInteger _offerID;
  NSInteger _redemptionOutlet;
  NSInteger _redemptionUser;
  NSInteger _redemptionCount;
  
  float _rating;
  float _latitude;
  float _longitude;
}

@property (nonatomic, copy) NSString* imageUrl;
@property (nonatomic, copy) NSString* restaurantName;
@property (nonatomic, copy) NSString* cuisineType;
@property (nonatomic, copy) NSString* address;

@property (nonatomic, copy) NSString* photoUrl;
@property (nonatomic, copy) NSString* offerShort;
@property (nonatomic, copy) NSString* offerLong;
@property (nonatomic, copy) NSString* tnc;
@property (nonatomic, copy) NSString* startDate;
@property (nonatomic, copy) NSString* endDate;
@property (nonatomic, copy) NSString* officePhone;

@property (nonatomic) NSInteger couponID;
@property (nonatomic) NSInteger reviews;

@property (nonatomic) NSInteger offerID;
@property (nonatomic) NSInteger redemptionOutlet;
@property (nonatomic) NSInteger redemptionUser;
@property (nonatomic) NSInteger redemptionCount;

@property (nonatomic) float rating;
@property (nonatomic) float latitude;
@property (nonatomic) float longitude;

@end
