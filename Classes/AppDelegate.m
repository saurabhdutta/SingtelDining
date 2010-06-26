//
//  SingtelDiningAppDelegate.m
//  SingtelDining
//
//  Created by Alex Yao on 6/11/10.
//  Copyright 2010 CellCity. All rights reserved.
//


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
#import "CreditViewController.h"
#import "CreditViewController.h"
#import "LocationViewController.h"
#import "RestaurantsViewController.h"
#import "CuisinesViewController.h"
#import "FavouritesViewController.h"
#import "SearchViewController.h"
#import "DetailsViewController.h"
#import "TwitterViewController.h"


///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
@implementation AppDelegate
@synthesize locationManager, remoteHostStatus, internetConnectionStatus, localWiFiConnectionStatus;
@synthesize currentGeo;

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)applicationDidFinishLaunching:(UIApplication *)application {
  TTNavigator* navigator = [TTNavigator navigator];
  
  
  // add global backgound image
  
  /*UIImageView *backgroundImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 480.0f)];
  backgroundImageView.image = [UIImage imageNamed:@"bg.png"];
  [navigator.window addSubview:backgroundImageView];
  [backgroundImageView release];*/
  
   
   [[Reachability sharedReachability] setHostName:@"www.dc2go.net"];
	[self updateStatus];
   
   gpsDone = FALSE;
   [[self locationManager] startUpdatingLocation];
  
  navigator.window.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg.png"]];
  
  
  // navigationItem background
  
  navigator.persistenceMode = TTNavigatorPersistenceModeNone;

  TTURLMap* map = navigator.URLMap;

  [map from:@"*" toViewController:[TTWebController class]];
  [map from:kAppSplashURLPath toViewController:[SplashViewController class]];
  [map from:kAppRootURLPath toSharedViewController:[TabBarController class]];
  [map from:kAppCreditURLPath toModalViewController:[CreditViewController class]];
  [map from:kAppLocaltionURLPath toViewController:[LocationViewController class]];
  [map from:kAppRestaurantsURLPath toViewController:[RestaurantsViewController class]];
  [map from:kAppCuisinesURLPath toViewController:[CuisinesViewController class]];
  [map from:kAppFavouritesURLPath toViewController:[FavouritesViewController class]];
  [map from:kAppSearchURLPath toViewController:[SearchViewController class]];
  [map from:kAppDetailsURLPath toSharedViewController:[DetailsViewController class]];
  [map from:kAppTwitterURLPath toModalViewController:[TwitterViewController class]];

  if (![navigator restoreViewControllers]) {
    //[navigator openURLAction:[TTURLAction actionWithURLPath:kAppSplashURLPath]];
    [navigator openURLAction:[TTURLAction actionWithURLPath:kAppRootURLPath]];
  }
  
  
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
- (void)loadSettings {
  NSUserDefaults *_settings = [NSUserDefaults standardUserDefaults];
  self.settings = [[NSMutableDictionary alloc] dictionaryWithDictionary:_settings];
}

- (void)saveSettings {
  NSUserDefaults *_settings = [NSUserDefaults standardUserDefaults];
  _settings = self.settings;
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
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"ERR" message: @"ERR" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
		[alert show];	
		[alert release];		
	}
}

- (CLLocationManager *)locationManager {
	
   if (locationManager != nil) {
		return locationManager;
	}
	
	locationManager = [[CLLocationManager alloc] init];
	[locationManager setDesiredAccuracy:kCLLocationAccuracyNearestTenMeters];
	[locationManager setDelegate:self];
	
	return locationManager;
}

- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation {   
   
   NSLog(@"Did update location!\n");
	
	if( !gpsDone ){
		currentGeo = [newLocation coordinate];
      NSLog(@"lat: %+.6f, lng: %+.6f", currentGeo.latitude, currentGeo.longitude);		
		gpsDone = TRUE;      
      NSString *deviceType = [UIDevice currentDevice].model;
      
   }
}

- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error {    
}

@end
