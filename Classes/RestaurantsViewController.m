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
#import "DetailsViewController.h"

// Flurry analytics
#import "FlurryAPI.h"


@implementation RestaurantsViewController
@synthesize arView;

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
    mapViewController.view.hidden = !mapViewController.view.hidden;
    
    mapView.hidden = !mapView.hidden;
    
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
    } else {
      arView.view.hidden = NO;
      [self.navigationController pushViewController:arView animated:NO];
      [arView showAR:[(ListDataModel*)self.model posts] owner:self callback:@selector(closeARView:)];
    }
  }
/*
  showMap = TRUE;
  
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
   
   NSString *url = [NSString stringWithFormat:@"%@?latitude=%f&longitude=%f&pageNum=1&resultsPerPage=15",
                    URL_SEARCH_NEARBY, delegate.currentGeo.latitude,delegate.currentGeo.longitude];
   
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
  [listMapButton setEnabled:TRUE];
  [arButton setEnabled:TRUE];
   
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
- (void)refreshButtonClicked {
  NSInteger itemsCount = [self.tableView numberOfRowsInSection:0];
  if (itemsCount > 0) {
    [super reload];
  } else {
    [searchBar setText:@""];
    [self createModel];
  }
}

#pragma mark -

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
  if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
  }
  return self;
}

- (void)loadView {
  [super loadView];
  
  AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
  selectedBanks = delegate.cardChainDataSource.selectedBanks;
  
  boxView = [[SDListView alloc] initWithFrame:CGRectMake(5, 0, 310, 280)];
   
   {
      TTView *titleBar = [[TTView alloc] initWithFrame:CGRectMake(0, 0, 310, 34)];
      titleBar.style = [[TTStyleSheet globalStyleSheet] styleWithSelector:@"searchBar"];
      titleBar.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin;
      // refresh button
      {
         UIButton *refreshButton = [[UIButton alloc] initWithFrame:CGRectMake(2, 0, 34, 33)];
         [refreshButton setImage:[UIImage imageNamed:@"button-refresh.png"] forState:UIControlStateNormal];
         [refreshButton addTarget:@"#refreshButtonClicked" action:@selector(openURLFromButton:) forControlEvents:UIControlEventTouchUpInside];
         [titleBar addSubview:refreshButton];
         [refreshButton release];
      }
      
      // dropdown box
      {
        searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(37, 2, 160, 30)];
        searchBar.delegate = self;
        searchBar.placeholder = @"keyword";
        searchBar.tag = 1022;
        [[searchBar.subviews objectAtIndex:0] removeFromSuperview];
        [titleBar addSubview:searchBar];
        //TT_RELEASE_SAFELY(searchBar);
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
  //cardTable.dataSource = [[HTableDataSource alloc] init];
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
}


- (void) dealloc {
  [arView release];
  [_ARData release];
  [mapViewController release];
  TT_RELEASE_SAFELY(listMapButton);
  TT_RELEASE_SAFELY(arButton);
  TT_RELEASE_SAFELY(searchBar);
  [super dealloc];
}

- (void)viewDidLoad {
  [super viewDidLoad];
  // Flurry analytics
  [FlurryAPI countPageViews:self.navigationController];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)createModel {
   
  NSMutableArray *keys = [NSMutableArray arrayWithObjects: @"resultsPerPage", 
                   nil];

  NSMutableArray *values = [NSMutableArray arrayWithObjects: @"20",
                     nil];
  if ([selectedBanks count]) {
    [keys addObject:@"bank"];
    NSArray *uniqueArray = [[NSSet setWithArray:selectedBanks] allObjects];
    NSString *cardString = [uniqueArray componentsJoinedByString:@","];
    NSLog(@"cardString:%@", cardString);
    [values addObject:cardString]; 
  }

  ListDataSource * data = [[[ListDataSource alloc] initWithType:@"Restaurants" andSortBy:@"Name" withKeys: keys andValues: values] autorelease];
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
    [self createModel];
  } else {
    [super didSelectObject:object atIndexPath:indexPath];
  }
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  NSLog(@"reload card");
  AppDelegate* ad = [[UIApplication sharedApplication] delegate];
  cardTable.dataSource = ad.cardChainDataSource;
  selectedBanks = ad.cardChainDataSource.selectedBanks;
  [cardTable reloadData];
  
  if (ad.restaurantsShouldReload) {
    [self createModel];
    ad.restaurantsShouldReload = NO;
  }
  
  [[TTNavigator navigator].window bringSubviewToFront:ad.banner];
  ad.banner.hidden = NO;
}

- (void)viewWillDisappear:(BOOL)animated {
  [super viewWillDisappear:animated];
  
  AppDelegate* ad = (AppDelegate*)[[UIApplication sharedApplication] delegate];
  ad.banner.hidden = YES;
}

/////////////////////////////////////////////////////////////////////////////////////
#pragma mark UISearchBarDelegate

- (void)searchBarSearchButtonClicked:(UISearchBar *)theSearchBar
{
  [theSearchBar resignFirstResponder];
  
  NSMutableDictionary* query = [[NSMutableDictionary alloc] init];
  NSString* keyword = [theSearchBar.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
  if ([selectedBanks count]) {
    NSArray *uniqueArray = [[NSSet setWithArray:selectedBanks] allObjects];
    NSString *cardString = [uniqueArray componentsJoinedByString:@","];
    [query setObject:[cardString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:@"bank"];
  }
  
  if (!TTIsStringWithAnyText(keyword)) {
    keyword = @"";
  }
  [query setObject:keyword forKey:@"keyword"];
  
  self.dataSource = [[[ListDataSource alloc] initWithQuery:query] autorelease];
  [self reload];
  [self.tableView scrollToTop:YES];
}

- (IBAction)doSearch:(id)sender {
  [self performSelector:@selector(searchBarSearchButtonClicked:) withObject:[self.view viewWithTag:1022]];
}

- (IBAction)dismissKeyboard:(id)sender {
  [[self.view viewWithTag:1022] resignFirstResponder];
}

-(void) keyboardWillShow:(NSNotification *)notification{
  
  UIButton *cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 57, 30)];
  [cancelButton setImage:[UIImage imageNamed:@"button-cancel.png"] forState:UIControlStateNormal];
  [cancelButton addTarget:self action:@selector(dismissKeyboard:) forControlEvents:UIControlEventTouchUpInside];
  UIBarButtonItem *barCancelButton = [[UIBarButtonItem alloc] initWithCustomView:cancelButton];
  [cancelButton release];
  self.navigationItem.leftBarButtonItem = barCancelButton;
  [barCancelButton release];
  
  UIButton *doneButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 57, 30)];
  [doneButton setImage:[UIImage imageNamed:@"button-done.png"] forState:UIControlStateNormal];
  [doneButton addTarget:self action:@selector(doSearch:) forControlEvents:UIControlEventTouchUpInside];
  UIBarButtonItem *barDoneButton = [[UIBarButtonItem alloc] initWithCustomView:doneButton];
  [doneButton release];
  self.navigationItem.rightBarButtonItem = barDoneButton;
  [barDoneButton release];
}

-(void) keyboardWillHide:(NSNotification *)notification{
  self.navigationItem.leftBarButtonItem = nil;
  self.navigationItem.rightBarButtonItem = nil;
}
@end
