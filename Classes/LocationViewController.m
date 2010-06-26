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
#import "AppDelegate.h"
#import "ListDataModel.h"
#import "ListObject.h"
#import "MobileIdentifier.h"
#import "AddressAnnotation.h"
#import "CSImageAnnotationView.h"


@implementation LocationViewController
@synthesize arView;
#pragma mark -

- (void)backButtonClicked:(id)sender {
  [self.navigationController.navigationBar popNavigationItemAnimated:YES];
}

- (void)toggleListView:(id)sender {
  NSLog(@"toggle %i", [sender selectedSegmentIndex]);
   //UIView *mapView;
   
   //mapView = [[self.view viewWithTag:100] viewWithTag:1002];
  
  self.tableView.hidden = mapView.hidden;
   self.variableHeightRows = YES;
  mapView.hidden = !self.tableView.hidden;
   if(([sender selectedSegmentIndex] == 1) && mapView.hidden == FALSE)
   {
      if(![[MobileIdentifier getMobileName] isEqualToString:@"iPhone1,1"] && ![[MobileIdentifier getMobileName] isEqualToString:@"iPhone1,2"] &&
         ![[MobileIdentifier getMobileName] isEqualToString:@"iPod1,1"] && ![[MobileIdentifier getMobileName] isEqualToString:@"iPod2,1"])
      {
      
         printf("showing AR View");
         arView.view.hidden = FALSE;
         [self.navigationController pushViewController:arView animated:NO];
         [arView showAR:_ARData owner:self callback:@selector(closeARView)];
      }
      
      else 
      {
         UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Service not allowed!" message: @"This service is only available on 3gs and higher" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
         [alert show];	
         [alert release];
      }

      
   }
   
   else {
      // Map Settings
         
         AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
         MKCoordinateRegion region;
         MKCoordinateSpan span;
         
         
         CLLocationCoordinate2D location;
         
         location.latitude = delegate.currentGeo.latitude;
         location.longitude = delegate.currentGeo.longitude;
         
         
         span.latitudeDelta = 0.02;
         span.longitudeDelta = 0.02;
         
         region.span = span;
         region.center = location;
         
         [mapView setRegion:region animated:TRUE];
         [mapView regionThatFits: region];      
         
         icon = [[AddressAnnotation alloc] initWithCoordinate:location];
         icon.mTitle = @"You are here!";
         icon.mSubtitle = @"Wala lang";      
         icon.annotationType = MapTypeUser;
         icon.strImg = @"icon_poi_nearby.png";
         icon.mIndex = -1;
         [mapView addAnnotation:icon];
         
      
   }
}

- (IBAction)selectCard:(id)sender {
  UIButton *theButton = (UIButton *)sender;
  theButton.selected = YES;
}

-(void) closeARView
{
   [self.arView.arView stop];
}

#pragma mark -
#pragma mark Delegate Functions

