//
//  SingtelDiningAppDelegate.m
//  SingtelDining
//
//  Created by Alex Yao on 6/11/10.
//  Copyright 2010 CellCity. All rights reserved.
//

static NSString *checkOperatorURL = @"http://uob.dc2go.net/singtel/get_detail.php?id=3";

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


///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
@implementation AppDelegate
@synthesize locationManager, remoteHostStatus, internetConnectionStatus, localWiFiConnectionStatus;
@synthesize currentGeo,udid, currentLocation, reverseGeocoder;
@synthesize  taxiBuilding, taxiBlock, taxiStreet, taxiPostcode, taxiLocation, taxiErrorCode,taxiRef;
@synthesize cardChainDataSource;
@synthesize locationShouldReload, restaurantsShouldReload, cuisineShouldReload;

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)applicationDidFinishLaunching:(UIApplication *)application {
  TTNavigator* navigator = [TTNavigator navigator];
  
  
  // check operator
  [self checkOperator];
  
  [self getDeviceid];
  
  [[Reachability sharedReachability] setHostName:@"www.dc2go.net"];
	[self updateStatus];
  
  gpsDone = FALSE;
  [[self locationManager] startUpdatingLocation];
  
  navigator.window.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg.png"]];
  
  
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
  [map from:kAppFavouritesURLPath toViewController:[FavouritesViewController class]];
  [map from:kAppSearchURLPath toViewController:[AdvanceSearchViewController class]];
  [map from:kAppResultURLPath toViewController:[SearchViewController class]];
  [map from:kAppDetailsURLPath toSharedViewController:[DetailsViewController class]];
  [map from:kAppTwitterURLPath toModalViewController:[TwitterViewController class]];
  
  //if (![navigator restoreViewControllers]) {
//    //[navigator openURLAction:[TTURLAction actionWithURLPath:kAppSplashURLPath]];
//    [navigator openURLAction:[TTURLAction actionWithURLPath:kAppRootURLPath]];
//  }
  
  HTableDataSource *ds = [[HTableDataSource alloc] init];
  self.cardChainDataSource = ds;
  [ds release];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (BOOL)navigator:(TTNavigator*)navigator shouldOpenURL:(NSURL*)URL {
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
  TTURLRequest* checkRequest = [TTURLRequest requestWithURL:checkOperatorURL delegate:self];
  checkRequest.cachePolicy = TTURLRequestCachePolicyNoCache;
  checkRequest.response = [[[TTURLJSONResponse alloc] init] autorelease];
  [checkRequest send];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)requestDidFinishLoad:(TTURLRequest*)checkRequest {
  NSLog(@"checkOperator requestDidFinishLoad");
  if ([checkRequest.urlPath isEqualToString:checkOperatorURL]) {
    
    TTURLJSONResponse* response = checkRequest.response;
    TTDASSERT([response.rootObject isKindOfClass:[NSDictionary class]]);
    
    NSDictionary* feed = response.rootObject;
    //NSLog(@"feed: %@",feed);
    TTDASSERT([[feed objectForKey:@"allow"] isKindOfClass:[NSString class]]);
    
    if (![[feed objectForKey:@"allow"] isEqualToString:@"yes"]) {
      //[[TTNavigator navigator] openURLAction:[TTURLAction actionWithURLPath:kAppBlockURLPath]];
    }
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
  
  CLLocationCoordinate2D newCoordinate = [newLocation coordinate];
  if ( (newCoordinate.latitude == currentGeo.latitude) && (newCoordinate.longitude == currentGeo.longitude)) {
    // same coordinate, do nothing
  } else {
    currentGeo = [newLocation coordinate];
    NSLog(@"lat: %+.6f, lng: %+.6f", currentGeo.latitude, currentGeo.longitude);
    
    self.reverseGeocoder = [[[MKReverseGeocoder alloc] initWithCoordinate: currentGeo] autorelease];
    reverseGeocoder.delegate = self;
    [reverseGeocoder start];
  }
  
  [[TTNavigator navigator] openURLAction:[TTURLAction actionWithURLPath:kAppRootURLPath]];
}


- (void) getDeviceid{
	UIDevice *device = [UIDevice currentDevice];
	NSString *uniqueIdentifier = [device uniqueIdentifier];
	NSString *dName = [device name];
	
	udid = [NSString stringWithFormat:@"%@_%@", dName, uniqueIdentifier ];
	NSLog(@"udid is %@", udid);
	//udid = @"ccdebug";
	[udid retain];
}

- (void)reverseGeocoder:(MKReverseGeocoder *)geocoder didFailWithError:(NSError *)error{   
	self.currentLocation = self.taxiLocation;
	[self.currentLocation retain];
  NSLog(@"reverseGeocoder didFailWithError: %@", error);
  [self googleReverseGeocoderWithCoordinate:currentGeo];
}

- (void)reverseGeocoder:(MKReverseGeocoder *)geocoder didFindPlacemark:(MKPlacemark *)placemark{
	self.currentLocation = [NSString stringWithFormat:@"%@ %@, %@", placemark.subThoroughfare, placemark.thoroughfare, placemark.country];
	[self.currentLocation retain];
	
	NSLog(@"reverseGeocoder didFindPlacemark: %@",self.currentLocation);
}

- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error {    
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

@end
