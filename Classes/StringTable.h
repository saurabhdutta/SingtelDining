//
//  StringTable.h
//  MiniPages
//
//  Created by Tonytoons on 2/16/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface StringTable : NSObject {

}

extern int const QUERY_LIMIT;



extern NSString * const URL_SEARCH_NEARBY;
extern NSString * const URL_SEARCH_BY_LOCATION;
extern NSString * const URL_GET_REST_BY_CUISINE;
extern NSString * const URL_ALL_REST;
extern NSString * const URL_GET_DETAILs;
extern NSString * const URL_POST_RATING;
extern NSString * const URL_APP_ICON;
extern NSString * const URL_DIRECTION;
extern NSString * const URL_REVERSE_GEO;
extern NSString * const URL_GET_LOCATION;
extern NSString * const URL_GET_SUB_LOCATION;
extern NSString * const URL_GET_CUISINE;
extern NSString * const URL_NORMAL_SEARCH;
extern NSString * const URL_ADVANCE_SEARCH;
extern NSString * const URL_CHECK_IP;

extern NSString * const URL_COUPON_LIST;
extern NSString * const URL_COUPON_DETAILS;
extern NSString * const URL_COUPON_REDEEM;

extern NSString * const URL_SPLASH_AD;
extern NSString * const URL_BANNER_AD;

#define kSGLatitude 1.352083f
#define kSGLongitude 103.819836f

@end
