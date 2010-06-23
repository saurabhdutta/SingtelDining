//
//  ListDataModel.m
//  SingtelDining
//
//  Created by Alex Yao on 6/23/10.
//  Copyright 2010 CellCity. All rights reserved.
//

#import <extThree20JSON/extThree20JSON.h>
#import "ListDataModel.h"
#import "ListObject.h"


@implementation ListDataModel

@synthesize searchQuery = _searchQuery;
@synthesize posts      = _posts;

///////////////////////////////////////////////////////////////////////////////////////////////////
- (id)initWithSearchQuery:(NSString*)searchQuery {
  if (self = [super init]) {
    self.searchQuery = searchQuery;
  }
  
  return self;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void) dealloc {
  TT_RELEASE_SAFELY(_searchQuery);
  TT_RELEASE_SAFELY(_posts);
  [super dealloc];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)load:(TTURLRequestCachePolicy)cachePolicy more:(BOOL)more {
  if (!self.isLoading && TTIsStringWithAnyText(_searchQuery)) {
    
    TTURLRequest* request = [TTURLRequest
                             requestWithURL: _searchQuery
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
  TTDASSERT([response.rootObject isKindOfClass:[NSDictionary class]]);
  
  NSDictionary* feed = response.rootObject;
  TTDASSERT([[feed objectForKey:@"data"] isKindOfClass:[NSArray class]]);
  
  NSArray* entries = [feed objectForKey:@"data"];
  TT_RELEASE_SAFELY(_posts);
  NSMutableArray* posts = [[NSMutableArray alloc] initWithCapacity:[entries count]];
  
  for (NSDictionary* entry in entries) {
    if (TTIsStringWithAnyText([entry objectForKey:@"RestaurantName"]) && TTIsStringWithAnyText([entry objectForKey:@"Address"])) {
      ListObject* post = [[ListObject alloc] init];
      post.uid = [NSNumber numberWithInt:[[entry objectForKey:@"ID"] intValue]];
      post.title = [entry objectForKey:@"RestaurantName"];
      NSString *imageUrl = [entry objectForKey:@"Image"];
      post.image = ([imageUrl isEqualToString:@"null"]) ? @"" : imageUrl;
      post.address = [entry objectForKey:@"Address"];
      post.rating = [[entry objectForKey:@"Rating"] floatValue];
      [posts addObject:post];
      TT_RELEASE_SAFELY(post);
    }
    
  }
  _posts = posts;
  
  [super requestDidFinishLoad:request];
}



@end
