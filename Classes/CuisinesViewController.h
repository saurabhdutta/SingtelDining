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

@interface CuisinesViewController : SDViewController<UIPickerViewDelegate> {
   NSMutableArray * cusines;
   SDListView *boxView;
   UIPickerView* picker;
   UIButton * okButton;
   int selectedCusine;
}
-(IBAction) selectCuisine:(id)sender;
@end
