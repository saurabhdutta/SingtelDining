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
   
   picker = [[UIPickerView alloc] init];
   picker.showsSelectionIndicator = YES;
   picker.delegate = self;
   [picker selectRow:1 inComponent:0 animated:NO];
   picker.hidden = FALSE;
   [self.view addSubview:picker];
   [picker release];
   
   okButton = [UIButton buttonWithType:UIButtonTypeCustom];
   [okButton setFrame:CGRectMake(250, 250, 57, 30)];
   [okButton setBackgroundImage:[UIImage imageNamed:@"button-blank.png"] forState:UIControlStateNormal];
   [okButton addTarget:self action:@selector(selectCuisine:) forControlEvents:UIControlEventTouchUpInside];
   [self.view addSubview:okButton];
   
   
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
   
   picker.hidden = TRUE;
   
   boxView.hidden = FALSE;
   okButton.hidden = TRUE;
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
