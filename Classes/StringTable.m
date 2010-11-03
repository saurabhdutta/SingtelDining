//
//  StringTable.m
//  MiniPages
//
//  Created by Tonytoons on 2/16/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "StringTable.h"

@implementation StringTable

int const QUERY_LIMIT	    = 10;


NSString * const URL_SEARCH_NEARBY           = @"http://singtel.dc2go.net/singtel-dev/get_restaurant_by_location.php";
NSString * const URL_SEARCH_BY_LOCATION      = @"http://singtel.dc2go.net/singtel-dev/get_restaurant_by_sub_location.php";
NSString * const URL_GET_REST_BY_CUISINE     = @"http://singtel.dc2go.net/singtel-dev/get_restaurant_by_cuisine_type.php";
NSString * const URL_ALL_REST                = @"http://singtel.dc2go.net/singtel-dev/get_restaurant_list.php";
NSString * const URL_DIRECTION               = @"http://www.dc2go.net/api/map/getDirections.php";
NSString * const URL_REVERSE_GEO             = @"http://singtel.dc2go.net/api/cdg_reversegeocode.php";
NSString * const URL_GET_LOCATION            = @"http://singtel.dc2go.net/singtel-dev/get_location.php";
NSString * const URL_GET_SUB_LOCATION        = @"http://singtel.dc2go.net/singtel-dev/get_sub_location.php";
NSString * const URL_GET_CUISINE             = @"http://singtel.dc2go.net/singtel-dev/get_cuisine.php";
NSString * const URL_NORMAL_SEARCH           = @"http://singtel.dc2go.net/singtel-dev/search.php";
NSString * const URL_ADVANCE_SEARCH          = @"http://singtel.dc2go.net/singtel-dev/advanced_search.php";
NSString * const URL_CHECK_IP                = @"http://singtel.dc2go.net/singtel-dev/checkip.php";

NSString * const URL_COUPON_LIST             = @"http://174.143.170.165/singtel/get_restaurant_by_coupon.php";
NSString * const URL_COUPON_DETAILS          = @"http://174.143.170.165/singtel/get_coupon.php";
NSString * const URL_COUPON_REDEEM           = @"http://174.143.170.165/singtel/redeem_coupon";
@end
