//
//  AddressAnnotation.m
//  DBSIndulge
//
//  Created by System Administrator on 28/11/2009.
//  Copyright 2009 Cellcity Pte Ltd. All rights reserved.
//

#import "AddressAnnotation.h"


@implementation AddressAnnotation

@synthesize coordinate;
@synthesize mTitle;
@synthesize mSubtitle;
@synthesize annotationType;
@synthesize strImg;
@synthesize mIndex;

- (NSString *) subtitle{
	return mSubtitle;
}

- (NSString *) title{
	return mTitle;
}

- (id) initWithCoordinate:(CLLocationCoordinate2D) c{
	coordinate = c;
	return self;
}

- (void)dealloc {
	[strImg release];
	[mTitle release];
	[mSubtitle release];	
   [super dealloc];
}

@end
