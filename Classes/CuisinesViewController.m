//
//  CuisinesViewController.m
//  SingtelDining
//
//  Created by Alex Yao on 6/16/10.
//  Copyright 2010 CellCity. All rights reserved.
//

#import <extThree20JSON/extThree20JSON.h>
#import "CuisinesViewController.h"
#import "ListDataSource.h"
#import "PickerDataSource.h"
#import "ARViewController.h"
#import "MobileIdentifier.h"
#import "MapViewController.h"
#import "AppDelegate.h"
#import "StringTable.h"

@implementation CuisinesViewController
@synthesize arView;


- (void)toggleListView:(id)sender {
   NSLog(@"toggle %i", [sender selectedSegmentIndex]);
   UIView *mapView;
   
   self.variableHeightRows = YES;
   mapView = [self.view viewWithTag:1003];
   
   if ([sender selectedSegmentIndex] == 0)
   {
      mapViewController.view.hidden = mapView.hidden;
      
      mapView.hidden = !mapViewController.view.hidden;
   }
   else {
      
      mapView.hidden = TRUE;
   }
   
   showMap = TRUE;
   isNearbyRequest = TRUE;
   
   UIView * tempView = [[[UIView alloc] initWithFrame:CGRectMake(5, 0, 310, 280)] autorelease];
   [tempView setBackgroundColor:[UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.7]];
   UILabel * loadingText = [[[UILabel alloc] initWithFrame:CGRectMake(120, 100, 100, 40)] autorelease];
   [loadingText setBackgroundColor:[UIColor clearColor]];
   [loadingText setText:@"Loading..."];
   [tempView addSubview:loadingText];
   [self setLoadingView:tempView];
   [self showLoading:TRUE];
   
   [sender setEnabled:FALSE];
   [self sendURLRequest];
   if([sender selectedSegmentIndex] == 1) 
   {
      NSString * mobileName = [MobileIdentifier getMobileName];
      NSLog(@"Name: %@\n",mobileName );
      
      
      NSString * deviceType;
      if([mobileName length] > 6){
         deviceType  = [[MobileIdentifier getMobileName] substringToIndex:6];
      }
      else
      {
         deviceType = @"";
      }
      
      NSLog(@"Device Type: %@\n",deviceType );
      NSRange range = {2,1};
      if([deviceType isEqualToString:@"iPhone"] && ([[deviceType substringWithRange:range] intValue] >= 2) ) 
      {
         
         showMap = FALSE;
         
      }
      
      else 
      {
         UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Service not allowed!" message: @"This service is only available on 3gs and higher" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
         [alert show];	
         [alert release];
      }
      
      
   }
}

-(void) closeARView
{
   [self.arView.arView stop];
}

- (void) sendURLRequest
{
   
   AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
   NSString * url;
   
   if(isNearbyRequest)
   {
      
      url = [NSString stringWithFormat:@"%@?latitude=%f&longitude=%f&pageNum=1&resultsPerPage=15",
             URL_SEARCH_NEARBY, delegate.currentGeo.latitude,delegate.currentGeo.longitude];
   }
   
   else 
   {
      url = [NSString stringWithFormat:@"%@",URL_GET_CUISINE];
   }
   
   
   TTURLRequest *request = [TTURLRequest requestWithURL:url delegate:self];
   request.httpMethod = @"POST";
   request.cachePolicy = TTURLRequestCachePolicyNoCache;
   
   request.response = [[[TTURLJSONResponse alloc] init] autorelease];
   
   NSLog(@"request: %@", request);
   [request send];
}


- (void)requestDidFinishLoad:(TTURLRequest*)request {
   
   
   
   TTURLJSONResponse* response = request.response;

   NSDictionary* feed = response.rootObject;
   //NSLog(@"feed: %@",feed);
   TTDASSERT([[feed objectForKey:@"data"] isKindOfClass:[NSArray class]]);
   
   if(isNearbyRequest)
   {
      
      _ARData = [[NSMutableArray arrayWithArray:[feed objectForKey:@"data"]] retain];
      
      
      if(showMap)
         [mapViewController showMapWithData:_ARData];
      else {
         
         arView.view.hidden = FALSE;
         [self.navigationController pushViewController:arView animated:NO];
         [arView showAR:_ARData owner:self callback:@selector(closeARView:)];
      }
   }
   
   else {
      
      NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
      if ([defaults objectForKey:SAVED_CUISINE] == nil)
         defaultSelected = [[feed objectForKey:@"defaultCuisine"] intValue]-1;
      else 
         defaultSelected = [defaults integerForKey:CUISINE_ROW];

      
      cusines = [[NSMutableArray arrayWithArray:[feed objectForKey:@"data"]] retain];
      
      textfield.text = ([defaults objectForKey:SAVED_CUISINE_NAME] != nil) ? [defaults objectForKey:SAVED_CUISINE_NAME] : @"Cuisine-Chinese";
      
      picker = [[UIPickerView alloc] init];
      picker.showsSelectionIndicator = YES;
      picker.delegate = self;
      [picker selectRow:defaultSelected inComponent:0 animated:NO];
      picker.hidden = FALSE;
      picker.frame = kPickerOffScreen;
      [self.view addSubview:picker];
   }
   
   [self showLoading:FALSE];
   [viewTypeSegment setEnabled:TRUE];
   
}


