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
  
  NSString *url = [@"http://174.143.170.165/singtel/get_restaurant_by_coupon.php" stringByAddingQueryDictionary:_parameters];
  NSLog(@"request url: %@", url);
  if (!self.isLoading && TTIsStringWithAnyText(url)) {
    
    TTURLRequest* request = [TTURLRequest
                             requestWithURL: url
                             delegate: self];
    
    request.cachePolicy = cachePolicy | TTURLRequestCachePolicyEtag;
    //request.cacheExpirationAge = TT_CACHE_EXPIRATION_AGE_NEVER;
    
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
    
    couponItem.couponID         = [[obj objectForKey:@"id"] intValue];
    couponItem.imageUrl         = [obj objectForKey:@"Img"];
    couponItem.restaurantName   = [obj objectForKey:@"RestaurantName"];
    couponItem.cuisineType      = [obj objectForKey:@"CuisineType"];
    couponItem.address          = [obj objectForKey:@"Address"];
    couponItem.rating           = [[obj objectForKey:@"Rating"] floatValue];
    couponItem.reviews          = [[obj objectForKey:@"Reviews"] intValue];
    couponItem.latitude         = [[obj objectForKey:@"Latitude"] floatValue];
    couponItem.longitude        = [[obj objectForKey:@"Longitude"] floatValue];
    
    [array addObject:couponItem];
    TT_RELEASE_SAFELY(couponItem);
  }
  
  self.list = array;
  TT_RELEASE_SAFELY(array);
  
  [super requestDidFinishLoad:request];
}

@end
