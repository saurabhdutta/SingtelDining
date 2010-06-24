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



NSString * const URL_DIRECTION   = @"http://www.dc2go.net/api/map/getDirections.php";
NSString * const URL_GEO 			= @"http://www.dc2go.net/api/geocoder.php";
NSString * const URL_REVERSE_GEO = @"http://www.dc2go.net/api/reverseGeocoder.php";

NSString * const URL_SEARCH		= @"http://uob.dc2go.net/singtel/get_restaurant_by_location.php";
NSString * const URL_DCARD		= @"http://ws.d.co.il/generalgpws/service.asmx/getDcardData";
NSString * const URL_COUPON		= @"http://ws.d.co.il/generalgpws/service.asmx/getCouponData";


NSString * const PASSWORD			= @"c3llC!ty";


@end
