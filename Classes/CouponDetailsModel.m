//
//  CouponDetailsModel.m
//  SingtelDining
//
//  Created by Alex Yao Cheng on 11/3/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "CouponDetailsModel.h"
#import "CouponObject.h"
#import <extThree20JSON/extThree20JSON.h>
#import <Three20Core/NSStringAdditions.h>


@implementation CouponDetailsModel

@synthesize coupon = _coupon;

- (id)initWithCoupon:(CouponObject*)theCoupon {
  if (self = [super init]) {
    self.coupon = theCoupon;
  }
  return self;
}

- (void)load:(TTURLRequestCachePolicy)cachePolicy more:(BOOL)more {
  
  NSString* offerID = [NSString stringWithFormat:@"%d", self.coupon.offerID];
  
  NSMutableDictionary* _parameters = [[NSMutableDictionary alloc] init];
  [_parameters setObject:offerID forKey:@"offerID"];
	
  NSString* deviceID = [UIDevice currentDevice].uniqueIdentifier;
  [_parameters setObject:deviceID forKey:@"udid"];
  
  NSString *url = [URL_COUPON_DETAILS stringByAddingQueryDictionary:_parameters];
  TTDPRINT(@"request url: %@", url);
  
  if (!self.isLoading && TTIsStringWithAnyText(url)) {
    
    TTURLRequest* request = [TTURLRequest
                             requestWithURL: url
                             delegate: self];
    
    request.cachePolicy = cachePolicy | TTURLRequestCachePolicyEtag;
    request.cacheExpirationAge = TT_CACHE_EXPIRATION_AGE_NEVER;
    
    TTURLJSONResponse* response = [[TTURLJSONResponse alloc] init];
    request.response = response;
    TT_RELEASE_SAFELY(response);
    
    [request send];
  }
  
  TT_RELEASE_SAFELY(_parameters);
}

- (void)requestDidFinishLoad:(TTURLRequest*)request {
  TTURLJSONResponse* response = request.response;
  
  NSDictionary* root = response.rootObject;
  
  self.coupon.redemptionOutlet  = [[root objectForKey:@"redemptionOutlet"] intValue];
  self.coupon.redemptionUser    = [[root objectForKey:@"redemptionUser"] intValue];
  self.coupon.redemptionCount   = [[root objectForKey:@"redemptionCount"] intValue];
  self.coupon.photoUrl          = [root objectForKey:@"Img"];
  self.coupon.offerShort        = [root objectForKey:@"offerShort"];
  self.coupon.offerLong         = [root objectForKey:@"offerLong"];
  //self.coupon.imageUrl        = [root objectForKey:@"Img"];
  self.coupon.tnc               = [root objectForKey:@"tnc"];
  self.coupon.startDate         = [root objectForKey:@"startDate"];
  self.coupon.endDate           = [root objectForKey:@"endDate"];
  self.coupon.officePhone       = [NSString stringWithFormat:@"%@",[root objectForKey:@"OfficePhone"]];
  self.coupon.affiliate			= [root objectForKey:@"Affiliate"];
  //self.coupon.redemptionCount	= self.coupon.redemptionUser > 0 ? self.coupon.redemptionUser : self.coupon.redemptionCount;
  [super requestDidFinishLoad:request];
}

@end