- (void)request:(TTURLRequest*)request didFailLoadWithError:(NSError*)error {
   
   NSLog(@"request: %@, error: %@",request,error);
}

#pragma mark -
#pragma mark Delegate Functions

/*- (void) setARData:(NSArray*) array
{
   NSLog(@"setting ARData in CusinesViewController!\n");
   _ARData = [[NSMutableArray arrayWithArray:array] retain];
   //NSLog(@"Data %@",_ARData);
   
   
}*/

#pragma mark -
- (IBAction)selectCard:(id)sender {
   
   [sender setSelected:YES];
}


#pragma mark -

- (void)loadView {
  [super loadView];
  
  UIButton *settingButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 34, 34)];
  [settingButton setImage:[UIImage imageNamed:@"button-setting.png"] forState:UIControlStateNormal];
  [settingButton addTarget:kAppCreditURLPath action:@selector(openURLFromButton:) forControlEvents:UIControlEventTouchUpInside];
  UIBarButtonItem *barSettingButton = [[UIBarButtonItem alloc] initWithCustomView:settingButton];
  [settingButton release];
  self.navigationItem.leftBarButtonItem = barSettingButton;
  [barSettingButton release];
   
   isNearbyRequest = FALSE;
   
   [self sendURLRequest];
   
   NSString *path = [[NSBundle mainBundle] pathForResource:@"Food" ofType:@"plist"];
   
   
   cusines = [[NSArray alloc]initWithContentsOfFile:path];
   
   
   
   boxView = [[SDListView alloc] initWithFrame:CGRectMake(5, 0, 310, 280)];
   
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
          viewTypeSegment = [[UISegmentedControl alloc] initWithFrame:CGRectMake(208, 3, 100, 27)];
         [viewTypeSegment insertSegmentWithImage:[UIImage imageNamed:@"seg-map.png"] atIndex:0 animated:NO];
         [viewTypeSegment insertSegmentWithImage:[UIImage imageNamed:@"seg-ar.png"] atIndex:1 animated:NO];
         [viewTypeSegment setMomentary:YES];
         [viewTypeSegment addTarget:self action:@selector(toggleListView:) forControlEvents:UIControlEventValueChanged];
         [titleBar addSubview:viewTypeSegment];
         [viewTypeSegment release];
      }
      
      [boxView addSubview:titleBar];
      [titleBar release];
   }
  
  {
    self.tableView.frame = CGRectMake(5, 40, 300, 235);
    self.tableView.backgroundColor = [UIColor clearColor];
    
    [boxView addSubview:self.tableView];
  }
   
   {
      mapViewController = [[MapViewController alloc] init];
      mapViewController.view.tag = 1003;
      mapViewController.view.hidden = YES;
      [boxView addSubview:mapViewController.view];
   }
  
   boxView.tag = 300;
  [self.view addSubview:boxView];
  [boxView release];
   
  UIView *cardTableBg = [[UIView alloc] initWithFrame:CGRectMake(5, 284, 310, 75)];
  cardTableBg.layer.cornerRadius = 6;
  cardTableBg.layer.masksToBounds = YES;
  cardTableBg.backgroundColor = [UIColor whiteColor];
  [self.view addSubview:cardTableBg];
  TT_RELEASE_SAFELY(cardTableBg);
  
  cardTable = [[HTableView alloc] initWithFrame:CGRectMake(10, 291, 300, 60) style:UITableViewStylePlain];
  cardTable.dataSource = [[HTableDataSource alloc] init];
  cardTable.rowHeight = 95;
  cardTable.delegate = [[TTTableViewPlainDelegate alloc] initWithController:self];
  cardTable.tag = 22;
  [self.view addSubview:cardTable];
   
   boxView.hidden = FALSE;
   
   //titleView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 416, 128, 19)];
//   titleView.image = [UIImage imageNamed:@"credit-title.png"];
//   [self.view addSubview:titleView];
   
   
   
   okButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 57, 30)];
   [okButton setImage:[UIImage imageNamed:@"button-done.png"] forState:UIControlStateNormal];
   [okButton addTarget:self action:@selector(selectCuisine:) forControlEvents:UIControlEventTouchDown];
   UIBarButtonItem *barDoneButton = [[UIBarButtonItem alloc] initWithCustomView:okButton];
   okButton.hidden = TRUE;
   [okButton release];
   self.navigationItem.rightBarButtonItem = barDoneButton;
   [barDoneButton release];
   
   textfield = [[UITextField alloc] initWithFrame:CGRectMake(50, 7, 140, 18)];
   //textfield.text = @"Cuisine-Chinese";
   textfield.delegate = self;
   textfield.font = [UIFont systemFontOfSize:14];
   textfield.backgroundColor = [UIColor clearColor];
   textfield.textColor = [UIColor redColor];
   textfield.hidden = FALSE;
   
   [textfield addTarget:self action:@selector(showHidePicker) forControlEvents:UIControlEventTouchDown];
   [self.view addSubview:textfield];
   [textfield release];
   
   
   arView = [[ARViewController alloc] init];
   [self.view addSubview:arView.view];
   arView.view.hidden = TRUE;
   
   

}

