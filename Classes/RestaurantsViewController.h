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
#import "HTableView.h"

@class ARViewController;
@class MapViewController;

@interface RestaurantsViewController : SDViewController {
   ARViewController * arView;
   NSMutableArray * _ARData;
   MapViewController * mapViewController;
  BOOL showMap;
  HTableView* cardTable;
  NSMutableArray* selectedCards;
   UISegmentedControl *viewTypeSegment;
}
@property (nonatomic, retain) ARViewController * arView;
- (void) sendURLRequest;
@end
