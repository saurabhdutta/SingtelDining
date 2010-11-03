//
//  CouponDetailsModel.h
//  SingtelDining
//
//  Created by Alex Yao Cheng on 11/3/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CouponObject;

@interface CouponDetailsModel : TTURLRequestModel {
  CouponObject* _coupon;
}

@property (nonatomic, retain) CouponObject* coupon;

- (id)initWithCoupon:(CouponObject*)theCoupon;

@end
