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
#import "DetailsViewController.h"
#import "ListTableDelegate.h"

// Flurry analytics
#import "FlurryAPI.h"

@implementation CuisinesViewController
@synthesize arView;
@synthesize banner;

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
    mapViewController.view.hidden = theButton.selected;
    
    mapView.hidden = theButton.selected;
    
    theButton.selected = !theButton.selected;
    if (theButton.selected) {
		
		// Flurry analytics
		NSMutableDictionary* analytics = [[NSMutableDictionary alloc] init];
		[analytics setObject:@"Cuisines" forKey:@"ON_TAB"];
		[FlurryAPI logEvent:@"MAP_CLICK" withParameters:analytics timed:YES];
		[analytics release];
      
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
	  
	  // Flurry analytics
	  NSMutableDictionary* analytics = [[NSMutableDictionary alloc] init];
	  [analytics setObject:@"Cuisines" forKey:@"ON_TAB"];
	  [FlurryAPI logEvent:@"AR_CLICK" withParameters:analytics timed:YES];
	  [analytics release];
	  
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
}

-(void) closeARView:(NSString*) strID {
  NSLog(@"ID %@\n",strID);
  [self.arView closeAR:nil];
  
  DetailsViewController * controller = [[DetailsViewController alloc] initWithRestaurantId:[strID intValue]];
  [self.navigationController pushViewController:controller animated:YES];
  [controller release];
  
  AppDelegate* ad = (AppDelegate*)[[UIApplication sharedApplication] delegate];
  banner.hidden = NO;
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
      url = [NSString stringWithFormat:@"%@?a=b",URL_GET_CUISINE];
   }
   
  if ([selectedAllBanks count]) {
    NSArray *uniqueArray = [[NSSet setWithArray:selectedAllBanks] allObjects];
    NSString *cardString = [uniqueArray componentsJoinedByString:@","];
    NSLog(@"cardString:%@", cardString);
    url = [url stringByAppendingFormat:@"&cardtype_id=%@", [cardString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
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
     
     
      selectedRow = defaultSelected;

      
      cusines = [[NSMutableArray arrayWithArray:[feed objectForKey:@"data"]] retain];
      
      textfield.text = ([defaults objectForKey:SAVED_CUISINE_NAME] != nil) ? [defaults objectForKey:SAVED_CUISINE_NAME] : @"Chinese";
      
      picker.showsSelectionIndicator = YES;
      picker.delegate = self;
      [picker selectRow:defaultSelected inComponent:0 animated:NO];
      picker.hidden = FALSE;
      picker.frame = kPickerOffScreen;
      [self.view addSubview:picker];
     
     [textfield becomeFirstResponder];
   }
   
   [self showLoading:FALSE];
  [listMapButton setEnabled:YES];
  [arButton setEnabled:YES];
   
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

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
  if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
  }
  return self;
}


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
    banner.tag = 9;
	NSURLRequest* bannerRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:URL_BANNER_AD_CUISINE]];
	[banner loadRequest:bannerRequest];
	[self.navigationController.view addSubview:banner];
}


