//
//  AdvanceSearchViewController.h
//  SingtelDining
//
//  Created by Alex Yao Cheng on 7/5/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface AdvanceSearchViewController : TTViewController <UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource> {
  UITextField* keywordField;
  UITextField* locationField;
  UITextField* cuisineField;
  UIPickerView* locationPicker;
  UIPickerView* cuisinePicker;
  
  NSArray* locationData;
  NSArray* cuisineData;
  NSMutableArray* subLocations;
  
  NSMutableDictionary* query;
}

@end
