//
//  CuisinesViewController.m
//  SingtelDining
//
//  Created by Alex Yao on 6/16/10.
//  Copyright 2010 CellCity. All rights reserved.
//

#import "CuisinesViewController.h"
#import "ListDataSource.h"
#import "PickerDataSource.h"


@implementation CuisinesViewController

#pragma mark -

- (void)loadView {
  [super loadView];
   cusines = [[NSMutableArray alloc] init];
   [cusines addObject:@" All "];
   [cusines addObject:@" Chinese "];
   [cusines addObject:@" Korean "];
   [cusines addObject:@" Japanese "];
   [cusines addObject:@" Indian "];
   
   
   
  boxView = [[SDListView alloc] initWithFrame:CGRectMake(5, 0, 310, 305)];
  
  {
    self.tableView.frame = CGRectMake(5, 40, 300, 280);
    self.tableView.backgroundColor = [UIColor clearColor];
    
    [boxView addSubview:self.tableView];
  }
  
  [self.view addSubview:boxView];
  [boxView release];
   
   boxView.hidden = FALSE;
   
   titleView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 416, 128, 19)];
   titleView.image = [UIImage imageNamed:@"credit-title.png"];
   [self.view addSubview:titleView];
   
   picker = [[UIPickerView alloc] init];
   picker.showsSelectionIndicator = YES;
   picker.delegate = self;
   [picker selectRow:0 inComponent:0 animated:NO];
   picker.hidden = FALSE;
   picker.frame = kPickerOffScreen;
   [self.view addSubview:picker];
   
   okButton = [UIButton buttonWithType:UIButtonTypeCustom];
   [okButton setFrame:CGRectMake(250, 416, 57, 30)];
   //[okButton setTitle:@"Done" forState:UIControlStateNormal];
   [okButton setBackgroundImage:[UIImage imageNamed:@"button-done.png"] forState:UIControlStateNormal];
   [okButton addTarget:self action:@selector(selectCuisine:) forControlEvents:UIControlEventTouchUpInside];
   [self.view addSubview:okButton];
   
   textfield = [[UITextField alloc] initWithFrame:CGRectMake(60, 7, 140, 18)];
   textfield.text = @"Cuisine-Chinese";
   textfield.delegate = self;
   textfield.font = [UIFont systemFontOfSize:14];
   textfield.backgroundColor = [UIColor clearColor];
   textfield.textColor = [UIColor redColor];
   textfield.hidden = FALSE;
   
   [textfield addTarget:self action:@selector(showHidePicker) forControlEvents:UIControlEventTouchDown];
   [self.view addSubview:textfield];
   [textfield release];
   
   

}

#pragma mark action methods

-(IBAction) selectCuisine:(id)sender
{
   switch (selectedCusine) {
      case CUISINE_ALL:
         NSLog(@"Selected All Cusines!");
         textfield.text = @"Cuisine-All";
         break;
      case CUISINE_CHINESE:
         NSLog(@"Selected Chinese Cusines!");
         textfield.text = @"Cuisine-Chinese";
         break;
      case CUISINE_KOREAN:
         NSLog(@"Selected Korean Cusines!");
         textfield.text = @"Cuisine-Korean";
         break;
      case CUISINE_JAPANESE:
         NSLog(@"Selected Japanese Cusines!");
         textfield.text = @"Cuisine-Japanese";
         break;
      case CUISINE_INDIAN:
         NSLog(@"Selected Indian Cusines!");
         textfield.text = @"Cuisine-Indian";
         break;
      default:
         NSLog(@"selection Invalid! Selected Default All instead!");
         break;
   }
   
   
   [self showHidePicker];
   
   
   
}

- (void) showHidePicker
{
   // Picker View Show in animation
   
   
   [UIView beginAnimations:@"CalendarTransition" context:nil];
   [UIView setAnimationDuration:0.3];
   if(picker.frame.origin.y < kPickerOffScreen.origin.y) { // off screen
      picker.frame = kPickerOffScreen;
      titleView.frame = CGRectMake(0, 416, 128, 19);
      [okButton setFrame:CGRectMake(250, 416, 57, 30)];
      boxView.hidden = FALSE;
      textfield.hidden = FALSE;
   } else { // on screen, show a done button
      titleView.frame = CGRectMake(0, 0, 128, 19);
      picker.frame = kPickerOnScreen;
      //picker.dataSource = [[PickerDataSource alloc] init];
      [okButton setFrame:CGRectMake(250, 250, 57, 30)];
      boxView.hidden = TRUE;
      textfield.hidden = TRUE;
   }
   [UIView commitAnimations];
}


- (void) dealloc
{
   [picker release];
   [titleView release];
   [super dealloc];
}

#pragma mark textfield delegates

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField 
{
   return NO;
}

#pragma mark picker view delegates

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView

{
   return 1;
   
}



- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
   selectedCusine = row;
   
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component

{
   return [cusines count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component

{
   return [cusines objectAtIndex:row];
}

#pragma mark tableView delegates

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)createModel {
  self.dataSource = [[[ListDataSource alloc] initWithType:@"any"] autorelease];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (id<UITableViewDelegate>)createDelegate {
  return [[[TTTableViewDragRefreshDelegate alloc] initWithController:self] autorelease];
}

@end
