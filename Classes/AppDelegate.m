//
//  SingtelDiningAppDelegate.m
//  SingtelDining
//
//  Created by Alex Yao on 6/11/10.
//  Copyright 2010 CellCity. All rights reserved.
//


#define SOURCETYPE UIImagePickerControllerSourceTypeCamera


#pragma mark -
#pragma mark UINavigationBar
@implementation UINavigationBar (UINavigationBarCategory)
- (void)drawRect:(CGRect)rect {
   UIImage *image = [UIImage imageNamed:@"header.png"];
	[image drawInRect:CGRectMake(self.frame.size.width/2 - 89/2, 7, 89, 56)];
   NSLog(@"drawRect");
}

@end 
#pragma mark -


#import "AppDelegate.h"
#import "MBProgressHUD.h"

#import "SplashViewController.h"
#import "TabBarController.h"
#import "CardViewController.h"
#import "InfoViewController.h"
#import "LocationViewController.h"
#import "RestaurantsViewController.h"
#import "CuisinesViewController.h"
#import "FavouritesViewController.h"
#import "AdvanceSearchViewController.h"
#import "SearchViewController.h"
#import "DetailsViewController.h"
#import "TwitterViewController.h"
#import "JSONRequest.h"
#import <extThree20JSON/extThree20JSON.h>
#import "BlockViewController.h"

#import <MobileCoreServices/UTCoreTypes.h>

// Flurry analytics
#import "FlurryAPI.h"

// m-Coupon
#import "CouponViewController.h"
#import "MoreViewController.h"

// ad
#import "SplashADView.h"
#import "SplashAdViewController.h"

///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
@implementation AppDelegate
@synthesize locationManager, remoteHostStatus, internetConnectionStatus, localWiFiConnectionStatus;
@synthesize currentGeo,udid, currentLocation, reverseGeocoder;
@synthesize  taxiBuilding, taxiBlock, taxiStreet, taxiPostcode, taxiLocation, taxiErrorCode,taxiRef;
@synthesize cardChainDataSource;
@synthesize locationShouldReload, restaurantsShouldReload, cuisineShouldReload, isSupportAR;
@synthesize savc, isSplashAD;
@synthesize isLocationServiceAvailiable;

///////////////////////////////////////////////////////////////////////////////////////////////////
//- (void)applicationDidFinishLaunching:(UIApplication *)application {
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
	
  // Flurry analytics
  [FlurryAPI startSession:@"MK1ZZQTLYYB4B8FBGPME"];
  
  TTNavigator* navigator = [TTNavigator navigator];
	navigator.delegate = self;
  
  navigator.window.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg.png"]];
  
  UIView *tmpView = [[[UIView alloc] initWithFrame:TTApplicationFrame()] autorelease];
  hud = [[MBProgressHUD alloc] initWithView:tmpView];
  [tmpView addSubview:hud];
  hud.labelText = @"Getting location...";
  [hud show:YES];
  [navigator.window addSubview:tmpView];
    
  // check operator
  [self checkOperator];
  
  [self getDeviceid];
  
  [Reachability reachabilityWithHostName:@"www.dc2go.net"];
	//[self updateStatus];
  
  gpsDone = FALSE;
   
  
  // navigationItem background
  
  navigator.persistenceMode = TTNavigatorPersistenceModeNone;
  
  TTURLMap* map = navigator.URLMap;
  
  [map from:@"*" toViewController:[InfoViewController class]];
  [map from:kAppSplashURLPath toViewController:[SplashViewController class]];
  [map from:kAppBlockURLPath toModalViewController:[BlockViewController class]];
  [map from:kAppRootURLPath toSharedViewController:[TabBarController class]];
  [map from:kAppCreditURLPath toModalViewController:[CardViewController class]];
  [map from:kAppLocaltionURLPath toViewController:[LocationViewController class]];
  [map from:kAppRestaurantsURLPath toViewController:[RestaurantsViewController class]];
  [map from:kAppCuisinesURLPath toViewController:[CuisinesViewController class]];
  [map from:kAppCouponURLPath toViewController:[CouponViewController class]];
  [map from:kAppFavouritesURLPath toViewController:[FavouritesViewController class]];
  [map from:kAppSearchURLPath toViewController:[AdvanceSearchViewController class]];
  [map from:kAppResultURLPath toViewController:[SearchViewController class]];
  [map from:kAppDetailsURLPath toSharedViewController:[DetailsViewController class]];
  [map from:kAppTwitterURLPath toModalViewController:[TwitterViewController class]];
  [map from:kAppMoreURLPath toModalViewController:[MoreViewController class]];
  
  //if (![navigator restoreViewControllers]) {
