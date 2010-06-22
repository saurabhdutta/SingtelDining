//
//  GEOLocations.m
//  iPhoneAugmentedRealityLib
//
//  Created by Niels W Hansen on 12/19/09.
//  Copyright 2009 Zac White. All rights reserved.
//

#import "GEOLocations.h"
#import "ARGeoCoordinate.h"
#import <MapKit/MapKit.h>
#import <UIKit/UIKit.h>

@implementation GEOLocations

- (id)init {
	
	locationArray = [[NSMutableArray alloc] initWithCapacity:20];
	[self LoadLocations];
	return self;
}

-(void) LoadLocations {
	
	ARGeoCoordinate *tempCoordinate;
	CLLocation		*tempLocation;
	
	tempLocation = [[CLLocation alloc] initWithLatitude:39.550051 longitude:-105.782067];
	tempCoordinate = [ARGeoCoordinate coordinateWithLocation:tempLocation locationTitle:@"Denver"];
	[locationArray addObject:tempCoordinate];
	[tempLocation release];
	
	tempLocation = [[CLLocation alloc] initWithLatitude:45.523875 longitude:-122.670399];
	tempCoordinate = [ARGeoCoordinate coordinateWithLocation:tempLocation locationTitle:@"Portland"];
	[locationArray addObject:tempCoordinate];
	[tempLocation release];
	
	tempLocation = [[CLLocation alloc] initWithLatitude:41.879535 longitude:-87.624333];
	tempCoordinate = [ARGeoCoordinate coordinateWithLocation:tempLocation locationTitle:@"Chicago"];
	[locationArray addObject:tempCoordinate];
	[tempLocation release];
	
	tempLocation = [[CLLocation alloc] initWithLatitude:30.268735 longitude:-97.745209];
	tempCoordinate = [ARGeoCoordinate coordinateWithLocation:tempLocation locationTitle:@"Austin"];
	[locationArray addObject:tempCoordinate];
	[tempLocation release];
	
	tempLocation = [[CLLocation alloc] initWithLatitude:51.500152 longitude:-0.126236];
	tempCoordinate = [ARGeoCoordinate coordinateWithLocation:tempLocation locationTitle:@"London"];
	tempCoordinate.inclination = M_PI/30;
	[locationArray addObject:tempCoordinate];
	[tempLocation release];
	
	tempLocation = [[CLLocation alloc] initWithLatitude:48.856667 longitude:2.350987];
	tempCoordinate = [ARGeoCoordinate coordinateWithLocation:tempLocation locationTitle:@"Paris"];
	tempCoordinate.inclination = M_PI/30;
	[locationArray addObject:tempCoordinate];
	[tempLocation release];
	
	tempLocation = [[CLLocation alloc] initWithLatitude:55.676294 longitude:12.568116];
	tempCoordinate = [ARGeoCoordinate coordinateWithLocation:tempLocation locationTitle:@"Copenhagen"];
	tempCoordinate.inclination = M_PI/30;
	[locationArray addObject:tempCoordinate];
	[tempLocation release];
	
	tempLocation = [[CLLocation alloc] initWithLatitude:52.373801 longitude:4.890935];
	tempCoordinate = [ARGeoCoordinate coordinateWithLocation:tempLocation locationTitle:@"Amsterdam"];
	tempCoordinate.inclination = M_PI/30;
	[locationArray addObject:tempCoordinate];
	[tempLocation release];
	
	tempLocation = [[CLLocation alloc] initWithLatitude:19.611544 longitude:-155.665283];
	tempCoordinate = [ARGeoCoordinate coordinateWithLocation:tempLocation locationTitle:@"Hawaii"];
	tempCoordinate.inclination = M_PI/30;
	[locationArray addObject:tempCoordinate];
	[tempLocation release];
	
	tempLocation = [[CLLocation alloc] initWithLatitude:-40.900557 longitude:174.885971];
	tempCoordinate = [ARGeoCoordinate coordinateWithLocation:tempLocation locationTitle:@"New Zealand"];
	tempCoordinate.inclination = M_PI/40;
	[locationArray addObject:tempCoordinate];
	[tempLocation release];
	
	tempLocation = [[CLLocation alloc] initWithLatitude:40.756054 longitude:-73.986951];
	tempCoordinate = [ARGeoCoordinate coordinateWithLocation:tempLocation locationTitle:@"New York City"];
	[locationArray addObject:tempCoordinate];
	[tempLocation release];
	
	tempLocation = [[CLLocation alloc] initWithLatitude:42.35892 longitude:-71.05781];
	tempCoordinate = [ARGeoCoordinate coordinateWithLocation:tempLocation locationTitle:@"Boston"];
	[locationArray addObject:tempCoordinate];
	[tempLocation release];
	
	tempLocation = [[CLLocation alloc] initWithLatitude:49.817492 longitude:15.472962];
	tempCoordinate = [ARGeoCoordinate coordinateWithLocation:tempLocation locationTitle:@"Czech Republic"];
	tempCoordinate.inclination = M_PI/30;
	[locationArray addObject:tempCoordinate];
	[tempLocation release];
	
	tempLocation = [[CLLocation alloc] initWithLatitude:53.41291 longitude:-8.24389];
	tempCoordinate = [ARGeoCoordinate coordinateWithLocation:tempLocation locationTitle:@"Ireland"];
	tempCoordinate.inclination = M_PI/30;
	[locationArray addObject:tempCoordinate];
	[tempLocation release];
   
   tempLocation = [[CLLocation alloc] initWithLatitude:38.892091 longitude:-77.024055];
	tempCoordinate = [ARGeoCoordinate coordinateWithLocation:tempLocation locationTitle:@"Washington, DC"];
	[locationArray addObject:tempCoordinate];
	[tempLocation release];
	
	tempLocation = [[CLLocation alloc] initWithLatitude:45.545447 longitude:-73.639076];
	tempCoordinate = [ARGeoCoordinate coordinateWithLocation:tempLocation locationTitle:@"Montreal"];
	[locationArray addObject:tempCoordinate];
	[tempLocation release];
   
	
	tempLocation = [[CLLocation alloc] initWithLatitude:32.78 longitude:-117.15];
	tempCoordinate = [ARGeoCoordinate coordinateWithLocation:tempLocation locationTitle:@"San Diego"];
	[locationArray addObject:tempCoordinate];
	[tempLocation release];
	
	tempLocation = [[CLLocation alloc] initWithLatitude:-40.900557 longitude:174.885971];
	tempCoordinate = [ARGeoCoordinate coordinateWithLocation:tempLocation locationTitle:@"Munich"];
	[locationArray addObject:tempCoordinate];
	[tempLocation release];
	
	tempLocation = [[CLLocation alloc] initWithLatitude:33.5033333 longitude:-117.126611];
	tempCoordinate = [ARGeoCoordinate coordinateWithLocation:tempLocation locationTitle:@"Temecula"];
	[locationArray addObject:tempCoordinate];
	[tempLocation release];
	
	tempLocation = [[CLLocation alloc] initWithLatitude:19.26 longitude:-99.8];
	tempCoordinate = [ARGeoCoordinate coordinateWithLocation:tempLocation locationTitle:@"Mexico City"];
	[locationArray addObject:tempCoordinate];
	[tempLocation release];
   
	tempLocation = [[CLLocation alloc] initWithLatitude:53.566667 longitude:-113.516667];
	tempCoordinate = [ARGeoCoordinate coordinateWithLocation:tempLocation locationTitle:@"Edmonton"];
	[locationArray addObject:tempCoordinate];
	[tempLocation release];
	
	tempLocation = [[CLLocation alloc] initWithLatitude:47.620973 longitude:-122.347276];
	tempCoordinate = [ARGeoCoordinate coordinateWithLocation:tempLocation locationTitle:@"Seattle"];
	[locationArray addObject:tempCoordinate];
	[tempLocation release];
}

-(NSMutableArray*) getLocations 
{
	return locationArray;
}

- (void)dealloc {
	
   [locationArray release];
   [super dealloc];
}


@end
