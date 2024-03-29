//
//  DetailsModel.m
//  SingtelDining
//
//  Created by Alex Yao on 6/24/10.
//  Copyright 2010 CellCity. All rights reserved.
//

#import "DetailsModel.h"
#import "DetailsObject.h"
#import <extThree20JSON/extThree20JSON.h>


@implementation DetailsModel

@synthesize data = _data;

///////////////////////////////////////////////////////////////////////////////////////////////////
- (id)initWithRestarantsId:(int)restarantsId {
  if (self = [super init]) {
    rid = restarantsId;
  }
  return self;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)dealloc {
  TT_RELEASE_SAFELY(_data);
  [super dealloc];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)load:(TTURLRequestCachePolicy)cachePolicy more:(BOOL)more {
  NSString *url = [NSString stringWithFormat:[URL_GET_DETAILs stringByAppendingFormat:@"?id=%d", rid]];
  NSLog(@"request url: %@", url);
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
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)requestDidFinishLoad:(TTURLRequest*)request {
  TTURLJSONResponse* response = request.response;
  
  NSDictionary* feed = response.rootObject;
  
  NSDictionary* entry = [feed objectForKey:@"data"];
  
  TT_RELEASE_SAFELY(_data);
  
  DetailsObject *restaurant = [[DetailsObject alloc] init];
  restaurant.rid = [[entry objectForKey:@"id"] intValue];
  restaurant.title = [entry objectForKey:@"title"];
  restaurant.rating = [[entry objectForKey:@"rating"] floatValue];
  restaurant.review = [[entry objectForKey:@"reviews"] intValue];
  restaurant.offers = [NSArray arrayWithArray:[entry objectForKey:@"offers"]];
  for (NSMutableDictionary* bank in restaurant.offers) {
	  NSString* of = [bank objectForKey:@"offer"];
	  of = [of stringByReplacingOccurrencesOfString:@"\"" withString:@"&quot;"];
	  of = [of stringByReplacingOccurrencesOfString:@"&" withString:@"&amp;"];
	  [bank setObject:of forKey:@"offer"];
  }
  restaurant.address = [entry objectForKey:@"address"];
  restaurant.phone = [entry objectForKey:@"phone"];
  restaurant.latitude = [[entry objectForKey:@"latitude"] floatValue];
  restaurant.longitude = [[entry objectForKey:@"longitude"] floatValue];
  restaurant.descriptionString = [entry objectForKey:@"description"];
  restaurant.img = [entry objectForKey:@"img"];
  restaurant.thumb = [entry objectForKey:@"thumb"];
  restaurant.branches = [entry objectForKey:@"branches"];
  restaurant.type = [entry objectForKey:@"type"];
  
  _data = [restaurant retain];
  TT_RELEASE_SAFELY(restaurant);
  [super requestDidFinishLoad:request];
}

@end
