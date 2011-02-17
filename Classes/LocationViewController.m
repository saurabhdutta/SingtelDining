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
#import <Three20Core/NSStringAdditions.h>

// Flurry analytics
#import "FlurryAPI.h"

@implementation LocationViewController
@synthesize arView;
@synthesize banner;
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

      UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 65, 39)];
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
    
    [mapViewController showMapWithData: [(ListDataModel*)self.model posts]];
  } else {
    AppDelegate* delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    if (delegate.isSupportAR == NO) {
      UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Service not allowed!" message: @"This service is only available on 3gs and higher" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
      [alert show];
      [alert release];
    } else if (delegate.isLocationServiceAvailiable == NO) {
      UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Service not allowed!" message: @"This service requires Location Service On" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
      [alert show];
      [alert release];
    } else {
      arView.view.hidden = NO;
      [self.navigationController pushViewController:arView animated:NO];
      [arView showAR:[(ListDataModel*)self.model posts] owner:self callback:@selector(closeARView:)];
      
	  banner.hidden = YES;
    }
  }

  
/*
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
*/
}

- (IBAction)selectCard:(id)sender {
  UIButton *theButton = (UIButton *)sender;
  theButton.selected = YES;
}

-(void) closeARView:(NSString*) strID {
  NSLog(@"ID %@\n",strID);
  [self.arView closeAR:nil];
  
  DetailsViewController * controller = [[DetailsViewController alloc] initWithRestaurantId:[strID intValue]];
  [self.navigationController pushViewController:controller animated:YES];
  [controller release];
  
  //AppDelegate* ad = (AppDelegate*)[[UIApplication sharedApplication] delegate];
  banner.hidden = NO;
}

