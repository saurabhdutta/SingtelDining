//
//  LocationViewController.m
//  SingtelDining
//
//  Created by Alex Yao on 6/14/10.
//  Copyright 2010 CellCity. All rights reserved.
//

#import <extThree20JSON/extThree20JSON.h>
#import "LocationViewController.h"
#import "ListDataSource.h"
#import "ARViewController.h"
#import "AppDelegate.h"
#import "ListDataModel.h"
#import "ListObject.h"
#import "MobileIdentifier.h"
#import "MapViewController.h"
#import "HTableView.h"
#import "DetailsViewController.h"


@implementation LocationViewController
@synthesize arView;
#pragma mark -

- (void) cancelBarClicked:(id)sender
{
  [self showHidePicker];

}

- (void)backButtonClicked:(id)sender {
  [self.navigationController.navigationBar popNavigationItemAnimated:YES];
}

- (IBAction)backToListView:(id)sender {
  [self performSelector:@selector(toggleListView:) withObject:listMapButton];
}

- (void)toggleListView:(id)sender {
  NSLog(@"toggle %i", [sender tag]);

  UIButton* theButton = sender;
  UIView *mapView;

  self.variableHeightRows = YES;
  mapView = [self.view viewWithTag:1001];

  if ([sender tag] == 0) {
    mapViewController.view.hidden = mapView.hidden;

    mapView.hidden = !mapViewController.view.hidden;

    theButton.selected = !theButton.selected;
    if (theButton.selected) {

      [listMapButton setImage:[UIImage imageNamed:@"seg-list.png"] forState:UIControlStateNormal];

      UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 57, 30)];
      [backButton setImage:[UIImage imageNamed:@"button-back.png"] forState:UIControlStateNormal];
      [backButton addTarget:self action:@selector(backToListView:) forControlEvents:UIControlEventTouchUpInside];
      UIBarButtonItem *barDoneButton = [[UIBarButtonItem alloc] initWithCustomView:backButton];
      [backButton release];
      self.navigationItem.leftBarButtonItem = barDoneButton;
      [barDoneButton release];
    } else {
      self.navigationItem.leftBarButtonItem = nil;
      [listMapButton setImage:[UIImage imageNamed:@"seg-map.png"] forState:UIControlStateNormal];
    }

  } else {
    mapView.hidden = TRUE;
  }

   showMap = TRUE;
   requestType = NEARBY_REQUEST;

   UIView * tempView = [[[UIView alloc] initWithFrame:CGRectMake(5, 0, 310, 280)] autorelease];
   [tempView setBackgroundColor:[UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.7]];
   UILabel * loadingText = [[[UILabel alloc] initWithFrame:CGRectMake(120, 100, 100, 40)] autorelease];
   [loadingText setBackgroundColor:[UIColor clearColor]];
   [loadingText setText:@"Loading..."];
   [tempView addSubview:loadingText];
   [self setLoadingView:tempView];
   [self showLoading:TRUE];

  [listMapButton setEnabled:NO];
  [arButton setEnabled:NO];
   [self sendURLRequest];
   if([sender tag] == 1)
   {
     NSString * mobileName = [MobileIdentifier getMobileName];

     NSString * deviceType;
     if([mobileName length] > 6){
       deviceType  = [[MobileIdentifier getMobileName] substringToIndex:7];

     }
     else
     {
       deviceType = @"NotAnIPhone3GS";

     }

     NSRange  range = {6,1};
     if([[deviceType substringToIndex:6] isEqualToString:@"iPhone"] && ([[deviceType substringWithRange:range] intValue] >= 2) )
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

- (IBAction)selectCard:(id)sender {
  UIButton *theButton = (UIButton *)sender;
  theButton.selected = YES;
}

-(void) closeARView:(NSString*) strID
{
   NSLog(@"ID %@\n",strID);
  [self.arView closeAR:nil];

   DetailsViewController * controller = [[DetailsViewController alloc] initWithRestaurantId:[strID intValue]];
   [self.navigationController pushViewController:controller animated:YES];
   [controller release];


}

- (void) sendURLRequest
{

   AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
   NSString * url;

   if(requestType == NEARBY_REQUEST)
   {
      url = [NSString stringWithFormat:@"%@?latitude=%f&longitude=%f&pageNum=1&resultsPerPage=15",
             URL_SEARCH_NEARBY, delegate.currentGeo.latitude,delegate.currentGeo.longitude];
   }

   else if(requestType == LOCATION_REQUEST) {
      url = [NSString stringWithFormat:@"%@",URL_GET_LOCATION];
   }



   TTURLRequest *request = [TTURLRequest requestWithURL:url delegate:self];
   request.httpMethod = @"POST";
   request.cachePolicy = TTURLRequestCachePolicyNoCache;

   request.response = [[[TTURLJSONResponse alloc] init] autorelease];

   NSLog(@"request map/ar: %@", request);
   [request send];
}


- (void)requestDidFinishLoad:(TTURLRequest*)request {





   TTURLJSONResponse* response = request.response;


   NSDictionary* feed = response.rootObject;
   //NSLog(@"feed: %@",feed);
    TTDASSERT([[feed objectForKey:@"data"] isKindOfClass:[NSArray class]]);

   if(requestType == NEARBY_REQUEST)
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

   else
   {

      locations = [[NSMutableArray arrayWithArray:[feed objectForKey:@"data"]] retain];


     selectedRow = 0;

     selectedSubRow = 0;

     textfield.text = @"Around Me";

     picker = [[UIPickerView alloc] init];
     picker.showsSelectionIndicator = YES;
     picker.delegate = self;


     picker.hidden = FALSE;
     picker.frame = kPickerOffScreen;
     [self.view addSubview:picker];

   }

  [listMapButton setEnabled:YES];
  [arButton setEnabled:YES];
   [self showLoading:FALSE];

}


- (void)request:(TTURLRequest*)request didFailLoadWithError:(NSError*)error {

   NSLog(@"request: %@, error: %@",request,error);
}

#pragma mark -
#pragma mark Delegate Functions

/*- (void) setARData:(NSArray*) array
{

   NSLog(@"setting ARData in LocationViewController!\n");
   _ARData = [[NSMutableArray arrayWithArray:array] retain];
   //NSLog(@"Data %@",_ARData);


}*/

#pragma mark -
#pragma mark NSObject
- (id)init {
  if (self = [super init]) {
    AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    delegate.delegate = self;
    selectedBanks = delegate.cardChainDataSource.selectedBanks;
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
  [mapViewController release];

  TT_RELEASE_SAFELY(listMapButton);
  TT_RELEASE_SAFELY(arButton);
  TT_RELEASE_SAFELY(cardTable);
  [super dealloc];
}

#pragma mark -
#pragma mark TTViewController
- (void)loadView {
  [super loadView];
   setListImage = FALSE;
   cancelClicked = TRUE;
   requestType = LOCATION_REQUEST;

   [self sendURLRequest];

   //mainLocation = [[NSMutableArray alloc] init];
//   [mainLocation addObject:@"North"];
//   [mainLocation addObject:@"South"];
//   [mainLocation addObject:@"East"];
//   [mainLocation addObject:@"West"];
//   [mainLocation addObject:@"Central"];

   //NSString *path = [[NSBundle mainBundle] pathForResource:@"Locations" ofType:@"plist"];


  //locations = [[NSArray alloc]initWithContentsOfFile:path];


   NSUserDefaults *settings = [NSUserDefaults standardUserDefaults];
  if (![settings boolForKey:K_UD_CONFIGED_CARD]) {
    NSLog(@"pop");
    TTNavigator* navigator = [TTNavigator navigator];
    [navigator openURLAction:[[TTURLAction actionWithURLPath:kAppCreditURLPath] applyAnimated:YES]];
  }

  //back button
  UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 57, 30)];
  [backButton setImage:[UIImage imageNamed:@"button-cancel.png"] forState:UIControlStateNormal];
  [backButton addTarget:self action:@selector(backButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
  UIBarButtonItem *barBackButton = [[UIBarButtonItem alloc] initWithCustomView:backButton];
  [backButton release];
  self.navigationItem.backBarButtonItem = barBackButton;
  [barBackButton release];

  boxView = [[UIView alloc] initWithFrame:CGRectMake(5, 0, 310, 280)];
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
      [refreshButton addTarget:@"#reload" action:@selector(openURLFromButton:) forControlEvents:UIControlEventTouchUpInside];
      [titleBar addSubview:refreshButton];
      [refreshButton release];
    }
    // dropdown box
    {

      UIImageView *dropdownBox = [[UIImageView alloc] initWithFrame:CGRectMake(37, 2, 160, 30)];
      dropdownBox.image = [UIImage imageNamed:@"dropdown.png"];
      [titleBar addSubview:dropdownBox];
      [dropdownBox release];
    }
      // map and list SegmentedControl
    {

      listMapButton = [[UIButton alloc] initWithFrame:CGRectMake(208, 3, 51, 29)];
      [listMapButton setImage:[UIImage imageNamed:@"seg-map.png"] forState:UIControlStateNormal];
      [listMapButton addTarget:self action:@selector(toggleListView:) forControlEvents:UIControlEventTouchUpInside];
      [listMapButton setTag:0];
      [titleBar addSubview:listMapButton];

      arButton = [[UIButton alloc] initWithFrame:CGRectMake(263, 3, 44, 27)];
      [arButton setImage:[UIImage imageNamed:@"seg-ar.png"] forState:UIControlStateNormal];
      [arButton setImage:[UIImage imageNamed:@"seg-ar.png"] forState:UIControlStateHighlighted];
      [arButton addTarget:self action:@selector(toggleListView:) forControlEvents:UIControlEventTouchUpInside];
      [arButton setTag:1];
      [titleBar addSubview:arButton];
    }

    [boxView addSubview:titleBar];
    [titleBar release];

    // content view
    {
      // table view
      {

        self.tableView.frame = CGRectMake(5, 40, 300, 235);
        self.tableView.backgroundColor = [UIColor clearColor];
        [boxView addSubview:self.tableView];
        //[tableView release];
      }
        // map view
      {
          mapViewController = [[MapViewController alloc] init];
         mapViewController.view.tag = 1001;
         mapViewController.view.hidden = YES;
         [boxView addSubview:mapViewController.view];

      }


    }
  }

  boxView.tag = 100;
  [self.view addSubview:boxView];
  [boxView release];

  UIView *cardTableBg = [[UIView alloc] initWithFrame:CGRectMake(5, 284, 310, 75)];
  cardTableBg.layer.cornerRadius = 6;
  cardTableBg.layer.masksToBounds = YES;
  cardTableBg.backgroundColor = [UIColor whiteColor];
  {
    UIImageView *leftArrow = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 15, 75)];
    leftArrow.image = [UIImage imageNamed:@"scroll_left1.png"];
    leftArrow.autoresizingMask = NO;
    [cardTableBg addSubview:leftArrow];
    TT_RELEASE_SAFELY(leftArrow);

    UIImageView *rightArrow = [[UIImageView alloc] initWithFrame:CGRectMake(295, 0, 15, 75)];
    rightArrow.image = [UIImage imageNamed:@"scroll_right1.png"];
    rightArrow.autoresizingMask = NO;
    [cardTableBg addSubview:rightArrow];
    TT_RELEASE_SAFELY(rightArrow);

    [self.view addSubview:cardTableBg];
    TT_RELEASE_SAFELY(cardTableBg);
  }

  cardTable = [[HTableView alloc] initWithFrame:CGRectMake(20, 291, 280, 60) style:UITableViewStylePlain];
  //cardTable.dataSource = [[HTableDataSource alloc] init];
  cardTable.rowHeight = 95;
  cardTable.delegate = [[TTTableViewPlainDelegate alloc] initWithController:self];
  cardTable.tag = 22;
  [self.view addSubview:cardTable];


    //picker components

    selectMainLocation = 0;
    selectSubLocation = 0;




   okButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 57, 30)];
   [okButton setImage:[UIImage imageNamed:@"button-done.png"] forState:UIControlStateNormal];
   [okButton addTarget:self action:@selector(selectLocation:) forControlEvents:UIControlEventTouchDown];
   UIBarButtonItem *barDoneButton = [[UIBarButtonItem alloc] initWithCustomView:okButton];
   okButton.hidden = TRUE;
   [okButton release];
   self.navigationItem.rightBarButtonItem = barDoneButton;
   [barDoneButton release];

   textfield = [[UITextField alloc] initWithFrame:CGRectMake(48, 7, 130, 35)];
   textfield.delegate = self;
   textfield.font = [UIFont systemFontOfSize:14];
   textfield.backgroundColor = [UIColor clearColor];
   textfield.textColor = [UIColor redColor];
   textfield.textAlignment = UITextAlignmentLeft;
   textfield.hidden = FALSE;

   [textfield addTarget:self action:@selector(showHidePicker) forControlEvents:UIControlEventTouchDown];
   [self.view addSubview:textfield];
   [textfield release];

   // ARView

   //UIWindow* window = (UIWindow*)[[[UIApplication sharedApplication] delegate] window];
   arView = [[ARViewController alloc] init];
   [self.view addSubview:arView.view];
   arView.view.hidden = TRUE;
  
  [self updateTable];
}