//    //[navigator openURLAction:[TTURLAction actionWithURLPath:kAppSplashURLPath]];
//    [navigator openURLAction:[TTURLAction actionWithURLPath:kAppRootURLPath]];
//  }
  
  HTableDataSource *ds = [[HTableDataSource alloc] init];
  self.cardChainDataSource = ds;
  [ds release];
  
	/*
  banner = [[UIWebView alloc] initWithFrame:CGRectMake(5, 25, 310, 35)];
  [[[banner subviews] lastObject] setScrollEnabled:NO];
  banner.delegate = self;
  banner.layer.cornerRadius = 5;
  banner.layer.masksToBounds = YES;
  NSURLRequest* bannerRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:URL_BANNER_AD]];
  [banner loadRequest:bannerRequest];
  banner.hidden = YES;
  [navigator.window addSubview:banner];
  [banner release];*/
	

	// APNS
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeBadge |UIRemoteNotificationTypeSound)];

	pushedTabIndex = 0;
	NSDictionary* remoteNotification = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
	if (remoteNotification && [remoteNotification objectForKey:@"tab"]) {
		//TTAlert([NSString stringWithFormat:@"remoteNotification: %@", [remoteNotification objectForKey:@"tab"]]);
		pushedTabIndex = [[remoteNotification objectForKey:@"tab"] intValue];
		//NSLog(@"tabIndex: %d", tab);
	} else {
		// Splash AD
		savc = [[SplashAdViewController alloc] initWithURL:[NSString stringWithFormat:URL_SPLASH_AD, [[UIDevice currentDevice] uniqueIdentifier]]];
		[navigator.window addSubview:savc.view];
	}

	
	return YES;
}
- (void)application:(UIApplication *)app didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    NSLog(@"devToken=%@",deviceToken);
	NSString* token = [NSString stringWithFormat:@"%@",deviceToken];
	token = [token stringByReplacingOccurrencesOfString:@"<" withString:@""];
	token = [token stringByReplacingOccurrencesOfString:@">" withString:@""];
	token = [token stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
	
	// TODO send deviceToken to server and store in database
	NSString* url = [NSString stringWithFormat:URL_APNS_REGISTER, token];
	TTURLRequest *apnsRequest = [TTURLRequest requestWithURL:url delegate:self];
	apnsRequest.response = [[[TTURLDataResponse alloc] init] autorelease];
	apnsRequest.cachePolicy = TTURLRequestCachePolicyNoCache;
	[apnsRequest send];
	//TTAlert([NSString stringWithFormat:@"register token: %@", url]);
}
- (void)application:(UIApplication *)app didFailToRegisterForRemoteNotificationsWithError:(NSError *)err {
    NSLog(@"Error in registration. Error: %@", err);
	//TTAlert([NSString stringWithFormat:@"error: %@", [err description]]);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
	NSLog(@"userinfo: %@", userInfo);
	if (userInfo && [userInfo objectForKey:@"tab"]) {
		NSInteger tab = [[userInfo objectForKey:@"tab"] intValue];
        if (tab>0)
            tab = tab - 1;
		NSLog(@"tabIndex: %d", tab);
		UIViewController* c = [[TTNavigator navigator] topViewController];
		[c.tabBarController setSelectedIndex:tab];
	}
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (BOOL)navigator:(TTNavigator*)navigator shouldOpenURL:(NSURL*)URL {
	if ([[URL.scheme uppercaseString] isEqualToString:@"TEL"]) {
		
		// Flurry analytics
		NSMutableDictionary* analytics = [[NSMutableDictionary alloc] init];
		[analytics setObject:URL.absoluteURL forKey:@"CALL_NUMBER"];
		[FlurryAPI logEvent:@"CALL_CLICK" withParameters:analytics timed:YES];
		[analytics release];
		
		if (!TTIsPhoneSupported()) {
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Phone call is not available on your device." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
			[alert show];
			[alert release];
			return NO;
		}
	}
   return YES;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (BOOL)application:(UIApplication*)application handleOpenURL:(NSURL*)URL {
   [[TTNavigator navigator] openURLAction:[TTURLAction actionWithURLPath:URL.absoluteString]];
   return YES;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark check operator
- (void)checkOperator {
  NSLog(@"checkOperator");
  TTURLRequest* checkRequest = [TTURLRequest requestWithURL:URL_CHECK_IP delegate:self];
  checkRequest.cachePolicy = TTURLRequestCachePolicyNoCache;
  checkRequest.response = [[[TTURLJSONResponse alloc] init] autorelease];
  [checkRequest send];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)requestDidFinishLoad:(TTURLRequest*)checkRequest {
	NSLog(@"checkOperator requestDidFinishLoad");
	if ([checkRequest.urlPath isEqualToString:URL_CHECK_IP]) {
		
		TTURLJSONResponse* response = checkRequest.response;
		TTDASSERT([response.rootObject isKindOfClass:[NSDictionary class]]);
		
		NSDictionary* feed = response.rootObject;
		
		NSLog(@"feed: %@",feed);
		
		TTDASSERT([[feed objectForKey:@"allow"] isKindOfClass:[NSString class]]);
		
		//[[self locationManager] startUpdatingLocation];
		//return;
		
		if (![[feed objectForKey:@"allow"] isEqualToString:@"yes"]) {
			[hud hide:YES];
			[[TTNavigator navigator] openURLAction:[TTURLAction actionWithURLPath:kAppBlockURLPath]];
		} else {
			[[self locationManager] startUpdatingLocation];
		}
	} else {
		NSLog(@"requestDidFinishLoad: %@", checkRequest.urlPath);
	}
}


#pragma mark -
#pragma mark Function Delegates

- (void) setDelegate:(id) val
{
   delegateFunc = val;
}

- (id) delegate
{
   return delegateFunc;
}


#pragma mark location updater

- (void)reachabilityChanged:(NSNotification *)note{
   [self updateStatus];
}

- (void)updateStatus{
	// Query the SystemConfiguration framework for the state of the device's network connections.
	self.remoteHostStatus           = [[Reachability sharedReachability] remoteHostStatus];
	self.internetConnectionStatus	= [[Reachability sharedReachability] internetConnectionStatus];
	self.localWiFiConnectionStatus	= [[Reachability sharedReachability] localWiFiConnectionStatus];
	[self updateCarrierDataNetworkWarning];
}

- (void)updateCarrierDataNetworkWarning{
	if (self.internetConnectionStatus == NotReachable) {
		//UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"ERR" message: @"ERR" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
		//[alert show];	
		//[alert release];		
      NSLog(@"Not Reachable! Alert Message Here doesnt work! Alex is showing the error. Hmm.. Weird!");
	}
}

- (void)showRootView {
	[[UIApplication sharedApplication] setStatusBarHidden:NO];
	[[TTNavigator navigator] openURLAction:[TTURLAction actionWithURLPath:kAppRootURLPath]];
	
	if (pushedTabIndex) {
		
		UIViewController* c = [[TTNavigator navigator] topViewController];
		
		if ([c isKindOfClass:[TabBarController class]]) {
			[(TabBarController*)c setSelectedIndex:pushedTabIndex];
		} else {
			[c.tabBarController setSelectedIndex:pushedTabIndex];
		}
	} else {
		
		[[[TTNavigator navigator] window] bringSubviewToFront:savc.view];
	}

}

- (CLLocationManager *)locationManager {
	
   if (locationManager != nil) {
		return locationManager;
	}
	
	locationManager = [[CLLocationManager alloc] init];
	[locationManager setDistanceFilter:1000.0f];
	[locationManager setDesiredAccuracy:kCLLocationAccuracyNearestTenMeters];
	[locationManager setDelegate:self];
	
	return locationManager;
}

- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation {
  
  NSLog(@"Did update location!\n");
  isLocationServiceAvailiable = YES;
  
  CLLocationCoordinate2D newCoordinate = [newLocation coordinate];
  if ( (newCoordinate.latitude == currentGeo.latitude) && (newCoordinate.longitude == currentGeo.longitude)) {
    // same coordinate, do nothing
  } else {
    
    // Flurry analytics
    [FlurryAPI setLocation:newLocation];
    
    currentGeo = [newLocation coordinate];
    NSLog(@"lat: %+.6f, lng: %+.6f", currentGeo.latitude, currentGeo.longitude);
    
    self.reverseGeocoder = [[[MKReverseGeocoder alloc] initWithCoordinate: currentGeo] autorelease];
    reverseGeocoder.delegate = self;
    [reverseGeocoder start];
  }
  
  [hud hide:YES];
  [self showRootView];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
  if ([error code] == kCLErrorDenied ) {
    isLocationServiceAvailiable = NO;
    currentGeo.latitude = kSGLatitude;
    currentGeo.longitude = kSGLongitude;
    
    [hud hide:YES];
    [self showRootView];
    /*
    UIAlertView *clAlert = [[UIAlertView alloc] initWithTitle:@"" message:@"Turn on Location Services on your device to allow \"ILoveDeals\" to determine your location" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [clAlert show];
    [clAlert release];
    
    [hud setLabelText:@""];
    [hud setDetailsLabelText:@"Turn on Location Services on your device to allow \"ILoveDeals\" to determine your location"];
    [hud setMode:MBProgressHUDModeCustomView];
    [hud setCustomView:[[[UIView alloc] initWithFrame:CGRectZero] autorelease]];
     */
  }
}


- (void) getDeviceid{
	UIDevice *device = [UIDevice currentDevice];
	NSString *uniqueIdentifier = [device uniqueIdentifier];
	NSString *dName = [device name];
	
	udid = [NSString stringWithFormat:@"%@_%@", dName, uniqueIdentifier ];
	NSLog(@"udid is %@", udid);
	//udid = @"ccdebug";
	[udid retain];
  
  isSupportAR = NO;
  if ([UIImagePickerController isSourceTypeAvailable:SOURCETYPE]) {
    // if so, does that camera support video?
    NSArray *mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:SOURCETYPE];
    isSupportAR = [mediaTypes containsObject:kUTTypeMovie];
  }
}

- (void)reverseGeocoder:(MKReverseGeocoder *)geocoder didFailWithError:(NSError *)error{
  NSLog(@"reverseGeocoder didFailWithError: %@", error);
  [self googleReverseGeocoderWithCoordinate:currentGeo];
}

- (void)reverseGeocoder:(MKReverseGeocoder *)geocoder didFindPlacemark:(MKPlacemark *)placemark{
	self.currentLocation = [NSString stringWithFormat:@"%@ %@, %@", placemark.subThoroughfare, placemark.thoroughfare, placemark.country];
	[self.currentLocation retain];
	
	NSLog(@"reverseGeocoder didFindPlacemark: %@",self.currentLocation);
}

- (void)googleReverseGeocoderWithCoordinate:(CLLocationCoordinate2D)coordinate {
  NSLog(@"google Reverse Geocoder");
  
  // Show network activity Indicator (no need really as its very quick)
  [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
  
  // Use Google Service
  // OK the code is verbose to illustrate step by step process
  
  // Form the string to make the call, passing in lat long 
  NSString *urlString = [NSString stringWithFormat:@"http://maps.google.com/maps/geo?q=%lf,%lf&output=csv&sensor=false", coordinate.latitude,coordinate.longitude];
  
  // Turn it into a URL
  NSURL *urlFromURLString = [NSURL URLWithString:urlString];
  
  // Use UTF8 encoding
  NSStringEncoding encodingType = NSUTF8StringEncoding;
  
  // reverseGeoString is what comes back with the goodies
  NSString *reverseGeoString = [NSString stringWithContentsOfURL:urlFromURLString encoding:encodingType error:nil];
  
  // If it fails it returns nil	
  if (reverseGeoString != nil)
  {
    
    // Break up the tokens returned in the string
    // They are comma separated
    // The first one is the success code (glass always half full)
    // Put this into an array to tokenise
    NSArray *listItems = [reverseGeoString
                          componentsSeparatedByString:@","];
    
    // So the first object in the array is the success code 
    // 200 means everything is happy
    if ([[listItems objectAtIndex:0] isEqualToString:@"200"])
    {
      // Get the address quality
      // We should always have this, but you never know
      if ([listItems count] >= 1)
      {
        NSString *addressQuality =[listItems objectAtIndex:1];
        // You can store this somewhere 9 is best, 8 is still great
        // You can read Googles doco for an explanation
        // e.g. [NSNumber numberWithInteger:[addressQuality intValue]]
      }
      // Get the address string.
      // I am just creating another array to extract the quoted address
      NSArray *quotedPart = [reverseGeoString componentsSeparatedByString:@"\""];
      
      // It should always be there as objectAtIndex 1
      if ([quotedPart count] >= 2)
      {
        NSString *address = [quotedPart objectAtIndex:1];
        if ([address length]>0) {
          self.currentLocation = address;
        }
      }
    }
  }
  
  // Hide network activity indicator
  [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}

#pragma mark -
#pragma mark FlurryAdDelegate
/* 
 called after data is received
 */
- (void)dataAvailable {
  NSLog(@"Flurry analytics data is received");
}
/*
 called after data is determined to be unavailable
 */
- (void)dataUnavailable {
  NSLog(@"Flurry analytics data is determined to be unavailable");
}

/*
#pragma mark -
#pragma mark UIWebViewDelegate
*/

/*
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)webRequest navigationType:(UIWebViewNavigationType)navigationType {
  
  NSLog(@"AppDelegate: shouldStartLoadWithRequest");	
	
  //banner.alpha = 1.0;
  	
  TTDPRINT(@"webview navigationType: %d", navigationType);
  if (navigationType == UIWebViewNavigationTypeLinkClicked) {
    TTOpenURL([NSString stringWithFormat:@"%@", webRequest.URL]);
    return NO;
  }
  return YES;
}
*/

/*
- (void)webViewDidFinishLoad:(UIWebView *)webView {
	NSLog(@"AppDelegate: webViewDidFinishLoad");	
	
	NSString * theString = [webView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('body')"];
	
	if ([theString isEqualToString:@""]) {
		banner.alpha = 0.0;
	}
	NSLog(@"...............theString=%@",theString);
	
}
*/

/*
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
	
	NSLog(@"AppDelegate:didFailLoadWithError: %@", error.description);
	
	//if (error.code == NSURLErrorCancelled) return; 
	
	banner.alpha = 0.0;
}
*/


@end
