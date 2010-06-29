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


NSString * const URL_SEARCH_NEARBY           = @"http://uob.dc2go.net/singtel/get_restaurant_by_location.php";
NSString * const URL_SEARCH_BY_LOCATION      = @"http://uob.dc2go.net/singtel/get_restaurant_by_sub_location.php";
NSString * const URL_GET_REST_BY_CUISINE     = @"http://uob.dc2go.net/singtel/get_restaurant_by_cuisine_type.php";
NSString * const URL_ALL_REST                = @"http://uob.dc2go.net/singtel/get_restaurant_list.php";
NSString * const URL_DIRECTION               = @"http://www.dc2go.net/api/map/getDirections.php";
NSString * const URL_REVERSE_GEO             = @"http://uob.dc2go.net/api/cdg_reversegeocode.php";
NSString * const URL_GET_LOCATION            = @"http://uob.dc2go.net/singtel/get_location.php";
NSString * const URL_GET_SUB_LOCATION        = @"http://uob.dc2go.net/singtel/get_sub_location.php";
NSString * const URL_GET_CUISINE             = @"http://uob.dc2go.net/singtel/get_cuisine.php";
@end
