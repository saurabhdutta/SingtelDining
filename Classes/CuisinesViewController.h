//
//  CuisinesViewController.h
//  SingtelDining
//
//  Created by Alex Yao on 6/16/10.
//  Copyright 2010 CellCity. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import "SDViewController.h"
#import "SDListView.h"
#import "HTableView.h"
#import "FlurryAPI.h"


@class ARViewController;
@class MapViewController;

@interface CuisinesViewController : SDViewController<UIPickerViewDelegate,UITextFieldDelegate,UIWebViewDelegate> {

  ARViewController * arView;
  NSMutableArray * cusines;
  SDListView *boxView;
  UIPickerView* picker;
  UIButton * okButton;
  //UIImageView *titleView;
  UITextField *textfield;
  int selectedCusine;
  NSMutableArray * _ARData;
  MapViewController * mapViewController;
  BOOL showMap;
  UIButton *listMapButton;
  UIButton *arButton;
  int defaultSelected;
  BOOL isNearbyRequest;
  HTableView* cardTable;
  NSMutableArray* selectedBanks;
  NSMutableArray* selectedAllBanks;
  int selectedRow;
	
	UIWebView * banner;
}
@property (nonatomic, retain) ARViewController * arView;
@property (nonatomic, retain) UIWebView * banner;

-(IBAction) selectCuisine:(id)sender;
- (void) showHidePicker;
- (void) sendURLRequest;
-(void)updateSelectAll;
@end