-(IBAction) selectLocation:(id)sender
{


   NSString * type;
   NSString * sortBy;

   NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

  cancelClicked = FALSE;

   [self showHidePicker];

   if(selectMainLocation == 0)
   {
      textfield.text = @"Around Me";

      AppDelegate *delegate = [[UIApplication sharedApplication] delegate];


      NSString * latitude = [NSString stringWithFormat:@"%f",delegate.currentGeo.latitude];
      NSString * longitude = [NSString stringWithFormat:@"%f",delegate.currentGeo.longitude];


      //NSLog(@"Latiude %s\n",[latitude UTF8String]);
      //NSLog(@"Longitude %s\n",[longitude UTF8String]);

      keys = [NSMutableArray arrayWithObjects: @"latitude", @"longitude", @"pageNum", @"resultsPerPage",
              nil];

      values = [NSMutableArray arrayWithObjects: latitude, longitude, @"1",@"20",
                nil];

      type = [NSString stringWithString:@"Location"];
      sortBy = [NSString stringWithString:@"CurrentLocation"];

      [defaults setInteger:0 forKey:LOCATION_ROW];
      [defaults setInteger:0 forKey:LOCATION_COMP];
     selectedRow = 0;
     selectedSubRow = 0;
   }
   else
   {
      textfield.text = [NSString stringWithFormat:@"%@",
                        [[[[locations objectAtIndex:selectMainLocation-1] objectForKey:@"sublocation"] objectAtIndex:selectSubLocation] objectForKey:@"name"] ];
     if ([textfield.text isEqualToString:@"All"]) {
       textfield.text = [NSString stringWithString:[[locations objectAtIndex:selectMainLocation-1] objectForKey:@"name"]];
     }

      keys = [NSMutableArray arrayWithObjects: @"id",@"pageNum", @"resultsPerPage",
              nil];

      NSString * selectedLocation = [NSString stringWithString:  [[[[locations objectAtIndex:selectMainLocation-1] objectForKey:@"sublocation"] objectAtIndex:selectSubLocation] objectForKey:@"id"]];

      values = [NSMutableArray arrayWithObjects: selectedLocation ,
                @"1",@"20",
                nil];

      type = [NSString stringWithString:@"Location"];
      sortBy = [NSString stringWithString:@"SelectedLocation"];


      [defaults setObject:selectedLocation forKey:SAVED_LOCATION_ID];
      [defaults setObject:textfield.text forKey:SAVED_LOCATION_NAME];
      [defaults setInteger:selectMainLocation forKey:LOCATION_ROW];
      [defaults setInteger:selectedComponent forKey:LOCATION_COMP];
      [defaults setInteger:selectSubLocation forKey:SUB_LOC_ROW];

     selectedRow = selectMainLocation;
     selectedSubRow = selectSubLocation;
   }


   //NSLog(@"Reloading Data!!!\n");

  if ([selectedBanks count]) {
    [keys addObject:@"bank"];
    NSArray *uniqueArray = [[NSSet setWithArray:selectedBanks] allObjects];
    NSString *cardString = [uniqueArray componentsJoinedByString:@","];
    NSLog(@"cardString:%@", cardString);
    [values addObject:cardString];
  }

   ListDataSource * data  = [[[ListDataSource alloc] initWithType:type andSortBy:sortBy withKeys: keys andValues: values] autorelease];
   data.delegate = self;
   self.dataSource = data;




}

