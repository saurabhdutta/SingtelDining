//
//  SingtelDiningAppDelegate.h
//  SingtelDining
//
//  Created by Alex Yao on 6/11/10.
//  Copyright 2010 CellCity. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>
#import "Reachability.h"

@interface AppDelegate : NSObject <UIApplicationDelegate> {
  NSMutableDictionary *settings;
   BOOL gpsDone;
   
   CLLocationManager *locationManager;	
   NetworkStatus remoteHostStatus;
   NetworkStatus internetConnectionStatus;
   NetworkStatus localWiFiConnectionStatus;
   CLLocationCoordinate2D currentGeo;
}
@property (nonatomic, retain) NSMutableDictionary *settings;
@property (nonatomic, retain) CLLocationManager *locationManager;
@property NetworkStatus remoteHostStatus;
@property NetworkStatus internetConnectionStatus;
@property NetworkStatus localWiFiConnectionStatus;
@property CLLocationCoordinate2D currentGeo;

- (void)loadSettings;
- (void)saveSettings;

@end

