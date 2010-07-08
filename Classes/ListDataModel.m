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


@implementation ListDataModel

@synthesize searchQuery = _searchQuery;
@synthesize posts      = _posts;
@synthesize page;
@synthesize totalResults;

///////////////////////////////////////////////////////////////////////////////////////////////////
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
    self.searchQuery = [NSString stringWithFormat:@"http://uob.dc2go.net/singtel/search.php?keyword=%@", [keyword stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
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
    
    TTURLRequest* request = [TTURLRequest
                             requestWithURL: [_searchQuery stringByAppendingFormat:@"&pageNum=%i", (int)page] 
                             delegate: self];
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
      post.distance = [[entry objectForKey:@"Distance"] floatValue];
      [_posts addObject:post];
      TT_RELEASE_SAFELY(post);
    }
    
  }
  //_posts = posts;
  
  [super requestDidFinishLoad:request];
}





@end