- (void) setARData:(NSArray*) array
{
   
   _ARData = [[NSMutableArray arrayWithArray:array] retain];
   //NSLog(@"Data %@",_ARData);
   
   
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
   //[tempListings release];
   [mainLocation release];
   [locations release];
   [keys release];
   [values release];
   [_ARData release];
   [icon release];
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
   
   NSString *path = [[NSBundle mainBundle] pathForResource:@"Locations" ofType:@"plist"];
   
   
  locations = [[NSArray alloc]initWithContentsOfFile:path];
   
   
   NSUserDefaults *settings = [NSUserDefaults standardUserDefaults];
  if (![settings boolForKey:K_UD_CONFIGED_CARD]) {
    NSLog(@"pop");
    TTNavigator* navigator = [TTNavigator navigator];
    [navigator openURLAction:[[TTURLAction actionWithURLPath:kAppCreditURLPath] applyAnimated:YES]];
  }
  
  //back button
  UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 57, 30)];
  [backButton setImage:[UIImage imageNamed:@"button-blank.png"] forState:UIControlStateNormal];
  [backButton addTarget:self action:@selector(backButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
  UIBarButtonItem *barBackButton = [[UIBarButtonItem alloc] initWithCustomView:backButton];
  [backButton release];
  self.navigationItem.backBarButtonItem = barBackButton;
  [barBackButton release];

  
  boxView = [[UIView alloc] initWithFrame:CGRectMake(5, 0, 310, 271)];
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
        
        self.tableView.frame = CGRectMake(5, 40, 300, 225);
        self.tableView.backgroundColor = [UIColor clearColor];
        [boxView addSubview:self.tableView];
        //[tableView release];
      }
        // map view
      {
         
          mapView = [[MKMapView alloc] initWithFrame:CGRectMake(5, 40, 300, 249)];
         mapView.mapType = MKMapTypeStandard;
         mapView.tag = 1002;
         mapView.hidden = YES;
         mapView.delegate = self;
         [boxView addSubview:mapView];
         [mapView release];
         [icon release];
      }
       
       
    }
  }
  
  boxView.tag = 100;
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
   
   
   //picker components
   titleView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 416, 128, 19)];
   titleView.image = [UIImage imageNamed:@"credit-title.png"];
   [self.view addSubview:titleView];
   
   selectMainLocation = 0;
   selectSubLocation = 0;
   
   picker = [[UIPickerView alloc] init];
   picker.showsSelectionIndicator = YES;
   picker.delegate = self;
   [picker selectRow:0 inComponent:0 animated:NO];
   picker.hidden = FALSE;
   picker.frame = kPickerOffScreen;
   [self.view addSubview:picker];
   
   okButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 57, 30)];
   [okButton setImage:[UIImage imageNamed:@"button-done.png"] forState:UIControlStateNormal];
   [okButton addTarget:self action:@selector(selectLocation:) forControlEvents:UIControlEventTouchDown];
   UIBarButtonItem *barDoneButton = [[UIBarButtonItem alloc] initWithCustomView:okButton];
   okButton.hidden = TRUE;
   [okButton release];
   self.navigationItem.rightBarButtonItem = barDoneButton;
   [barDoneButton release];
   
   textfield = [[UITextField alloc] initWithFrame:CGRectMake(50, 7, 140, 18)];
   textfield.text = @"Location-Nearby";
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
   switch (selectMainLocation) {
      case LOCATION_NORTH:
         NSLog(@"Selected North!");
         textfield.text = [NSString stringWithFormat:@"North-%@",[[[locations objectAtIndex:LOCATION_NORTH] objectAtIndex:selectSubLocation] objectForKey:@"Name"]];
         break;
      case LOCATION_SOUTH:
         NSLog(@"Selected South!");
         textfield.text = [NSString stringWithFormat:@"South-%@",[[[locations objectAtIndex:LOCATION_SOUTH] objectAtIndex:selectSubLocation] objectForKey:@"Name"]];
         break;
      case LOCATION_EAST:
         NSLog(@"Selected East!");
         textfield.text = [NSString stringWithFormat:@"East-%@",[[[locations objectAtIndex:LOCATION_EAST] objectAtIndex:selectSubLocation] objectForKey:@"Name"]];
         break;
      case LOCATION_WEST:
         NSLog(@"Selected West!");
         textfield.text = [NSString stringWithFormat:@"West-%@",[[[locations objectAtIndex:LOCATION_WEST] objectAtIndex:selectSubLocation] objectForKey:@"Name"]];
         break;
      case LOCATION_CENTRAL:
         NSLog(@"Selected Central!");
         textfield.text = [NSString stringWithFormat:@"Central-%@",[[[locations objectAtIndex:LOCATION_CENTRAL] objectAtIndex:selectSubLocation] objectForKey:@"Name"]];
         break;
      default:
         NSLog(@"selection Invalid!");
         break;
   }
   
   
   [self showHidePicker];
   
   AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
   CLLocationCoordinate2D location;
   location.latitude = delegate.currentGeo.latitude;
   location.longitude = delegate.currentGeo.longitude;
   
   MKCoordinateRegion region;
   MKCoordinateSpan span;
   
   span.latitudeDelta = 0.02;
   span.longitudeDelta = 0.02;
   
   region.span = span;
   region.center = location;
   
   [mapView setRegion:region animated:TRUE];
   [mapView regionThatFits: region];      
   
   icon.mSubtitle = @"Ala lang";      
   [icon setCoordinate: location];
   
   NSLog(@"Reloading Data!!!\n");
   
   keys = [NSArray arrayWithObjects: @"id",@"pageNum", @"resultsPerPage", 
                     nil];
   
   values = [NSArray arrayWithObjects: [[[locations objectAtIndex:selectMainLocation] objectAtIndex:selectSubLocation] objectForKey:@"ID"] ,
                       @"1",@"10",
                       nil];
   
   ListDataSource * data  = [[[ListDataSource alloc] initWithType:@"Location" andSortBy:@"SelectedLocation" withKeys: keys andValues: values] autorelease];
   data.delegate = self;
   self.dataSource = data;
   
   
   
   
}

- (void) showHidePicker
{
   // Picker View Show in animation
   NSLog(@"Picker...\n");
   
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
   
   
   if(component == 0)
   {
      selectMainLocation = row;
      [pickerView reloadComponent:1];
   }
   else
      selectSubLocation = row;
   
   
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component

{
   
   if (component == 0)
      return 5;
   else 
      return [[locations objectAtIndex:selectMainLocation] count];
  

}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
   if (component == 0)
      return 120;
   else 
      return 200;

}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component

{
   if (component == 0)
      return [mainLocation objectAtIndex:row];
   else
      return [[[locations objectAtIndex:selectMainLocation] objectAtIndex:row] objectForKey:@"Name"];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)createModel {
   NSLog(@"Creating Model for Location\n");
   
   AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
   
   NSString * latitude = [NSString stringWithFormat:@"%f",delegate.currentGeo.latitude];
   NSString * longitude = [NSString stringWithFormat:@"%f",delegate.currentGeo.longitude];
   
   [latitude retain];
   [longitude retain];
   
   NSLog(@"Latiude %s\n",[latitude UTF8String]);
   NSLog(@"Longitude %s\n",[longitude UTF8String]);
   
   keys = [NSArray arrayWithObjects: @"latitude", @"longitude", @"pageNum", @"resultsPerPage", 
           nil];
   
   

   
   values = [NSArray arrayWithObjects: latitude, longitude, @"1",@"10",
             nil];
   
   
  
   
   ListDataSource * data = [[[ListDataSource alloc] initWithType:@"Location" andSortBy:@"CurrentLocation" withKeys: keys andValues: values] autorelease];
   data.delegate = self;
   self.dataSource = data;
   
   
   _ARData = [NSMutableArray arrayWithArray:((ListDataModel*)([data model])).posts];
   NSLog(@"Array %@\n",_ARData);
   
   
}


#pragma mark -
#pragma mark MapView delegate

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{	
	MKAnnotationView* annotationView = nil;	
	AddressAnnotation * adrAnno = (AddressAnnotation *) annotation;
	
   NSString* identifier = @"Image";
   
   CSImageAnnotationView* imageAnnotationView = [[[CSImageAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier] autorelease];
   
   annotationView = imageAnnotationView;
   [annotationView setEnabled:YES];
   [annotationView setCanShowCallout:YES];
	
	return annotationView;	
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (id<UITableViewDelegate>)createDelegate {
  return [[[TTTableViewPlainVarHeightDelegate alloc] initWithController:self] autorelease];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (BOOL)shouldLoadMore {
  return YES;
}

@end
