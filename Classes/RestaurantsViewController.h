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
#import "FlurryAPI.h"


@class ARViewController;
@class MapViewController;
@class SDListView;

@interface RestaurantsViewController : SDViewController <UISearchBarDelegate,UIWebViewDelegate> {
  ARViewController * arView;
  NSMutableArray * _ARData;
  MapViewController * mapViewController;
  BOOL showMap;
  HTableView* cardTable;
  NSMutableArray* selectedBanks;
  NSMutableArray* selectedAllBanks;
  UIButton *listMapButton;
  UIButton *arButton;
  SDListView *boxView;
  UISearchBar *searchBar;
	UIWebView * banner;
}

@property (nonatomic, retain) ARViewController * arView;
@property (nonatomic, retain) UIWebView * banner;

- (void) sendURLRequest;
-(void)updateSelectAll;
@end
