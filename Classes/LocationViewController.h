//
//  LocationViewController.h
//  SingtelDining
//
//  Created by Alex Yao on 6/14/10.
//  Copyright 2010 CellCity. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import "SDViewController.h"
#import "StringTable.h"
#import "SDListView.h"

@class ARViewController;



@interface LocationViewController : SDViewController<UIPickerViewDelegate,UITextFieldDelegate>  {
   ARViewController * arView;
   SDListView *boxView;
   NSMutableArray * tempListings;
   NSDictionary * locations;
   NSMutableArray * mainLocation;
   NSMutableArray * subLocation;
   UIPickerView* picker;
   UIButton * okButton;
   UIImageView *titleView;
   UITextField *textfield;
   
}
@property (nonatomic, retain) ARViewController * arView;
-(IBAction) selectLocation:(id)sender;
- (void) showHidePicker;
@end