- (void) showHidePicker
{
   // Picker View Show in animation



   //NSLog(@"Picker...\n");

   [UIView beginAnimations:@"CalendarTransition" context:nil];
   [UIView setAnimationDuration:0.3];
   if(picker.frame.origin.y < kPickerOffScreen.origin.y) { // off screen
      picker.frame = kPickerOffScreen;
      //titleView.frame = CGRectMake(0, 416, 128, 19);
      okButton.hidden = TRUE;
      [boxView setEnabled:TRUE];
     
   }
   else
   { // on screen, show a done button

     printf("selected sub row in showhide pciker %d\n",selectedSubRow);
     if (cancelClicked)
     {

       selectMainLocation = selectedRow;
       selectSubLocation = selectedSubRow;
     }
     else {
       cancelClicked = TRUE;
     }




     [picker selectRow:selectedRow inComponent:0 animated:NO];
     [picker reloadComponent:1];
     [picker selectRow:selectedSubRow inComponent:1 animated:NO];


     //titleView.frame = CGRectMake(0, 120, 128, 19);
     picker.frame = kPickerOnScreen;
     //picker.dataSource = [[PickerDataSource alloc] init];
     okButton.hidden = FALSE;
     [boxView setEnabled:FALSE];

   }
   [UIView commitAnimations];
  
  if(picker.frame.origin.y < kPickerOffScreen.origin.y) {
    UIButton *cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 57, 30)];
    [cancelButton setImage:[UIImage imageNamed:@"button-cancel.png"] forState:UIControlStateNormal];
    [cancelButton addTarget:self action:@selector(showHidePicker) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barCancelButton = [[UIBarButtonItem alloc] initWithCustomView:cancelButton];
    [cancelButton release];
    self.navigationItem.leftBarButtonItem = barCancelButton;
    [barCancelButton release];
  } else {
    self.navigationItem.leftBarButtonItem = nil;
  }

}

