//
//  GEOLocations.h
//  iPhoneAugmentedRealityLib
//
//  Created by Niels W Hansen on 12/19/09.
//  Copyright 2009 Agilite Software. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ARCoordinate;

@interface GEOLocations : NSObject {
	
	NSMutableArray *locationArray;
	
}

- (id)init;
-(void) LoadLocations;
-(NSMutableArray*) getLocations;



@end
