//
//  ARGeoCoordinate.m
//  iPhoneAugmentedRealityLib
//
//  Created by Haseman on 8/1/09.
//  Copyright 2009 Zac White. All rights reserved.
//

#import "ARGeoCoordinate.h"

@implementation ARGeoCoordinate

@synthesize geoLocation;

- (float)angleFromCoordinate:(CLLocationCoordinate2D)first toCoordinate:(CLLocationCoordinate2D)second {
	
	float longitudinalDifference	= second.longitude - first.longitude;
	float latitudinalDifference		= second.latitude  - first.latitude;
	float possibleAzimuth			= (M_PI * .5f) - atan(latitudinalDifference / longitudinalDifference);
	
	if (longitudinalDifference > 0) 
		return possibleAzimuth;
	else if (longitudinalDifference < 0) 
		return possibleAzimuth + M_PI;
	else if (latitudinalDifference < 0) 
		return M_PI;
	
	return 0.0f;
}

- (void)calibrateUsingOrigin:(CLLocation *)origin {
	
	if (![self geoLocation]) 
		return;
	
	double baseDistance = [origin getDistanceFrom:[self geoLocation]];
	[self setRadialDistance: sqrt(pow([origin altitude] - [[self geoLocation] altitude], 2) + pow(baseDistance, 2))];
	
	float angle = sin(ABS([origin altitude] - [[self geoLocation] altitude]) / [self radialDistance]);
	
	if ([origin altitude] > [[self geoLocation] altitude]) 
		angle = -angle;
	
	[self setInclination: angle];
	[self setAzimuth: [self angleFromCoordinate:[origin coordinate] toCoordinate:[[self geoLocation] coordinate]]];
	
	NSLog(@"distance is %d, angle is %d, azimuth is %d",baseDistance,angle,[self azimuth]);
}

+ (ARGeoCoordinate *)coordinateWithLocation:(CLLocation *)location locationTitle:(NSString *) titleOfLocation {
   
	ARGeoCoordinate *newCoordinate	= [[ARGeoCoordinate alloc] init];
	[newCoordinate setGeoLocation: location];
	[newCoordinate setTitle: titleOfLocation];
	
	return [newCoordinate autorelease];
}

+ (ARGeoCoordinate *)coordinateWithLocation:(CLLocation *)location fromOrigin:(CLLocation *)origin {
	
	ARGeoCoordinate *newCoordinate = [ARGeoCoordinate coordinateWithLocation:location locationTitle:@""];
	[newCoordinate calibrateUsingOrigin:origin];
	return newCoordinate;
}

@end
