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

@class ARViewController;
@class MapViewController;
@class HTableView;


@interface LocationViewController : SDViewController<UIPickerViewDelegate,UITextFieldDelegate>  {
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
   NSMutableArray* selectedCards;
   UISegmentedControl *viewTypeSegment;
   int selectedRow;
   int selectedComponent;
   int selectedSubRow;
   BOOL setListImage;
}

@property (nonatomic, retain) ARViewController * arView;
-(IBAction) selectLocation:(id)sender;
- (void) showHidePicker;
- (void) sendURLRequest;
-(void) closeARView:(NSString*) strID;
//- (void) setARData:(NSArray*) array;
@end
