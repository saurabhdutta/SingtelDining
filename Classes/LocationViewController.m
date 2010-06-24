//
//  LocationViewController.m
//  SingtelDining
//
//  Created by Alex Yao on 6/14/10.
//  Copyright 2010 CellCity. All rights reserved.
//

#import "LocationViewController.h"
#import "ListDataSource.h"
#import "ARViewController.h"



@implementation LocationViewController
@synthesize arView;
#pragma mark -

- (void)backButtonClicked:(id)sender {
  [self.navigationController.navigationBar popNavigationItemAnimated:YES];
}

- (void)toggleListView:(id)sender {
  NSLog(@"toggle %i", [sender selectedSegmentIndex]);
   UIView *mapView;
   
   mapView = [[self.view viewWithTag:100] viewWithTag:1002];
  
  self.tableView.hidden = mapView.hidden;
   self.variableHeightRows = YES;
  mapView.hidden = !self.tableView.hidden;
   if(([sender selectedSegmentIndex] == 1) && mapView.hidden == FALSE)
   {
      printf("showing AR View");
      NSString *path = [[NSBundle mainBundle] pathForResource:@"Testing" ofType:@"plist"];
      
      
      tempListings = [[NSArray alloc]initWithContentsOfFile:path];
      
      NSLog(@"showing listings %@\n",tempListings);
      self.arView.view.hidden = FALSE;
      [self.arView showAR:tempListings owner:self callback:@selector(closeARView)];
      
   }
}

-(void) closeARView
{
   [self.arView.arView stop];
}

#pragma mark -
#pragma mark NSObject
- (id)init {
  if (self = [super init]) {
    //self.title = @"Singtel Dining";
  }
  return self;
}

- (void)dealloc {
   [arView release];
   [tempListings release];
   [mainLocation release];
   [locations release];
   
	[super dealloc];
}