#pragma mark action methods

-(IBAction) selectCuisine:(id)sender
{
   
   
   textfield.text = [NSString stringWithFormat:@"Cuisine-%@",[[cusines objectAtIndex:selectedCusine] objectForKey:@"CuisineType"]];
   
   
   [self showHidePicker];
   
   
   
}

- (void) showHidePicker
{
   // Picker View Show in animation
   
   
   [UIView beginAnimations:@"CalendarTransition" context:nil];
   [UIView setAnimationDuration:0.3];
   if(picker.frame.origin.y < kPickerOffScreen.origin.y) { // off screen
      picker.frame = kPickerOffScreen;
      //titleView.frame = CGRectMake(0, 416, 128, 19);
      okButton.hidden = TRUE;
      [boxView setEnabled: TRUE];
   } else { // on screen, show a done button
      //titleView.frame = CGRectMake(0, 120, 128, 19);
      picker.frame = kPickerOnScreen;
      //picker.dataSource = [[PickerDataSource alloc] init];
      okButton.hidden = FALSE;
      [boxView setEnabled: FALSE];
   }
   [UIView commitAnimations];
   
   NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
   [defaults setObject:[[cusines objectAtIndex:selectedCusine] objectForKey:@"ID"] forKey:SAVED_CUISINE];
   [defaults setObject:textfield.text forKey:SAVED_CUISINE_NAME];
   [defaults setInteger:selectedCusine forKey:CUISINE_ROW];
   
   NSString * keys = [NSArray arrayWithObjects: @"cuisineTypeID",@"pageNum", @"resultsPerPage", 
           nil];
   
   NSString * values = [NSArray arrayWithObjects: [[cusines objectAtIndex:selectedCusine] objectForKey:@"ID"] ,
             @"1",@"10",
             nil];

   ListDataSource * data = [[[ListDataSource alloc] initWithType:@"Cuisine" andSortBy:@"Cuisine" withKeys: keys andValues: values] autorelease];
   data.delegate = self;
   self.dataSource = data;
   
   
   _ARData = [NSMutableArray arrayWithArray:((ListDataModel*)([data model])).posts];
  
}


- (void) dealloc
{
   [picker release];
   //[titleView release];
   [arView release];
   [_ARData release];
   [mapViewController release];
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
   return [[cusines objectAtIndex:row] objectForKey:@"CuisineType"];
}

#pragma mark tableView delegates

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)createModel {
   
   NSString * cuisineID;
   NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
 
   if([defaults objectForKey:SAVED_CUISINE] == nil)
      cuisineID = [[cusines objectAtIndex:defaultSelected] objectForKey:@"ID"];
   else 
      cuisineID = [NSString stringWithFormat:@"%@",[defaults objectForKey:SAVED_CUISINE]];

   
   NSString *keys = [NSArray arrayWithObjects: @"cuisineTypeID",@"pageNum", @"resultsPerPage", 
           nil];
   
   NSString *values = [NSArray arrayWithObjects: cuisineID,
             @"1",@"10",
             nil];
   
   ListDataSource * data = [[[ListDataSource alloc] initWithType:@"Cuisine" andSortBy:@"Cuisine" withKeys: keys andValues: values] autorelease];
   data.delegate = self;
   self.dataSource = data;
   
   
   _ARData = [NSMutableArray arrayWithArray:((ListDataModel*)([data model])).posts];
   
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (id<UITableViewDelegate>)createDelegate {
  return [[[TTTableViewDragRefreshDelegate alloc] initWithController:self] autorelease];
}

#pragma mark -
#pragma mark TTTableViewController
- (void)didSelectObject:(id)object atIndexPath:(NSIndexPath *)indexPath {
  NSLog(@"didSelectObject");
  if ([object isKindOfClass:[HTableItem class]]) {
    NSLog(@"check");
    HTableItem *item = (HTableItem *)object;
    item.selected = !item.selected;
    [cardTable reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationNone];
    [cardTable selectRowAtIndexPath:indexPath];
    
    if ([selectedCards containsObject:item.text]) {
      [selectedCards removeObject:item.text];
    } else {
      [selectedCards addObject:item.text];
    }
    
    NSLog(@"selectd :%@", selectedCards);
    [self reload];
  } else {
    [super didSelectObject:object atIndexPath:indexPath];
  }
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  NSLog(@"reload card");
  cardTable.dataSource = [[HTableDataSource alloc] init];
  [cardTable reloadData];
}

@end
