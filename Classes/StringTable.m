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


NSString * const URL_SEARCH_NEARBY           = @"http://singtel.dc2go.net/api1.7/get_restaurant_by_location.php";
NSString * const URL_SEARCH_BY_LOCATION      = @"http://singtel.dc2go.net/api1.7/get_restaurant_by_sub_location.php";
NSString * const URL_GET_REST_BY_CUISINE     = @"http://singtel.dc2go.net/api1.7/get_restaurant_by_cuisine_type.php";
NSString * const URL_ALL_REST                = @"http://singtel.dc2go.net/api1.7/get_restaurant_list.php";
NSString * const URL_GET_DETAILs             = @"http://singtel.dc2go.net/api1.7/get_detail.php";
NSString * const URL_POST_RATING             = @"http://singtel.dc2go.net/api1.7/rating.php";
NSString * const URL_APP_ICON                = @"http://singtel.dc2go.net/api1.7/images/icon.png";
NSString * const URL_DIRECTION               = @"http://www.dc2go.net/api/map/getDirections.php";
NSString * const URL_REVERSE_GEO             = @"http://singtel.dc2go.net/api/cdg_reversegeocode.php";

NSString * const URL_GET_LOCATION            = @"http://singtel.dc2go.net/api1.7/get_location.php";
NSString * const URL_GET_SUB_LOCATION        = @"http://singtel.dc2go.net/api1.7/get_sub_location.php";
NSString * const URL_GET_CUISINE             = @"http://singtel.dc2go.net/api1.7/get_cuisine.php";
NSString * const URL_NORMAL_SEARCH           = @"http://singtel.dc2go.net/api1.7/search.php";
NSString * const URL_ADVANCE_SEARCH          = @"http://singtel.dc2go.net/api1.7/advanced_search.php";
NSString * const URL_CHECK_IP                = @"http://singtel.dc2go.net/api1.7/checkip.php";

NSString * const URL_COUPON_LIST             = @"http://singtel.dc2go.net/api1.7/get_restaurant_by_coupon2.php";
NSString * const URL_COUPON_DETAILS          = @"http://singtel.dc2go.net/api1.7/get_coupon3.php";
NSString * const URL_COUPON_REDEEM           = @"http://singtel.dc2go.net/api1.7/redeem_coupon2.php";

NSString * const URL_SPLASH_AD               = @"http://singtel.dc2go.net/api1.7/banners/survey.php?device_id=%@";
NSString * const URL_BANNER_AD				 = @"http://singtel.dc2go.net/api1.7/banners/top_banner.php?cat_id=0";
NSString * const URL_BANNER_AD_LOCATION      = @"http://singtel.dc2go.net/api1.7/banners/top_banner.php?cat_id=1";
NSString * const URL_BANNER_AD_CUISINE       = @"http://singtel.dc2go.net/api1.7/banners/top_banner.php?cat_id=2";
NSString * const URL_BANNER_AD_RESTAURANTS   = @"http://singtel.dc2go.net/api1.7/banners/top_banner.php?cat_id=3";
NSString * const URL_BANNER_AD_M_COUPONS     = @"http://singtel.dc2go.net/api1.7/banners/top_banner.php?cat_id=4";
NSString * const URL_BANNER_AD_MORE          = @"http://singtel.dc2go.net/api1.7/banners/top_banner.php?cat_id=5";

NSString * const URL_CONFIGURE_CARD			 = @"http://singtel.dc2go.net/api1.7/analytics/configure_card.php"; //@"http://192.168.1.143/ilovedeals.sg/card.php";

NSString * const URL_APNS_REGISTER			 = @"http://singtel.dc2go.net/api1.7/apns/index.php?r=APNS/notification/register&token=%@&device_id=%@";

NSString * const AMEX_ALL					 = @"47";
NSString * const CITYBANK_ALL			     = @"1";
NSString * const DBS_ALL					 = @"8";
NSString * const HSBC_ALL					 = @"42";
NSString * const OCBC_ALL					 = @"12";
NSString * const POSB_ALL					 = @"46";
NSString * const SCB_ALL					 = @"45";
NSString * const UOB_ALL					 = @"30";

@end
