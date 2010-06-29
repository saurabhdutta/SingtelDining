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
#import "JSONRequest.h"


///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
@implementation AppDelegate
@synthesize locationManager, remoteHostStatus, internetConnectionStatus, localWiFiConnectionStatus;
@synthesize currentGeo,udid, currentLocation, reverseGeocoder;
@synthesize  taxiBuilding, taxiBlock, taxiStreet, taxiPostcode, taxiLocation, taxiErrorCode,taxiRef;

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)applicationDidFinishLaunching:(UIApplication *)application {
   TTNavigator* navigator = [TTNavigator navigator];
   
   
   // add global backgound image
   
   /*UIImageView *backgroundImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 480.0f)];
    backgroundImageView.image = [UIImage imageNamed:@"bg.png"];
    [navigator.window addSubview:backgroundImageView];
    [backgroundImageView release];*/
   [self getDeviceid];
   
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
		//currentGeo.latitude = kTestLatitude;
		//currentGeo.longitude = kTestLongitude;
      NSLog(@"lat: %+.6f, lng: %+.6f", currentGeo.latitude, currentGeo.longitude);		
		gpsDone = TRUE;      
      NSString *deviceType = [UIDevice currentDevice].model;
      NSLog(@"Device Type: %s\n",[deviceType UTF8String]);
		
      [self reverseGeoWithLat:[NSString stringWithFormat:@"%f",currentGeo.latitude] andLong:[NSString stringWithFormat:@"%f",currentGeo.longitude]];
      
      if ( [delegateFunc respondsToSelector:@selector(updateTable)] ) 
      {
         [delegateFunc updateTable];
      }
		
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
}

- (void) reverseGeoWithLat:(NSString *) latitude andLong:(NSString*) longitude{
	

 

	
	NSLog(@"%@ %@ %@", latitude, longitude, self.udid);
	
	NSArray *keys = [NSArray arrayWithObjects: @"msisdn", @"latitude", @"longitude", @"deviceid", nil];
	NSArray *values = [NSArray arrayWithObjects: @"", [NSString stringWithFormat:@"%f",latitude], [NSString stringWithFormat:@"%f",longitude], self.udid, nil];
	
	if( request == nil ) request = [[JSONRequest alloc] initWithOwner:self];
	
	[request loadData:URL_REVERSE_GEO pkeys:keys pvalues:values isXML: FALSE]; 
}

- (void)reverseGeocoder:(MKReverseGeocoder *)geocoder didFailWithError:(NSError *)error{   
	self.currentLocation = self.taxiLocation;
	[self.currentLocation retain];
}

- (void)reverseGeocoder:(MKReverseGeocoder *)geocoder didFindPlacemark:(MKPlacemark *)placemark{
	self.currentLocation = [NSString stringWithFormat:@"%@ %@, %@", placemark.subThoroughfare, placemark.thoroughfare, placemark.country];
	[self.currentLocation retain];
	
	NSLog(self.currentLocation);
}

