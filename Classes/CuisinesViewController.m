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
- (IBAction)selectCard:(id)sender {
   
   [sender setHighlighted:YES];
}

#pragma mark -

- (void)loadView {
  [super loadView];
   NSString *path = [[NSBundle mainBundle] pathForResource:@"Food" ofType:@"plist"];
   
   
   cusines = [[NSArray alloc]initWithContentsOfFile:path];
   
   
   
   boxView = [[SDListView alloc] initWithFrame:CGRectMake(5, 0, 310, 275)];
  
  {
    self.tableView.frame = CGRectMake(5, 40, 300, 230);
    self.tableView.backgroundColor = [UIColor clearColor];
    
    [boxView addSubview:self.tableView];
  }
  
  [self.view addSubview:boxView];
  [boxView release];
  
  // cards box
  UIScrollView *cardBox = [[UIScrollView alloc] initWithFrame:CGRectMake(45, 284, 270, 75)];
  cardBox.backgroundColor = [UIColor whiteColor];
  cardBox.layer.cornerRadius = 6;
  cardBox.layer.masksToBounds = YES;
  cardBox.scrollEnabled = YES;
  {
    // setting button
    UIButton *settingButton = [[UIButton alloc] initWithFrame:CGRectMake(5, 284, 34, 75)];
    [settingButton setImage:[UIImage imageNamed:@"button-setting.png"] forState:UIControlStateNormal];
    [settingButton addTarget:kAppCreditURLPath action:@selector(openURLFromButton:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barSettingButton = [[UIBarButtonItem alloc] initWithCustomView:settingButton];
    [settingButton release];
    [self.view addSubview:settingButton];
    [barSettingButton release];
    
    NSMutableArray *selectedCardList = [NSMutableArray array];
    NSDictionary *cardList = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"CreditCard" ofType:@"plist"]];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *selectedCards = [defaults objectForKey:K_UD_SELECT_CARDS];
    NSArray *bankKeys = [[selectedCards allKeys] sortedArrayUsingSelector:@selector(compare:)];
    for (NSString *bankName in bankKeys) {
      NSArray *selected = [selectedCards objectForKey:bankName];
      for (id index in selected) {
        NSArray *cardInBank = [cardList objectForKey:bankName];
        NSDictionary *card = [cardInBank objectAtIndex:[(NSNumber*)index intValue]];
        [selectedCardList addObject:card];
      }
    }
    
    int i = 0;
    for (NSDictionary *card in selectedCardList) {
      UIButton *cardButton = [[UIButton alloc] init];
      [cardButton setImage:[UIImage imageNamed:[card objectForKey:@"Icon"]] forState:UIControlStateNormal];
      [cardButton setImage:[UIImage imageNamed:[card objectForKey:@"Icon"]] forState:UIControlStateSelected];
      [cardButton addTarget:self action:@selector(selectCard:) forControlEvents:UIControlEventTouchUpInside];
      cardButton.frame = CGRectMake(95*i + 5, 7, 95, 60);
      cardButton.tag = i;
      [cardBox addSubview:cardButton];
      TT_RELEASE_SAFELY(cardButton);
      i ++;
    }
    [cardBox setContentInset:UIEdgeInsetsMake(0, 5, 0, 5)];
    [cardBox setContentSize:CGSizeMake(95*i+10, 45)];
  }
  [self.view addSubview:cardBox];
  TT_RELEASE_SAFELY(cardBox);
   
   boxView.hidden = FALSE;
   
   titleView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 416, 128, 19)];
   titleView.image = [UIImage imageNamed:@"credit-title.png"];
   [self.view addSubview:titleView];
   
   picker = [[UIPickerView alloc] init];
   picker.showsSelectionIndicator = YES;
   picker.delegate = self;
   [picker selectRow:4 inComponent:0 animated:NO];
   picker.hidden = FALSE;
   picker.frame = kPickerOffScreen;
   [self.view addSubview:picker];
   
   okButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 57, 30)];
   [okButton setImage:[UIImage imageNamed:@"button-done.png"] forState:UIControlStateNormal];
   [okButton addTarget:self action:@selector(selectCuisine:) forControlEvents:UIControlEventTouchDown];
   UIBarButtonItem *barDoneButton = [[UIBarButtonItem alloc] initWithCustomView:okButton];
   okButton.hidden = TRUE;
   [okButton release];
   self.navigationItem.rightBarButtonItem = barDoneButton;
   [barDoneButton release];
   
   textfield = [[UITextField alloc] initWithFrame:CGRectMake(50, 7, 140, 18)];
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
   textfield.text = [NSString stringWithFormat:@"Cuisine-%@",[[cusines objectAtIndex:selectedCusine] objectForKey:@"Name"]];
   
   
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
      okButton.hidden = TRUE;
      boxView.hidden = FALSE;
      textfield.hidden = FALSE;
   } else { // on screen, show a done button
      titleView.frame = CGRectMake(0, 0, 128, 19);
      picker.frame = kPickerOnScreen;
      //picker.dataSource = [[PickerDataSource alloc] init];
      okButton.hidden = FALSE;
      boxView.hidden = TRUE;
      textfield.hidden = TRUE;
   }
   [UIView commitAnimations];
   
   NSString * keys = [NSArray arrayWithObjects: @"cuisineTypeID",@"pageNum", @"resultsPerPage", 
           nil];
   
   NSString * values = [NSArray arrayWithObjects: [[cusines objectAtIndex:selectedCusine] objectForKey:@"ID"] ,
             @"1",@"10",
             nil];
   
   self.dataSource  = [[[ListDataSource alloc] initWithType:@"Cuisine" andSortBy:@"Cuisine" withKeys: keys andValues: values] autorelease];
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
   return [[cusines objectAtIndex:row] objectForKey:@"Name"];
}

#pragma mark tableView delegates

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)createModel {
   
   NSString *keys = [NSArray arrayWithObjects: @"cuisineTypeID",@"pageNum", @"resultsPerPage", 
           nil];
   
   NSString *values = [NSArray arrayWithObjects: @"5",
             @"1",@"10",
             nil];
   
   self.dataSource  = [[[ListDataSource alloc] initWithType:@"Cuisine" andSortBy:@"Cuisine" withKeys: keys andValues: values] autorelease];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (id<UITableViewDelegate>)createDelegate {
  return [[[TTTableViewDragRefreshDelegate alloc] initWithController:self] autorelease];
}

@end
