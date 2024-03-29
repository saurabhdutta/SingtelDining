//
//  LocationViewController.h
//  SingtelDining
//
//  Created by Alex Yao on 6/14/10.
//  Copyright 2010 CellCity. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SDViewController.h"
#import "StringTable.h"
#import "SDListView.h"
#import "FlurryAPI.h"

@class ARViewController;
@class MapViewController;
@class HTableView;


@interface LocationViewController : SDViewController<UIPickerViewDelegate,UITextFieldDelegate,UIWebViewDelegate>  {
  ARViewController * arView;
  SDListView *boxView;
  NSMutableArray * tempListings;
  NSMutableArray * locations;
  NSMutableArray * mainLocation;
  NSMutableArray * subLocation;
  UIPickerView* picker;
  UIButton * okButton;
  UITextField *textfield;
  int selectMainLocation;
  int selectSubLocation;
  NSMutableArray * keys;
  NSMutableArray * values;
  NSMutableArray * _ARData;
  MapViewController * mapViewController;
  BOOL showMap;
  int requestType;
  HTableView* cardTable;
  NSMutableArray* selectedBanks;
  NSMutableArray* selectedAllBanks;
  UIButton *listMapButton;
  UIButton *arButton;
  int selectedRow;
  int selectedComponent;
  int selectedSubRow;
  BOOL setListImage;
  int chosenRow;
  int chosenSubRow;
  BOOL cancelClicked;
	
	UIWebView * banner;
}

@property (nonatomic, retain) ARViewController * arView;
@property (nonatomic, retain) UIWebView * banner;

-(IBAction) selectLocation:(id)sender;
- (void) showHidePicker;
- (void) sendURLRequest;
-(void) closeARView:(NSString*) strID;
- (void)updateTable;
-(void)updateSelectAll;
//- (void) setARData:(NSArray*) array;
@end
