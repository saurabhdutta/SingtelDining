//
//  RestaurantsViewController.h
//  SingtelDining
//
//  Created by Alex Yao on 6/16/10.
//  Copyright 2010 CellCity. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import "SDViewController.h"

@class ARViewController;


@interface RestaurantsViewController : SDViewController {
   ARViewController * arView;
   NSMutableArray * _ARData;
}
@property (nonatomic, retain) ARViewController * arView;
@end