- (void) sendURLRequest
{

   AppDelegate *delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
   NSString * url;

   if(requestType == NEARBY_REQUEST)
   {
      url = [NSString stringWithFormat:@"%@?latitude=%f&longitude=%f&pageNum=1&resultsPerPage=15",
             URL_SEARCH_NEARBY, delegate.currentGeo.latitude,delegate.currentGeo.longitude];
   }

   else if(requestType == LOCATION_REQUEST) {
      url = [NSString stringWithFormat:@"%@?a=b",URL_GET_LOCATION];
   }

  if ([selectedBanks count]) {
    NSArray *uniqueArray = [[NSSet setWithArray:selectedBanks] allObjects];
    NSString *cardString = [uniqueArray componentsJoinedByString:@","];
    NSLog(@"cardString:%@", cardString);
    url = [url stringByAppendingFormat:@"&bank=%@", [cardString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
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
     [locations addObjectsFromArray:[feed objectForKey:@"data"]];

     selectedRow = 0;

     selectedSubRow = 0;

     textfield.text = [[locations objectAtIndex:0] objectForKey:@"name"];

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
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
  if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
    AppDelegate *delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    delegate.delegate = self;
    
    NSString* firstRowTitle;
    if (delegate.isLocationServiceAvailiable) 
      firstRowTitle = @"Around Me";
    else 
      firstRowTitle = @"All";
    
    NSDictionary* firstSubRow = [NSDictionary dictionaryWithObjectsAndKeys:@"All", @"name", @"0", @"id", nil];
    NSDictionary* firstRow    = [NSDictionary dictionaryWithObjectsAndKeys:firstRowTitle, @"name", @"0", @"id", [NSArray arrayWithObject:firstSubRow], @"sublocation", nil];
    locations = [[NSMutableArray alloc] initWithObjects:firstRow, nil];
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
  [banner release];
  [mapViewController release];

  TT_RELEASE_SAFELY(listMapButton);
  TT_RELEASE_SAFELY(arButton);
  TT_RELEASE_SAFELY(cardTable);
  [super dealloc];
}

#pragma mark -
#pragma mark TTViewController
- (void)viewDidLoad {
  [super viewDidLoad];
  // Flurry analytics
  [FlurryAPI countPageViews:self.navigationController];
	
	// UIWebView
	UIWebView * aBanner = [[UIWebView alloc] initWithFrame:CGRectMake(5, 25, 310, 35)];
	self.banner = aBanner;
	[aBanner release];
	 [[[banner subviews] lastObject] setScrollEnabled:NO];
	 banner.delegate = self;
	 banner.layer.cornerRadius = 5;
	 banner.layer.masksToBounds = YES;
	banner.alpha = 0.0;
	 NSURLRequest* bannerRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:URL_BANNER_AD_LOCATION]];
	 [banner loadRequest:bannerRequest];
	[banner setTag:9];
	[self.navigationController.view addSubview:banner];
}

- (void)loadView {
  [super loadView];
  
  AppDelegate *delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
  selectedBanks = delegate.cardChainDataSource.selectedBanks;
  
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
  
  // hotfix
  // fix the card list changes make configuration page crash
  NSString*	currentVersion = @"1.6";
  NSString* savedVersion = [settings objectForKey:I_LOVE_DEALS_VERSION];
  
  NSLog(@"\n-----------------------------------------------------------------------------------------------------\n");
  TTDPRINT(@"K_UD_CONFIGED_CARD: %d", (int)[settings boolForKey:K_UD_CONFIGED_CARD]);
  TTDPRINT(@"K_UD_SELECT_ALL: %d", (int)[settings boolForKey:K_UD_SELECT_ALL]);
  TTDPRINT(@"K_UD_SELECT_CARDS: %@", [settings objectForKey:K_UD_SELECT_CARDS]);
  NSLog(@"\n-----------------------------------------------------------------------------------------------------\n");
  if (!savedVersion || ([savedVersion versionStringCompare:currentVersion] < 0)) {
    TTDPRINT(@"version: %@ <=> %@ = %d", currentVersion, savedVersion, [currentVersion versionStringCompare:savedVersion]);
    
    // remove user saved cards
    [settings removeObjectForKey:K_UD_CONFIGED_CARD];
    [settings removeObjectForKey:K_UD_SELECT_ALL];
    [settings removeObjectForKey:K_UD_SELECT_CARDS];
    [settings setObject:currentVersion forKey:I_LOVE_DEALS_VERSION];
  }
  
  NSLog(@"\n-----------------------------------------------------------------------------------------------------\n");
  TTDPRINT(@"K_UD_CONFIGED_CARD: %d", (int)[settings boolForKey:K_UD_CONFIGED_CARD]);
  TTDPRINT(@"K_UD_SELECT_ALL: %d", (int)[settings boolForKey:K_UD_SELECT_ALL]);
  TTDPRINT(@"K_UD_SELECT_CARDS: %@", [settings objectForKey:K_UD_SELECT_CARDS]);
  NSLog(@"\n-----------------------------------------------------------------------------------------------------\n");
  
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
      [refreshButton addTarget:@"#updateTable" action:@selector(openURLFromButton:) forControlEvents:UIControlEventTouchUpInside];
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
  
  picker = [[UIPickerView alloc] init];

   textfield = [[UITextField alloc] initWithFrame:CGRectMake(48, 7, 130, 35)];
   textfield.delegate = self;
   textfield.font = [UIFont systemFontOfSize:14];
   textfield.backgroundColor = [UIColor clearColor];
   textfield.textColor = [UIColor redColor];
   textfield.textAlignment = UITextAlignmentLeft;
   textfield.hidden = FALSE;
  textfield.inputView = picker;

   //[textfield addTarget:self action:@selector(showHidePicker) forControlEvents:UIControlEventTouchDown];
   [self.view addSubview:textfield];
   [textfield release];
  
  UIToolbar* bar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 40)];
  NSMutableArray* buttons = [[NSMutableArray alloc] init];
  
  UIBarButtonItem* bt; 
  bt = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(dismissKeyboard:)];
  [buttons addObject:bt];
  [bt release];
  
  bt = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
  [buttons addObject:bt];
  [bt release];
  
  bt = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(selectLocation:)];
  [buttons addObject:bt];
  [bt release];
  
  
  [bar setItems:buttons];
  [buttons release];
  textfield.inputAccessoryView = bar;
  [bar release];

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

   //[self showHidePicker];
  [self performSelector:@selector(dismissKeyboard:) withObject:nil];

   if(selectMainLocation == 0)
   {
     
      textfield.text = [[locations objectAtIndex:0] objectForKey:@"name"];

      AppDelegate *delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];


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
                        [[[[locations objectAtIndex:selectMainLocation] objectForKey:@"sublocation"] objectAtIndex:selectSubLocation] objectForKey:@"name"] ];
     if ([textfield.text isEqualToString:@"All"]) {
       textfield.text = [NSString stringWithString:[[locations objectAtIndex:selectMainLocation] objectForKey:@"name"]];
     }

      keys = [NSMutableArray arrayWithObjects: @"id",@"pageNum", @"resultsPerPage",
              nil];

      NSString * selectedLocation = [NSString stringWithString:  [[[[locations objectAtIndex:selectMainLocation] objectForKey:@"sublocation"] objectAtIndex:selectSubLocation] objectForKey:@"id"]];

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
		
		// Flurry
		//NSMutableDictionary* analytics = [[NSMutableDictionary alloc] init];
		//[analytics setObject:item.userInfo forKey:@"BANK_NAME"];
		//[FlurryAPI logEvent:@"BANK_" withParameters:analytics];
		//[analytics release];  
		
		if (!item.selected) {
			int index = [selectedBanks indexOfObject:item.userInfo];
			if (!(index == NSNotFound)) {
				[selectedBanks removeObjectAtIndex:index];
			}
		} else {
			[selectedBanks addObject:item.userInfo];
		}
		
		if (indexPath.row > 0) {
			[self updateTable];
		}
	} else {
		[super didSelectObject:object atIndexPath:indexPath];
	}
}

