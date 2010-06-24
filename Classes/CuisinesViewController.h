//
//  CuisinesViewController.h
//  SingtelDining
//
//  Created by Alex Yao on 6/16/10.
//  Copyright 2010 CellCity. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SDViewController.h"
#import "SDListView.h"

@interface CuisinesViewController : SDViewController<UIPickerViewDelegate,UITextFieldDelegate> {
   NSMutableArray * cusines;
   SDListView *boxView;
   UIPickerView* picker;
   UIButton * okButton;
   UIImageView *titleView;
   UITextField *textfield;
   int selectedCusine;
}
-(IBAction) selectCuisine:(id)sender;
- (void) showHidePicker;
@end
