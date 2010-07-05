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

@class JSONRequest;

@interface AppDelegate : NSObject <UIApplicationDelegate> {
  NSMutableDictionary *settings;
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
}

- (void) setDelegate:(id) val;
- (id) delegate;
@property (nonatomic, retain) NSMutableDictionary *settings;
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

- (void)loadSettings;
- (void)saveSettings;
- (void) reverseGeoWithLat:(NSString *) latitude andLong:(NSString*) longitude;
@end

