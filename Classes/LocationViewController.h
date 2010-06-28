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



@interface LocationViewController : SDViewController<UIPickerViewDelegate,UITextFieldDelegate>  {
   ARViewController * arView;
   SDListView *boxView;
   NSMutableArray * tempListings;
   NSMutableArray * locations;
   NSMutableArray * mainLocation;
   NSMutableArray * subLocation;
   UIPickerView* picker;
   UIButton * okButton;
   UIImageView *titleView;
   UITextField *textfield;
   int selectMainLocation;
   int selectSubLocation;
   NSString * keys;
   NSString * values;
   NSMutableArray * _ARData;
   MapViewController * mapViewController;
   
   
   
}
@property (nonatomic, retain) ARViewController * arView;
-(IBAction) selectLocation:(id)sender;
- (void) showHidePicker;
//- (void) setARData:(NSArray*) array;
@end
