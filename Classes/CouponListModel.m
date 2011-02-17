//
//  CouponListModel.m
//  SingtelDining
//
//  Created by Alex Yao Cheng on 11/2/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "CouponListModel.h"
#import <extThree20JSON/extThree20JSON.h>
#import <Three20Core/NSStringAdditions.h>

#import "CouponObject.h"


@implementation CouponListModel

@synthesize list            = _list;
@synthesize bank            = _bank;
@synthesize cuisineTypeID   = _cuisineTypeID;
@synthesize pageNum         = _pageNum;
@synthesize resultsPerPage  = _resultsPerPage;
@synthesize totalResult     = _totalResult;


- (void)dealloc {
  [_list release];
  
  [super dealloc];
}

- (id)init {
  if (self = [super init]) {
    _list = [[NSArray alloc] init];
  }
  return self;
}

- (void)load:(TTURLRequestCachePolicy)cachePolicy more:(BOOL)more {
  
  if (more)
    _pageNum ++;
  else 
    self.list = nil;
  
  NSMutableDictionary* _parameters = [[NSMutableDictionary alloc] init];
  if (_bank != nil) 
    [_parameters setObject:_bank forKey:@"bank"];
  if (_cuisineTypeID > 0) 
    [_parameters setObject:[NSString stringWithFormat:@"%d", _cuisineTypeID] forKey:@"cuisineTypeID"];
  if (_pageNum > 0) 
    [_parameters setObject:[NSString stringWithFormat:@"%d", _pageNum] forKey:@"pageNum"];
  if (_resultsPerPage > 0) 
    [_parameters setObject:[NSString stringWithFormat:@"%d", _resultsPerPage] forKey:@"resultsPerPage"];
  
  NSString* deviceID = [UIDevice currentDevice].uniqueIdentifier;
  [_parameters setObject:deviceID forKey:@"udid"];
  
  NSString *url = [URL_COUPON_LIST stringByAddingQueryDictionary:_parameters];
  NSLog(@"request url: %@", url);
  if (!self.isLoading && TTIsStringWithAnyText(url)) {
    
    TTURLRequest* request = [TTURLRequest
                             requestWithURL: url
                             delegate: self];
    
    request.cachePolicy = cachePolicy | TTURLRequestCachePolicyEtag;
    request.cacheExpirationAge = 1.0f;
    
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
  
  NSArray* data = [root objectForKey:@"data"];
  self.totalResult = [[root objectForKey:@"totalResults"] intValue];
  
  NSMutableArray* array = [[NSMutableArray alloc] initWithArray:self.list];
  
  NSUInteger i, count = [data count];
  for (i = 0; i < count; i++) {
    NSDictionary* obj = [data objectAtIndex:i];
    CouponObject* couponItem = [[CouponObject alloc] init];
    
    couponItem.couponID         = [[obj objectForKey:@"ID"] intValue];
    couponItem.offerID          = [[obj objectForKey:@"OfferID"] intValue];
    couponItem.imageUrl         = [obj objectForKey:@"Img"];
    couponItem.restaurantName   = [obj objectForKey:@"RestaurantName"];
    couponItem.cuisineType      = [obj objectForKey:@"CuisineType"];
    couponItem.address          = [obj objectForKey:@"Address"];
    //couponItem.rating         = [[obj objectForKey:@"Rating"] floatValue];
    //couponItem.reviews        = [[obj objectForKey:@"Reviews"] intValue];
    couponItem.offerShort       = [obj objectForKey:@"OfferShort"];
    couponItem.offerLong        = [obj objectForKey:@"OfferLong"];
	  
	couponItem.affiliate		= [obj objectForKey:@"Affiliate"];
    
    [array addObject:couponItem];
    TT_RELEASE_SAFELY(couponItem);
  }
  
  self.list = array;
  TT_RELEASE_SAFELY(array);
  
  [super requestDidFinishLoad:request];
}

@end