-(void)updateSelectAll{
	
	if(selectedAllBanks){
		[selectedAllBanks removeAllObjects];
		selectedAllBanks = nil;
	}
	selectedAllBanks = [[NSMutableArray alloc] initWithArray:selectedBanks copyItems:YES];
	
	NSDictionary *cardList = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"CreditCard" ofType:@"plist"]];
	
	NSArray* cardAmexBank = [cardList objectForKey:@"AMEX"]; // cards in card.plist with bank name
	for(int i=0;i<[cardAmexBank count];i++){
	    NSDictionary * card = [cardAmexBank objectAtIndex:i];
		if([selectedAllBanks containsObject:[card objectForKey:@"CardID"]]){
			[selectedAllBanks addObject:AMEX_ALL];
			break;
		}
	}
	
	NSArray* cardCitiBank = [cardList objectForKey:@"Citibank"]; // cards in card.plist with bank name
	for(int i=0;i<[cardCitiBank count];i++){
		NSDictionary * card = [cardCitiBank objectAtIndex:i];
		if([selectedAllBanks containsObject:[card objectForKey:@"CardID"]]){
			[selectedAllBanks addObject:CITYBANK_ALL];
			break;
		}
	}
	
	NSArray* cardDBSBank = [cardList objectForKey:@"DBS"]; // cards in card.plist with bank name
	for(int i=0;i<[cardDBSBank count];i++){
		NSDictionary * card = [cardDBSBank objectAtIndex:i];
		if([selectedAllBanks containsObject:[card objectForKey:@"CardID"]]){
			[selectedAllBanks addObject:DBS_ALL];
			break;
		}
	}
	
	NSArray* cardHSBCBank = [cardList objectForKey:@"HSBC"]; // cards in card.plist with bank name
	for(int i=0;i<[cardHSBCBank count];i++){
		NSDictionary * card = [cardHSBCBank objectAtIndex:i];
		if([selectedAllBanks containsObject:[card objectForKey:@"CardID"]]){
			[selectedAllBanks addObject:HSBC_ALL];
			break;
		}
	}
	
	NSArray* cardOCBCBank = [cardList objectForKey:@"OCBC"]; // cards in card.plist with bank name
	for(int i=0;i<[cardOCBCBank count];i++){
		NSDictionary * card = [cardOCBCBank objectAtIndex:i];
		if([selectedAllBanks containsObject:[card objectForKey:@"CardID"]]){
			[selectedAllBanks addObject:OCBC_ALL];
			break;
		}
	}
	
	NSArray* cardPOSBBank = [cardList objectForKey:@"POSB"]; // cards in card.plist with bank name
	for(int i=0;i<[cardPOSBBank count];i++){
		NSDictionary * card = [cardPOSBBank objectAtIndex:i];
		if([selectedAllBanks containsObject:[card objectForKey:@"CardID"]]){
			[selectedAllBanks addObject:POSB_ALL];
			break;
		}
	}
	
	NSArray* cardSCBBank = [cardList objectForKey:@"SCB"]; // cards in card.plist with bank name
	for(int i=0;i<[cardSCBBank count];i++){
		NSDictionary * card = [cardSCBBank objectAtIndex:i];
		if([selectedAllBanks containsObject:[card objectForKey:@"CardID"]]){
			[selectedAllBanks addObject:SCB_ALL];
			break;
		}
	}
	
	NSArray* cardUOBBank = [cardList objectForKey:@"UOB"]; // cards in card.plist with bank name
	for(int i=0;i<[cardUOBBank count];i++){
		NSDictionary * card = [cardUOBBank objectAtIndex:i];
		if([selectedAllBanks containsObject:[card objectForKey:@"CardID"]]){
			[selectedAllBanks addObject:UOB_ALL];
			break;
		}
	}	
}

- (void)loadView {
  [super loadView];
  
  AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
  selectedBanks = delegate.cardChainDataSource.selectedBanks;
  [self updateSelectAll]; 
	
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
  
  
  picker = [[UIPickerView alloc] init];
   
   textfield = [[UITextField alloc] initWithFrame:CGRectMake(48, 7, 130, 35)];
   //textfield.text = @"Cuisine-Chinese";
   textfield.delegate = self;
   textfield.font = [UIFont systemFontOfSize:14];
   textfield.backgroundColor = [UIColor clearColor];
   textfield.textColor = [UIColor redColor];
   textfield.hidden = FALSE;
   
   //[textfield addTarget:self action:@selector(showHidePicker) forControlEvents:UIControlEventTouchDown];
  
  UIToolbar* bar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 40)];
  NSMutableArray* buttons = [[NSMutableArray alloc] init];
  
  UIBarButtonItem* bt; 
  bt = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(dismissKeyboard:)];
  [buttons addObject:bt];
  [bt release];
  
  bt = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
  [buttons addObject:bt];
  [bt release];
  
  bt = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(selectCuisine:)];
  [buttons addObject:bt];
  [bt release];
  
  
  [bar setItems:buttons];
  [buttons release];
  textfield.inputAccessoryView = bar;
  [bar release];
  
  textfield.inputView = picker;
  [self.view addSubview:textfield];
  [textfield release];
   
   
   arView = [[ARViewController alloc] init];
   [self.view addSubview:arView.view];
   arView.view.hidden = TRUE;
}

#pragma mark action methods

