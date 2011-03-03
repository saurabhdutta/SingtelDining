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
#import <Three20Core/NSStringAdditions.h>
#import <CoreLocation/CoreLocation.h>
#import "AppDelegate.h"
#import "MobileIdentifier.h"

// Flurry analytics
#import "FlurryAPI.h"


@implementation ListDataModel

@synthesize searchQuery = _searchQuery;
@synthesize posts      = _posts;
@synthesize page;
@synthesize totalResults;

///////////////////////////////////////////////////////////////////////////////////////////////////

- (id)initWithURL:(NSString*)url {
	if (self = [super init]) {
		_searchQuery = [url retain];
		_posts = [[NSMutableArray alloc] init];
		page = 1;
	}
	return self;
}

- (id)initWithSearchQuery:(NSString*)searchQuery {
  if (self = [super init]) {
    self.searchQuery = searchQuery;
    _posts = [[NSMutableArray alloc] init];
    page = 1;
  }
  
  return self;
}

- (id)initWithSearchQuery:(NSString*)searchQuery withSearchParameterValues:(NSArray*) values andKeys:(NSArray*) keys {
  if (self = [super init]) {
    _posts = [[NSMutableArray alloc] init];
      page = 1;
      NSString * parameters = @"";
      int index = -1;
      
      for(NSString *v in values) {
         index++;
         NSString * encoded = [v stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
         encoded = [self urlencode:encoded];
         
         NSString * key = [keys objectAtIndex: index];
        
        // Flurry analytics
        if ([key isEqualToString:@"bank"]) {
          NSMutableDictionary* analytics = [[NSMutableDictionary alloc] init];
          [analytics setObject:v forKey:key];
          [FlurryAPI logEvent:@"EVENT_BANK" withParameters:analytics];
          [analytics release];
        }
         
         if( ![parameters isEqualToString: @""] ) parameters = [parameters stringByAppendingString: @"&"];
         parameters = [parameters stringByAppendingFormat:@"%@=%@", key, encoded];
      }
      
      self.searchQuery = [searchQuery stringByAppendingFormat: @"?%@", parameters];
   }
   
   return self;
}

- (id)initWithQuery:(NSDictionary*)query {
  if (self = [super init]) {
    _searchQuery = [URL_NORMAL_SEARCH stringByAddingQueryDictionary:query];
    [_searchQuery retain];
    _posts = [[NSMutableArray alloc] init];
    page = 1;
  }
  return self;
}


- (NSString *) urlencode: (NSString *) url{
   NSArray *escapeChars = [NSArray arrayWithObjects:@";" , @"/" , @"?" , @":" ,
                           @"@" , @"&" , @"=" , @"+" ,
                           @"$" , @"," , @"[" , @"]",
                           @"#", @"!", @"'", @"(", 
                           @")", @"*", nil];
   
   NSArray *replaceChars = [NSArray arrayWithObjects:@"%3B" , @"%2F" , @"%3F" ,
                            @"%3A" , @"%40" , @"%26" ,
                            @"%3D" , @"%2B" , @"%24" ,
                            @"%2C" , @"%5B" , @"%5D", 
                            @"%23", @"%21", @"%27",
                            @"%28", @"%29", @"%2A", nil];
   
   int len = [escapeChars count];
   
   NSMutableString *temp = [url mutableCopy];
   
   int i;
   for(i = 0; i < len; i++)
   {
      
      [temp replaceOccurrencesOfString: [escapeChars objectAtIndex:i]
                            withString:[replaceChars objectAtIndex:i]
                               options:NSLiteralSearch
                                 range:NSMakeRange(0, [temp length])];
   }
   
   NSString *out = [NSString stringWithString: temp];
   
   return out;
}

- (void)loadDataWithSearchQuery:(NSString*)searchQuery {
  self.searchQuery = searchQuery;
  _posts = [[NSMutableArray alloc] init];
  page = 1;
}

- (id)initWithSearchKeyword:(NSString *)keyword {
  if (self = [super init]) {
    self.searchQuery = [NSString stringWithFormat:[URL_NORMAL_SEARCH stringByAppendingFormat:@"?keyword=%@", [keyword stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
    _posts = [[NSMutableArray alloc] init];
    page = 1;
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
    
    if (more) {
      page ++;
    } else {
      [_posts removeAllObjects];
    }
	  
	  NSMutableDictionary* p = [NSMutableDictionary dictionary];
	  [p setObject:[[UIDevice currentDevice] uniqueIdentifier] forKey:@"device_id"];
	  [p setObject:[MobileIdentifier getMobileName] forKey:@"device_type"];
	  [p setObject:[NSString stringWithFormat:@"%d", (int)page] forKey:@"pageNum"];
	  NSString* url = [_searchQuery stringByAddingQueryDictionary:p];
    
    TTURLRequest* request = [TTURLRequest requestWithURL:url delegate: self];
    NSLog(@"requst: %@", request);
    
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
  totalResults = [[feed objectForKey:@"totalResults"] intValue];

  // Core Location to Calculate distance between POIs
  AppDelegate* delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
  CLLocation* userLocation = [[CLLocation alloc] initWithLatitude:delegate.currentGeo.latitude longitude:delegate.currentGeo.longitude];
  NSString* osVersion = [[UIDevice currentDevice] systemVersion];
   
  //TT_RELEASE_SAFELY(_posts);
  //NSMutableArray* posts = [[NSMutableArray alloc] initWithCapacity:[entries count]];
  
  for (NSDictionary* entry in entries) {
    if (TTIsStringWithAnyText([entry objectForKey:@"RestaurantName"]) && TTIsStringWithAnyText([entry objectForKey:@"Address"])) {
      ListObject* post = [[ListObject alloc] init];
      post.uid = [NSNumber numberWithInt:[[entry objectForKey:@"ID"] intValue]];
      post.title = [entry objectForKey:@"RestaurantName"];
      NSString *imageUrl = [entry objectForKey:@"Image"];
      post.image = ([imageUrl isEqualToString:@"null"]) ? @"" : imageUrl;
      post.address = [entry objectForKey:@"Address"];
      post.rating = [[entry objectForKey:@"Rating"] floatValue];
      post.latitude = [entry objectForKey:@"Latitude"];
      post.longitude = [entry objectForKey:@"Longitude"];
      if (TTIsStringWithAnyText([entry objectForKey:@"Distance"])) {
        post.distance = [[entry objectForKey:@"Distance"] floatValue];
      } else {
        CLLocation* theLocation = [[CLLocation alloc] initWithLatitude:[post.latitude floatValue] longitude:[post.longitude floatValue]];
        
        NSInteger comparisonResult = [osVersion versionStringCompare:@"3.2"];
        CLLocationDistance distanceInMeters;
        if (comparisonResult == NSOrderedAscending) {
          distanceInMeters = [theLocation getDistanceFrom:userLocation];
        } else {
          distanceInMeters = [theLocation distanceFromLocation:userLocation];
        }
        
        CGFloat distance = distanceInMeters / 1000;
        post.distance = [[NSString stringWithFormat:@"%.1f", distance] floatValue];
        [theLocation release];
      }
      
      [_posts addObject:post];
      TT_RELEASE_SAFELY(post);
    }
    
  }
  //_posts = posts;
  [userLocation release];
  
  [super requestDidFinishLoad:request];
}





@end
