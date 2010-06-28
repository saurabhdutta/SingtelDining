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
   mapView = [self.view viewWithTag:1001];
   
   if ([sender selectedSegmentIndex] == 0)
   {
      mapViewController.view.hidden = mapView.hidden;
      
      mapView.hidden = !mapViewController.view.hidden;
   }
   else {
      
      mapView.hidden = TRUE;
   }
   
   showMap = TRUE;
   [self sendURLRequest];
   if([sender selectedSegmentIndex] == 1) 
   {
      if(![[MobileIdentifier getMobileName] isEqualToString:@"iPhone1,1"] && ![[MobileIdentifier getMobileName] isEqualToString:@"iPhone1,2"] &&
         ![[MobileIdentifier getMobileName] isEqualToString:@"iPod1,1"] && ![[MobileIdentifier getMobileName] isEqualToString:@"iPod2,1"])
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
   
   NSString *url = [NSString stringWithFormat:@"%@?latitude=%f&longitude=%f&pageNum=1&resultsPerPage=15",
                    URL_SEARCH_NEARBY, delegate.currentGeo.latitude,delegate.currentGeo.longitude];
   
   
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
   
   _ARData = [[NSMutableArray arrayWithArray:[feed objectForKey:@"data"]] retain];
   
   
   if(showMap)
      [mapViewController showMapWithData:_ARData];
   else {
      
      arView.view.hidden = FALSE;
      [self.navigationController pushViewController:arView animated:NO];
      [arView showAR:_ARData owner:self callback:@selector(closeARView)];
   }
   
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
   NSString *path = [[NSBundle mainBundle] pathForResource:@"Food" ofType:@"plist"];
   
   
   cusines = [[NSArray alloc]initWithContentsOfFile:path];
   
   
   
   boxView = [[SDListView alloc] initWithFrame:CGRectMake(5, 0, 310, 275)];
   
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
   }
  
  {
    self.tableView.frame = CGRectMake(5, 40, 300, 230);
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
   
   
   arView = [[ARViewController alloc] init];
   [self.view addSubview:arView.view];
   arView.view.hidden = TRUE;
   
   

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

   ListDataSource * data = [[[ListDataSource alloc] initWithType:@"Cuisine" andSortBy:@"Cuisine" withKeys: keys andValues: values] autorelease];
   data.delegate = self;
   self.dataSource = data;
   
   
   _ARData = [NSMutableArray arrayWithArray:((ListDataModel*)([data model])).posts];
  
}


- (void) dealloc
{
   [picker release];
   [titleView release];
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
   
   ListDataSource * data = [[[ListDataSource alloc] initWithType:@"Cuisine" andSortBy:@"Cuisine" withKeys: keys andValues: values] autorelease];
   data.delegate = self;
   self.dataSource = data;
   
   
   _ARData = [NSMutableArray arrayWithArray:((ListDataModel*)([data model])).posts];
   
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (id<UITableViewDelegate>)createDelegate {
  return [[[TTTableViewDragRefreshDelegate alloc] initWithController:self] autorelease];
}

@end