#pragma mark -
#pragma mark TTTableViewController

- (void)didSelectObject:(id)object atIndexPath:(NSIndexPath *)indexPath {
  //NSLog(@"didSelectObject");
  if ([object isKindOfClass:[HTableItem class]]) {
    HTableItem *item = (HTableItem *)object;
    item.selected = !item.selected;
    [cardTable reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationNone];
    [cardTable selectRowAtIndexPath:indexPath];
    if (!item.selected) {
      int index = [selectedBanks indexOfObject:item.userInfo];
      if (!(index == NSNotFound)) {
        [selectedBanks removeObjectAtIndex:index];
      }
    } else {
      [selectedBanks addObject:item.userInfo];
    }
    [self updateTable];
  } else {
    [super didSelectObject:object atIndexPath:indexPath];
  }
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



   if(component == 0)
   {
      selectMainLocation = row;

      [pickerView reloadComponent:1];
   }
   else
   {
      selectSubLocation = row;

   }

  printf("sublocation %d\n",selectSubLocation);


}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component

{
   if (component == 0)
      return [locations count]+1;
   else
   {
      if (selectMainLocation == 0)
         return 1;
      else

      return [[[locations objectAtIndex:selectMainLocation-1] objectForKey:@"sublocation"] count];
   }


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

   if(component == 0 && row == 0)
      return @"Around Me";
   else if (component == 1 && row == 0 && selectMainLocation == 0)
      return @"All";
   else if (component == 0)
      return [[locations objectAtIndex:row-1] objectForKey:@"name"];
   else if (selectMainLocation > 0)
      return [[[[locations objectAtIndex:selectMainLocation-1] objectForKey:@"sublocation"] objectAtIndex:row] objectForKey:@"name"];


}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)updateTable {
   //NSLog(@"Creating Model for Location\n");

   NSString * type;
   NSString * sortBy;

  // NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

   //if([defaults objectForKey:SAVED_LOCATION_ID] == nil)
   //{

      textfield.text = @"Around Me";

      AppDelegate *delegate = [[UIApplication sharedApplication] delegate];


      NSString * latitude = [NSString stringWithFormat:@"%f",delegate.currentGeo.latitude];
      NSString * longitude = [NSString stringWithFormat:@"%f",delegate.currentGeo.longitude];


      //NSLog(@"Latiude %s\n",[latitude UTF8String]);
      //NSLog(@"Longitude %s\n",[longitude UTF8String]);

      keys = [NSMutableArray arrayWithObjects: @"latitude", @"longitude", @"pageNum", @"resultsPerPage",
              nil];

      values = [NSMutableArray arrayWithObjects: latitude, longitude, @"1",@"20",
                nil];
      type = [NSString stringWithString:@"Location"];
      sortBy = [NSString stringWithString:@"CurrentLocation"];
   //}

   /*else

   {


      keys = [NSArray arrayWithObjects: @"id",@"pageNum", @"resultsPerPage",
              nil];
      values = [NSArray arrayWithObjects: [defaults objectForKey:SAVED_LOCATION_ID] ,
                @"1",@"20",
                nil];
      type = [NSString stringWithString:@"Location"];
      sortBy = [NSString stringWithString:@"SelectedLocation"];
   }*/


  if ([selectedBanks count]) {
    [keys addObject:@"bank"];
    NSArray *uniqueArray = [[NSSet setWithArray:selectedBanks] allObjects];
    NSString *cardString = [uniqueArray componentsJoinedByString:@","];
    NSLog(@"cardString:%@", cardString);
    [values addObject:cardString];
  }

   ListDataSource * data = [[[ListDataSource alloc] initWithType:type andSortBy:sortBy withKeys: keys andValues: values] autorelease];
   data.delegate = self;
   self.dataSource = data;


   _ARData = [NSMutableArray arrayWithArray:((ListDataModel*)([data model])).posts];


}





///////////////////////////////////////////////////////////////////////////////////////////////////
- (id<UITableViewDelegate>)createDelegate {
  return [[[TTTableViewPlainVarHeightDelegate alloc] initWithController:self] autorelease];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (BOOL)shouldLoadMore {
  return YES;
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  NSLog(@"reload card");
  AppDelegate* ad = [[UIApplication sharedApplication] delegate];
  cardTable.dataSource = ad.cardChainDataSource;
  [cardTable reloadData];
}

@end
