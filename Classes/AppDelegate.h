//
//  SingtelDiningAppDelegate.h
//  SingtelDining
//
//  Created by Alex Yao on 6/11/10.
//  Copyright 2010 CellCity. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "Reachability.h"
#import <MapKit/MapKit.h>
#import <QuartzCore/QuartzCore.h>
#import "JSONRequestDelegate.h"
#import "HTableDataSource.h"

#import "FlurryAdDelegate.h"

@class JSONRequest;
@class MBProgressHUD;
@class SplashAdViewController;

@interface AppDelegate : NSObject <UIApplicationDelegate, CLLocationManagerDelegate, MKReverseGeocoderDelegate, FlurryAdDelegate> {
  BOOL gpsDone;
  
  NSString * udid;
  CLLocationManager *locationManager;
  NetworkStatus remoteHostStatus;
  NetworkStatus internetConnectionStatus;
  NetworkStatus localWiFiConnectionStatus;
  CLLocationCoordinate2D currentGeo;
  MKReverseGeocoder *reverseGeocoder;
  JSONRequest* request;
  NSString * currentLocation;
  
  NSString * taxiLocation;
  NSString * taxiBuilding;
  NSString * taxiBlock;
  NSString * taxiStreet;
  NSString * taxiPostcode;
  NSString * taxiRef;
  NSString * taxiErrorCode;
  
  id delegateFunc;
  
  HTableDataSource* cardChainDataSource;
  BOOL locationShouldReload;
  BOOL restaurantsShouldReload;
  BOOL cuisineShouldReload;
  BOOL isSupportAR;
  
  MBProgressHUD* hud;
  //UIWebView* banner;
  SplashAdViewController* savc;
  BOOL isSplashAD;
  
  BOOL isLocationServiceAvailiable;
 
  BOOL isNoBanner;
	
	NSInteger pushedTabIndex;
}

- (void) setDelegate:(id) val;
- (id) delegate;
@property (nonatomic, retain) CLLocationManager *locationManager;
@property (nonatomic, retain) NSString * udid;
@property (nonatomic, retain) NSString * currentLocation;
@property (nonatomic, retain) NSString * taxiErrorCode;
@property (nonatomic, retain) NSString * taxiLocation;
@property (nonatomic, retain) NSString * taxiBuilding;
@property (nonatomic, retain) NSString * taxiBlock;
@property (nonatomic, retain) NSString * taxiStreet;
@property (nonatomic, retain) NSString * taxiPostcode;
@property (nonatomic, retain) NSString * taxiRef;
@property (nonatomic, retain) MKReverseGeocoder *reverseGeocoder;;
@property NetworkStatus remoteHostStatus;
@property NetworkStatus internetConnectionStatus;
@property NetworkStatus localWiFiConnectionStatus;
@property CLLocationCoordinate2D currentGeo;

@property (nonatomic, retain) HTableDataSource* cardChainDataSource;
@property (nonatomic, readwrite) BOOL locationShouldReload;
@property (nonatomic, readwrite) BOOL restaurantsShouldReload;
@property (nonatomic, readwrite) BOOL cuisineShouldReload;
@property (nonatomic, readwrite) BOOL isSupportAR;

//@property (nonatomic, retain) UIWebView* banner;
@property (nonatomic, retain) SplashAdViewController* savc;
@property (nonatomic, readwrite) BOOL isSplashAD;

@property (nonatomic, readwrite) BOOL isLocationServiceAvailiable;

- (void)checkOperator;
- (void)getDeviceid;
- (void)updateStatus;
- (void)updateCarrierDataNetworkWarning;
@end