#pragma mark textfield delegates

- (IBAction)dismissKeyboard:(id)sender {
  if ([textfield isFirstResponder]) {
    [textfield resignFirstResponder];
  }
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
   return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
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
     selectSubLocation = 0;
     
     [pickerView selectRow:0 inComponent:1 animated:YES];
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
      return [locations count];
   else
   {
      if (selectMainLocation == 0)
         return 1;
      else

      return [[[locations objectAtIndex:selectMainLocation] objectForKey:@"sublocation"] count];
   }


}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
   if (component == 0)
      return 120;
   else
      return 200;

}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
  NSString* title;
  
  switch (component) {
    case 0:
      title = [[locations objectAtIndex:row] objectForKey:@"name"];
      break;
      
    case 1: {
      NSArray* sub = [[locations objectAtIndex:selectMainLocation] objectForKey:@"sublocation"];
      NSDictionary* dic = [sub objectAtIndex:row];
      title = [dic objectForKey:@"name"];
      break;
    }
  }
  
  return title;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)updateTable {
   //NSLog(@"Creating Model for Location\n");

   NSString * type;
   NSString * sortBy;

  // NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

   //if([defaults objectForKey:SAVED_LOCATION_ID] == nil)
   //{

      textfield.text = [[locations objectAtIndex:0] objectForKey:@"name"];

      AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];


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
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (id<UITableViewDelegate>)createDelegate {
  return [[[TTTableViewPlainVarHeightDelegate alloc] initWithController:self] autorelease];
}

- (void)modelDidFinishLoad:(id <TTModel>)model {
  [super modelDidFinishLoad:model];
  [mapViewController showMapWithData: [(ListDataModel*)self.model posts]];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (BOOL)shouldLoadMore {
  return YES;
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  NSLog(@"reload card");
  AppDelegate* ad = (AppDelegate*)[[UIApplication sharedApplication] delegate];
  cardTable.dataSource = ad.cardChainDataSource;
  selectedBanks = ad.cardChainDataSource.selectedBanks;
  [cardTable reloadData];
  
  if (ad.locationShouldReload) {
    [self updateTable];
    ad.locationShouldReload = NO;
  }
  
  //[[TTNavigator navigator].window bringSubviewToFront:banner];
  	
  banner.hidden = NO;
}

- (void)viewWillDisappear:(BOOL)animated {
  [super viewWillDisappear:animated];
  
  //AppDelegate* ad = (AppDelegate*)[[UIApplication sharedApplication] delegate];
  banner.hidden = YES;
}

	 
#pragma mark -
#pragma mark UIWebViewDelegate
	 
 - (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)webRequest navigationType:(UIWebViewNavigationType)navigationType {
	 
	 NSLog(@"AppDelegate: shouldStartLoadWithRequest");	
	 
	 TTDPRINT(@"webview navigationType: %d", navigationType);
	 if (navigationType == UIWebViewNavigationTypeLinkClicked) {
		 // Flurry
		 NSMutableDictionary* analytics = [[NSMutableDictionary alloc] init];
		 [analytics setObject:@"LOCATION" forKey:@"CATEGORY"];
		 [analytics setObject:webRequest forKey:@"URL"];
		 [FlurryAPI logEvent:@"BANNER_CLICK" withParameters:analytics];
		 [analytics release];
		 
		 TTOpenURL([NSString stringWithFormat:@"%@", webRequest.URL]);
		 
		 //NSLog(@"Banner clicked......url=%@",webRequest);
		 
		 return NO;
	 }
	 return YES;
 }
 
 - (void)webViewDidFinishLoad:(UIWebView *)webView {
	 NSLog(@"AppDelegate: webViewDidFinishLoad");	
	 
	 NSString * theString = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
	 
	 if ([theString isEqualToString:@"404 Not Found"]) {
		 banner.alpha = 0.0;
	 }
	 else {
		 banner.alpha = 1.0;
	 }
	 NSLog(@"...............theString=%@",theString);
 }

 - (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
	 
	 NSLog(@"AppDelegate:didFailLoadWithError: %@", error.description);
	 
	 //if (error.code == NSURLErrorCancelled) return; 
	 
	 //banner.alpha = 0.0;
 }
	 
	 
@end
