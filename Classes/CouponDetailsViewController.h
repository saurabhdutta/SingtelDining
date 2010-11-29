//
//  CouponDetailsViewController.h
//  SingtelDining
//
//  Created by Alex Yao Cheng on 11/3/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TTStateAwareViewController.h"

@class CouponObject;
@class SDBoxView;

@interface CouponDetailsViewController : TTStateAwareViewController <UIAlertViewDelegate> {
  SDBoxView *boxView;
}

- (id)initWithCoupon:(CouponObject*)theCoupon;

- (IBAction)redeemButtonClicked:(id)sender;

- (void)redeemCouponWithDeviceID:(NSString*)deviceID andCouponID:(NSInteger)couponID;
- (void)showRedeemResultWithSerialNumber:(NSString*)SN andDateTime:(NSString*)dateTime;

@end
