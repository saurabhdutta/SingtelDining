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


@class ARViewController;
@class MapViewController;

@interface CuisinesViewController : SDViewController<UIPickerViewDelegate,UITextFieldDelegate> {
   
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
   BOOL isNearbyRequest;
   UISegmentedControl *viewTypeSegment;
   int defaultSelected;
   BOOL isNearbyRequest;
   HTableView* cardTable;
   NSMutableArray* selectedCards;
}
@property (nonatomic, retain) ARViewController * arView;

-(IBAction) selectCuisine:(id)sender;
- (void) showHidePicker;
- (void) sendURLRequest;
@end
