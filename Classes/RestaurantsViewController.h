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
@class SDListView;

@interface RestaurantsViewController : SDViewController <UISearchBarDelegate> {
  ARViewController * arView;
  NSMutableArray * _ARData;
  MapViewController * mapViewController;
  BOOL showMap;
  HTableView* cardTable;
  NSMutableArray* selectedBanks;
  UIButton *listMapButton;
  UIButton *arButton;
  SDListView *boxView;
  UISearchBar *searchBar;
}
@property (nonatomic, retain) ARViewController * arView;
- (void) sendURLRequest;
@end
