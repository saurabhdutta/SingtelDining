//
//  RestaurantsViewController.m
//  SingtelDining
//
//  Created by Alex Yao on 6/16/10.
//  Copyright 2010 CellCity. All rights reserved.
//

#import <extThree20JSON/extThree20JSON.h>
#import "RestaurantsViewController.h"
#import "SDListView.h"
#import "ListDataSource.h"
#import "ARViewController.h"
#import "MobileIdentifier.h"
#import "MapViewController.h"
#import "AppDelegate.h"
#import "StringTable.h"


@implementation RestaurantsViewController
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
   NSLog(@"setting ARData in RestaurantsViewController!\n");
   _ARData = [[NSMutableArray arrayWithArray:array] retain];
   //NSLog(@"Data %@",_ARData);
   
   
}*/

#pragma mark -
- (IBAction)selectCard:(id)sender {
  
}

#pragma mark -

- (id)init {
  if (self = [super init]) {
    
    selectedCards = [[NSMutableArray alloc] init];
  }
  return self;
}

- (void)loadView {
  [super loadView];
  
  UIButton *settingButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 34, 34)];
  [settingButton setImage:[UIImage imageNamed:@"button-setting.png"] forState:UIControlStateNormal];
  [settingButton addTarget:kAppCreditURLPath action:@selector(openURLFromButton:) forControlEvents:UIControlEventTouchUpInside];
  UIBarButtonItem *barSettingButton = [[UIBarButtonItem alloc] initWithCustomView:settingButton];
  [settingButton release];
  self.navigationItem.leftBarButtonItem = barSettingButton;
  [barSettingButton release];
  
  SDListView *boxView = [[SDListView alloc] initWithFrame:CGRectMake(5, 0, 310, 280)];
   
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
         UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(37, 2, 160, 30)];
         searchBar.delegate = self;
         searchBar.placeholder = @"keyword";
        searchBar.tag = 1001;
         [[searchBar.subviews objectAtIndex:0] setHidden:YES];
         [titleBar addSubview:searchBar];
         TT_RELEASE_SAFELY(searchBar);
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
      mapViewController.view.tag = 1002;
      mapViewController.view.hidden = YES;
      [boxView addSubview:mapViewController.view];
   }
  
   boxView.tag = 200;
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
  cardTable.dataSource = [[HTableDataSource alloc] init];
  cardTable.rowHeight = 95;
  cardTable.delegate = [[TTTableViewPlainDelegate alloc] initWithController:self];
  cardTable.tag = 22;
  [self.view addSubview:cardTable];
   
   arView = [[ARViewController alloc] init];
   [self.view addSubview:arView.view];
   arView.view.hidden = TRUE;
  
  
  NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
  [nc addObserver:self selector:@selector(keyboardWillShow:) name: UIKeyboardWillShowNotification object:nil];
  [nc addObserver:self selector:@selector(keyboardWillHide:) name: UIKeyboardWillHideNotification object:nil];
  
  keyboardBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 480, 320, 40)];
  UIBarButtonItem *flexSpaceButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
  UIBarButtonItem *dismissKeyboardButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStyleBordered target:self action:@selector(dismissKeyboard:)];
  [keyboardBar setItems:[NSArray arrayWithObjects:flexSpaceButton, dismissKeyboardButton, nil]];
  TT_RELEASE_SAFELY(dismissKeyboardButton);
  TT_RELEASE_SAFELY(flexSpaceButton);
  [self.view addSubview:keyboardBar];
}


- (void) dealloc
{
  TT_RELEASE_SAFELY(keyboardBar);
   [arView release];
   [_ARData release];
   [mapViewController release];
   [super dealloc];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)createModel {
   
  NSMutableArray *keys = [NSMutableArray arrayWithObjects: @"resultsPerPage", 
                   nil];

  NSMutableArray *values = [NSMutableArray arrayWithObjects: @"10",
                     nil];
  if ([selectedCards count]) {
    [keys addObject:@"bank"];
    NSString *cardString = [selectedCards componentsJoinedByString:@","];
    NSLog(@"cardString:%@", cardString);
    [values addObject:cardString]; 
  }

  ListDataSource * data = [[[ListDataSource alloc] initWithType:@"Restaurants" andSortBy:@"Name" withKeys: keys andValues: values] autorelease];
  data.delegate = self;
  self.dataSource = data;


  _ARData = [NSMutableArray arrayWithArray:((ListDataModel*)([data model])).posts];
   
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (id<UITableViewDelegate>)createDelegate {
  return [[[TTTableViewPlainVarHeightDelegate alloc] initWithController:self] autorelease];
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
    
    if ([selectedCards containsObject:item.userInfo]) {
      [selectedCards removeObject:item.userInfo];
    } else {
      [selectedCards addObject:item.userInfo];
    }
    
    [self createModel];
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

/////////////////////////////////////////////////////////////////////////////////////
#pragma mark UISearchBarDelegate

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
   // Configure our TTModel with the user's search terms
   // and tell the TTModelViewController to reload.
   [searchBar resignFirstResponder];
   self.dataSource = [[[ListDataSource alloc] initWithSearchKeyword:[searchBar text]] autorelease];
   [self reload];
   [self.tableView scrollToTop:YES];
}

- (IBAction)dismissKeyboard:(id)sender {
  [[self.view viewWithTag:1001] resignFirstResponder];
}

-(void) keyboardWillShow:(NSNotification *)notification{
  
  [UIView beginAnimations:nil context:NULL];
  [UIView setAnimationCurve:[[[notification userInfo] objectForKey:UIKeyboardAnimationCurveUserInfoKey] intValue]];
  [UIView setAnimationDuration:[[[notification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue]];
  
  CGRect frame = keyboardBar.frame;
  frame.origin.y -= [[[notification userInfo] objectForKey:UIKeyboardBoundsUserInfoKey] CGRectValue].size.height +100;
  keyboardBar.frame = frame;
  
  [UIView commitAnimations];
}

-(void) keyboardWillHide:(NSNotification *)notification{
  [UIView beginAnimations:nil context:NULL];
  [UIView setAnimationCurve:[[[notification userInfo] objectForKey:UIKeyboardAnimationCurveUserInfoKey] intValue]];
  [UIView setAnimationDuration:[[[notification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue]];
  
  CGRect frame = keyboardBar.frame;
  frame.origin.y += [[[notification userInfo] objectForKey:UIKeyboardBoundsUserInfoKey] CGRectValue].size.height +100;
  keyboardBar.frame = frame;
  
  [UIView commitAnimations];
}
@end