#pragma mark -
#pragma mark TTViewController
- (void)loadView {
  [super loadView];
   
   mainLocation = [[NSMutableArray alloc] init];
   [mainLocation addObject:@"North"];
   [mainLocation addObject:@"South"];
   [mainLocation addObject:@"East"];
   [mainLocation addObject:@"West"];
   [mainLocation addObject:@"Central"];
   
   NSString *path = [[NSBundle mainBundle] pathForResource:@"Testing" ofType:@"plist"];
   
   
  locations = [[NSDictionary dictionaryWithContentsOfFile:path] retain];
   
   NSUserDefaults *settings = [NSUserDefaults standardUserDefaults];
  if (![settings boolForKey:K_UD_CONFIGED_CARD]) {
    NSLog(@"pop");
    TTNavigator* navigator = [TTNavigator navigator];
    [navigator openURLAction:[[TTURLAction actionWithURLPath:kAppCreditURLPath] applyAnimated:YES]];
  }
  
  // setting button
  UIButton *settingButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 34, 34)];
  [settingButton setImage:[UIImage imageNamed:@"button-setting.png"] forState:UIControlStateNormal];
  [settingButton addTarget:kAppCreditURLPath action:@selector(openURLFromButton:) forControlEvents:UIControlEventTouchUpInside];
  UIBarButtonItem *barSettingButton = [[UIBarButtonItem alloc] initWithCustomView:settingButton];
  [settingButton release];
  self.navigationItem.leftBarButtonItem = barSettingButton;
  [barSettingButton release];
  
  //back button
  UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 57, 30)];
  [backButton setImage:[UIImage imageNamed:@"button-blank.png"] forState:UIControlStateNormal];
  [backButton addTarget:self action:@selector(backButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
  UIBarButtonItem *barBackButton = [[UIBarButtonItem alloc] initWithCustomView:backButton];
  [backButton release];
  self.navigationItem.backBarButtonItem = barBackButton;
  [barBackButton release];

  
  boxView = [[UIView alloc] initWithFrame:CGRectMake(5, 0, 310, 305)];
  boxView.layer.cornerRadius = 6;
  boxView.layer.masksToBounds = YES;
  boxView.backgroundColor = [UIColor whiteColor];
  
  {
    TTView *titleBar = [[TTView alloc] initWithFrame:CGRectMake(0, 0, 310, 34)];
    titleBar.style = [[TTStyleSheet globalStyleSheet] styleWithSelector:@"searchBar"];
    titleBar.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin;
    // refresh button
    {
      UIButton *refreshButton = [[UIButton alloc] initWithFrame:CGRectMake(2, 0, 34, 33)];
      [refreshButton setImage:[UIImage imageNamed:@"button-refresh.png"] forState:UIControlStateNormal];
      [refreshButton addTarget:self action:nil forControlEvents:UIControlEventTouchUpInside];
      [titleBar addSubview:refreshButton];
      [refreshButton release];
    }
    // dropdown box
    {
      
      TTView *dropdownBox = [[TTView alloc] initWithFrame:CGRectMake(37, 2, 160, 30)];
      dropdownBox.style = [[TTStyleSheet globalStyleSheet] styleWithSelector:@"searchTextField"];
      dropdownBox.backgroundColor = [UIColor clearColor];
      dropdownBox.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin;
      
      
      
      [titleBar addSubview:dropdownBox];
      [dropdownBox release];
    }
      // map and list SegmentedControl
    {
       UISegmentedControl *viewTypeSegment = [[UISegmentedControl alloc] initWithFrame:CGRectMake(208, 3, 100, 27)];
       [viewTypeSegment insertSegmentWithImage:[UIImage imageNamed:@"seg-map.png"] atIndex:0 animated:NO];
       [viewTypeSegment insertSegmentWithImage:[UIImage imageNamed:@"seg-ar.png"] atIndex:1 animated:NO];
       [viewTypeSegment setMomentary:YES];
       [viewTypeSegment addTarget:self action:@selector(toggleListView:) forControlEvents:UIControlEventValueChanged];
       [titleBar addSubview:viewTypeSegment];
       [viewTypeSegment release];
    }
    
    [boxView addSubview:titleBar];
    [titleBar release];
    
    // content view
    {
      // table view
      {
        self.tableView.frame = CGRectMake(5, 40, 300, 280);
        self.tableView.backgroundColor = [UIColor clearColor];
        [boxView addSubview:self.tableView];
        //[tableView release];
      }
        // map view
      {
        MKMapView *mapView = [[MKMapView alloc] initWithFrame:CGRectMake(5, 40, 300, 280)];
        mapView.mapType = MKMapTypeStandard;
        mapView.tag = 1002;
        mapView.hidden = YES;
        [boxView addSubview:mapView];
        [mapView release];
      }
       
       
    }
  }
  
  boxView.tag = 100;
  [self.view addSubview:boxView];
  [boxView release];
  
  // cards box
  TTView *selectedCardBox = [[TTView alloc] initWithFrame:CGRectMake(5, 315, 310, 44)];
  //selectedCardBox.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"selected-card-bg.png"]];
  selectedCardBox.layer.cornerRadius = 6;
  selectedCardBox.layer.masksToBounds = YES;
  selectedCardBox.backgroundColor = [UIColor whiteColor];
  [self.view addSubview:selectedCardBox];
  [selectedCardBox release];
   
   //picker components
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
  
   // ARView

   //UIWindow* window = (UIWindow*)[[[UIApplication sharedApplication] delegate] window];
   arView = [[ARViewController alloc] init];
   [self.view addSubview:arView.view];
   arView.view.hidden = TRUE;
      
   
  
}


-(IBAction) selectLocation:(id)sender
{
   switch (1) {
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


#pragma mark textfield delegates

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField 
{
   return NO;
}


#pragma mark picker view delegates

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView

{
   return 2;
   
}



- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
   NSLog(@"Selected row %d\n",row);
   NSLog(@"Selected component %d\n",component);
   
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component

{
   
   return [mainLocation count];
  

}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component

{
   return [mainLocation objectAtIndex:row];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)createModel {
   NSLog(@"Creating Model for Location\n");
   
   self.dataSource  = [[[ListDataSource alloc] initWithType:@"Location" andSortBy:@"Location"] autorelease];

   
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (id<UITableViewDelegate>)createDelegate {
  return [[[TTTableViewDragRefreshDelegate alloc] initWithController:self] autorelease];
}


@end
