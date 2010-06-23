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
   
   boxView.hidden = TRUE;
   
   titleView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 416, 128, 19)];
   titleView.image = [UIImage imageNamed:@"credit-title.png"];
   [self.view addSubview:titleView];
   
   picker = [[UIPickerView alloc] init];
   picker.showsSelectionIndicator = YES;
   picker.delegate = self;
   [picker selectRow:1 inComponent:0 animated:NO];
   picker.hidden = FALSE;
   picker.frame = kPickerOffScreen;
   [self.view addSubview:picker];
   
   okButton = [UIButton buttonWithType:UIButtonTypeCustom];
   [okButton setFrame:CGRectMake(250, 250, 57, 30)];
   //[okButton setTitle:@"Done" forState:UIControlStateNormal];
   [okButton setBackgroundImage:[UIImage imageNamed:@"button-done.png"] forState:UIControlStateNormal];
   [okButton addTarget:self action:@selector(selectCuisine:) forControlEvents:UIControlEventTouchUpInside];
   [self.view addSubview:okButton];
   
   [self showHidePicker];

}

#pragma mark action methods

-(IBAction) selectCuisine:(id)sender
{
   switch (selectedCusine) {
      case CUISINE_ALL:
         NSLog(@"Selected All Cusines!");
         break;
      case CUISINE_CHINESE:
         NSLog(@"Selected Chinese Cusines!");
         break;
      case CUISINE_KOREAN:
         NSLog(@"Selected Korean Cusines!");
         break;
      case CUISINE_JAPANESE:
         NSLog(@"Selected Japanese Cusines!");
         break;
      case CUISINE_INDIAN:
         NSLog(@"Selected Indian Cusines!");
         break;
      default:
         NSLog(@"selection Invalid! Selected Default All instead!");
         break;
   }
   
   
   [self showHidePicker];
   
   boxView.hidden = FALSE;
   
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
   } else { // on screen, show a done button
      titleView.frame = CGRectMake(0, 0, 128, 19);
      picker.frame = kPickerOnScreen;
      [okButton setFrame:CGRectMake(250, 250, 57, 30)];
   }
   [UIView commitAnimations];
}


- (void) dealloc
{
   [picker release];
   [titleView release];
   [super dealloc];
}

#pragma mark picker view delegates

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView;

{
   return 1;
   
}



- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
   selectedCusine = row;
   
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component;

{
   return [cusines count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component;

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