-(IBAction) selectCuisine:(id)sender
{
   
   
   textfield.text = [NSString stringWithFormat:@"%@",[[cusines objectAtIndex:selectedCusine] objectForKey:@"CuisineType"]];
   
   
  //[self showHidePicker];
  [self performSelector:@selector(dismissKeyboard:) withObject:nil];
   
  NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
  [defaults setObject:[[cusines objectAtIndex:selectedCusine] objectForKey:@"ID"] forKey:SAVED_CUISINE];
  [defaults setObject:textfield.text forKey:SAVED_CUISINE_NAME];
  [defaults setInteger:selectedCusine forKey:CUISINE_ROW];
  
  NSMutableArray * keys = [NSMutableArray arrayWithObjects: @"cuisineTypeID",@"pageNum", @"resultsPerPage", 
                     nil];
  
  NSMutableArray * values = [NSMutableArray arrayWithObjects: [[cusines objectAtIndex:selectedCusine] objectForKey:@"ID"] ,
                       @"1",@"20",
                       nil];
  
  if ([selectedAllBanks count]) {
    [keys addObject:@"cardtype_id"];
    NSArray *uniqueArray = [[NSSet setWithArray:selectedAllBanks] allObjects];
    NSString *cardString = [uniqueArray componentsJoinedByString:@","];
    NSLog(@"cardString:%@", cardString);
    [values addObject:cardString];
  }
  
  ListDataSource * data = [[[ListDataSource alloc] initWithType:@"Cuisine" andSortBy:@"Cuisine" withKeys: keys andValues: values] autorelease];
  data.delegate = self;
  self.dataSource = data;
  
  
  _ARData = [NSMutableArray arrayWithArray:((ListDataModel*)([data model])).posts];
  
  
  selectedRow = selectedCusine;
   
}

- (void) showHidePicker
{
   // Picker View Show in animation
  [picker selectRow:selectedRow inComponent:0 animated:NO];
   
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


- (void) dealloc {
  [picker release];
  //[titleView release];
  [arView release];
  [_ARData release];
	[banner release];
  [mapViewController release];
  TT_RELEASE_SAFELY(listMapButton);
  TT_RELEASE_SAFELY(arButton);
  [super dealloc];
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

#pragma mark UIPickerViewDelegate

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

   
   NSMutableArray *keys = [NSMutableArray arrayWithObjects: @"cuisineTypeID",@"pageNum", @"resultsPerPage", 
           nil];
   
   NSMutableArray *values = [NSMutableArray arrayWithObjects: cuisineID,
             @"1",@"20",
             nil];
  
  if ([selectedAllBanks count]) {
    [keys addObject:@"cardtype_id"];
    NSArray *uniqueArray = [[NSSet setWithArray:selectedAllBanks] allObjects];
    NSString *cardString = [uniqueArray componentsJoinedByString:@","];
    NSLog(@"cardString:%@", cardString);
    [values addObject:cardString]; 
  }
  
  ListDataSource * data = [[[ListDataSource alloc] initWithType:@"Cuisine" andSortBy:@"Cuisine" withKeys: keys andValues: values] autorelease];
  data.delegate = self;
  self.dataSource = data;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (id<UITableViewDelegate>)createDelegate {
  return [[[ListTableDelegate alloc] initWithController:self] autorelease];
}

- (void)modelDidFinishLoad:(id <TTModel>)model {
  [super modelDidFinishLoad:model];
  [mapViewController showMapWithData: [(ListDataModel*)self.model posts]];
}

#pragma mark -
#pragma mark TTTableViewController

- (void)didSelectObject:(id)object atIndexPath:(NSIndexPath *)indexPath {
  NSLog(@"didSelectObject");
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
	[self updateSelectAll];
    [self createModel];
  } else {
    [super didSelectObject:object atIndexPath:indexPath];
  }
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  NSLog(@"reload card");
  AppDelegate* ad = (AppDelegate*)[[UIApplication sharedApplication] delegate];
  cardTable.dataSource = ad.cardChainDataSource;
  selectedBanks = ad.cardChainDataSource.selectedBanks;
  [self updateSelectAll];
  [cardTable reloadData];
  
  if (ad.cuisineShouldReload) {
    [self createModel];
    ad.cuisineShouldReload = NO;
  }
  //[[TTNavigator navigator].window bringSubviewToFront:banner];
	
  //NSURLRequest* bannerRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:URL_BANNER_AD_CUISINE]];
  //[ad.banner loadRequest:bannerRequest];
	
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
		[analytics setObject:@"CUISINE" forKey:@"CATEGORY"];
		[analytics setObject:webRequest.URL forKey:@"URL"];
		[FlurryAPI logEvent:@"BANNER_CLICK" withParameters:analytics];
		[analytics release];
		
		TTOpenURL([NSString stringWithFormat:@"%@", webRequest.URL]);
		
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
