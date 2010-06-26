//
//  AddressAnnotation.h
//  DBSIndulge
//
//  Created by System Administrator on 28/11/2009.
//  Copyright 2009 Cellcity Pte Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

typedef enum {
	MapTypeOwn = 0,
	MapTypeOther   = 1,
	MapTypeTP = 2,
	MapTypeUser = 4
} CCMapAnnotationType;

@interface AddressAnnotation : NSObject <MKAnnotation> {
	CLLocationCoordinate2D coordinate;
	NSString *mTitle;
	NSString *mSubtitle;
	CCMapAnnotationType annotationType;
	NSString *strImg;
   NSUInteger mIndex; 
}

@property CLLocationCoordinate2D coordinate;
@property (nonatomic, retain) NSString * mTitle;
@property (nonatomic, retain) NSString * mSubtitle;
@property CCMapAnnotationType annotationType;
@property (nonatomic, retain) NSString * strImg;
@property NSUInteger mIndex;

@end
