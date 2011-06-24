//
//  AdvanceSearchViewController.h
//  SingtelDining
//
//  Created by Alex Yao Cheng on 7/5/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SDViewController.h"


@interface AdvanceSearchViewController : SDViewController <UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource> {
	UITextField* keywordField;
	UITextField* locationField;
	UITextField* cuisineField;
	UIPickerView* locationPicker;
	UIPickerView* cuisinePicker;
	
	NSMutableArray* locationData;
	NSMutableArray* cuisineData;
	NSMutableArray* subLocations;
	
	NSMutableDictionary* query;
	NSMutableArray* selectedBanks;
	NSMutableArray* selectedAllBanks;
}

-(void)updateSelectAll;

@end
