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
   
	[super dealloc];
}

#pragma mark -
#pragma mark TTViewController
- (void)loadView {
  [super loadView];
   
   [self searchRestaurants];
  
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

  
  UIView *boxView = [[UIView alloc] initWithFrame:CGRectMake(5, 0, 310, 305)];
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

      // text
      {
        UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(8, 5, 140, 18)];
        textLabel.text = @"Locations-Nearby";
        textLabel.font = [UIFont systemFontOfSize:14];
        textLabel.backgroundColor = [UIColor clearColor];
        textLabel.textColor = [UIColor redColor];
        [dropdownBox addSubview:textLabel];
        [textLabel release];
      }
      
      
      
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
  
   // ARView
   {
      //UIWindow* window = (UIWindow*)[[[UIApplication sharedApplication] delegate] window];
      arView = [[ARViewController alloc] init];
      [self.view addSubview:arView.view];
      arView.view.hidden = TRUE;
      
   }
  
}

-(void) searchRestaurants
{
   /*NSArray * keys = [NSArray arrayWithObjects: @"latitude", @"longitude", @"pageNum", @"resultsPerPage", 
                     nil];
   
   NSArray * values = [NSArray arrayWithObjects: @"1.3027", @"103.8372", @"1",@"10",
                       nil];
   
   if( request == nil ) request = [[JSONRequest alloc] initWithOwner:self];
   
   [request loadData: URL_SEARCH pkeys:keys pvalues:values];*/
}

/*- (void) onDataLoad: (NSMutableArray *) results
{
   NSLog(@"results %@\n",[results objectAtIndex:0]);
}*/

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)createModel {
   NSLog(@"Creating Model for Location\n");
   
   ListDataSource * data  = [[[ListDataSource alloc] initWithType:@"any"] autorelease];
  /* NSString *path = [[NSBundle mainBundle] pathForResource:@"Testing" ofType:@"plist"];
   tempListings = [[NSArray alloc]initWithContentsOfFile:path];
   [data setListings:tempListings];*/
   self.dataSource = data;
   
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (id<UITableViewDelegate>)createDelegate {
  return [[[TTTableViewDragRefreshDelegate alloc] initWithController:self] autorelease];
}


@end