- (void) onDataLoad: (NSArray *) dics{
	gpsDone = TRUE;
	
	if( [dics objectForKey:@"error"] != nil && (NSNull *) [dics objectForKey:@"error"] != [NSNull null] &&
	   ![[dics objectForKey:@"error"] isEqualToString:@""] ){
		
		self.taxiErrorCode = [dics objectForKey:@"error"];
		[self.taxiErrorCode retain];
		
		self.taxiLocation = @"";
		[self.taxiLocation retain];
		
		self.taxiBuilding = @"";
		[self.taxiBuilding retain];
		
		self.taxiBlock = @"";
		[self.taxiBlock retain];
		
		self.taxiStreet = @"";
		[self.taxiStreet retain];
		
		self.taxiPostcode = @"";
		[self.taxiPostcode retain];
		
		self.taxiLocation = @"";
		[self.taxiLocation retain];
	}
	else{   
		NSArray * addresses = [dics objectForKey:@"addresses"];
		if( addresses != nil && (NSNull *) addresses != [NSNull null] && [addresses count]> 0){
			NSDictionary * addr = nil;
			
			if([[addresses objectForKey:@"address"] isKindOfClass:[NSDictionary class]]) addr = [addresses objectForKey:@"address"];
			else addr = [[addresses objectForKey:@"address"] objectAtIndex: 0];
			
			NSString * strAddress = @"";
			
			if([addr objectForKey:@"buildingname"] != nil && (NSNull *) [addr objectForKey:@"buildingname"] != [NSNull null] 
			   && ![[addr objectForKey:@"buildingname"] isEqualToString:@""]){
				strAddress = [addr objectForKey:@"buildingname"];
				
				self.taxiBuilding = [addr objectForKey:@"buildingname"];
				[self.taxiBuilding retain];
			}
			
			if([addr objectForKey:@"block"] != nil && (NSNull *) [addr objectForKey:@"block"] != [NSNull null] 
			   && ![[addr objectForKey:@"block"] isEqualToString:@""]){
				if( [strAddress isEqualToString:@""] ) strAddress = [addr objectForKey:@"block"];
				else strAddress = [strAddress stringByAppendingFormat:@", %@", [addr objectForKey:@"block"]];
				
				self.taxiBlock = [addr objectForKey:@"block"];
				[self.taxiBlock retain];
			}
			
			if([addr objectForKey:@"road"] != nil && (NSNull *) [addr objectForKey:@"road"] != [NSNull null] 
			   && ![[addr objectForKey:@"road"] isEqualToString:@""]){
				if( [strAddress isEqualToString:@""] ) strAddress = [addr objectForKey:@"road"];
				else strAddress = [strAddress stringByAppendingFormat:@" %@", [addr objectForKey:@"road"]];
				
				self.taxiStreet = [addr objectForKey:@"road"];
				[self.taxiStreet retain];
			}
			
			if([addr objectForKey:@"postalcode"] != nil && (NSNull *) [addr objectForKey:@"postalcode"] != [NSNull null] 
			   && ![[addr objectForKey:@"postalcode"] isEqualToString:@""]){
				if( [strAddress isEqualToString:@""] ) strAddress = [NSString stringWithFormat:@"Singapore ", [addr objectForKey:@"postalcode"]];
				else strAddress = [strAddress stringByAppendingFormat:@", Singapore %@", [addr objectForKey:@"postalcode"]];
				
				self.taxiPostcode = [addr objectForKey:@"postalcode"];
				[self.taxiPostcode retain];
			}
			
			self.taxiLocation = strAddress;
			[self.taxiLocation retain];
			
			NSLog(self.currentLocation);
			
			if([addr objectForKey:@"addressreference"] != nil && (NSNull *) [addr objectForKey:@"addressreference"] != [NSNull null] 
			   && ![[addr objectForKey:@"addressreference"] isEqualToString:@""]){
				self.taxiRef = [addr objectForKey:@"addressreference"];         
			}
			else self.taxiRef = @"";
			
			[self.taxiRef retain];
			
			self.taxiErrorCode = @"-1";
			[self.taxiErrorCode retain];
		}
	}
	
	self.reverseGeocoder = [[[MKReverseGeocoder alloc] initWithCoordinate: currentGeo] autorelease];
	reverseGeocoder.delegate = self;      
	[reverseGeocoder start];
}

- (void) onErrorLoad{
	gpsDone = TRUE;
	self.taxiLocation = @"";
	[self.taxiLocation retain];
	
	self.taxiBuilding = @"";
	[self.taxiBuilding retain];
	
	self.taxiBlock = @"";
	[self.taxiBlock retain];
	
	self.taxiStreet = @"";
	[self.taxiStreet retain];
	
	self.taxiPostcode = @"";
	[self.taxiPostcode retain];
	
	self.taxiLocation = @"";
	[self.taxiLocation retain];
	
	self.reverseGeocoder = [[[MKReverseGeocoder alloc] initWithCoordinate: currentGeo] autorelease];
	reverseGeocoder.delegate = self;      
	[reverseGeocoder start];
}

- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error {    
}



@end
