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
   NSLog(@"setting ARData in RestaurantsViewController!\n");
   _ARData = [[NSMutableArray arrayWithArray:array] retain];
   //NSLog(@"Data %@",_ARData);
   
   
}*/

#pragma mark -
- (IBAction)selectCard:(id)sender {
  
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
  [self.view addSubview:cardTableBg];
  TT_RELEASE_SAFELY(cardTableBg);
  
  cardTable = [[HTableView alloc] initWithFrame:CGRectMake(10, 291, 300, 60) style:UITableViewStylePlain];
  cardTable.dataSource = [[HTableDataSource alloc] init];
  cardTable.rowHeight = 95;
  cardTable.delegate = [[TTTableViewPlainDelegate alloc] initWithController:self];
  cardTable.tag = 22;
  [self.view addSubview:cardTable];
   
   arView = [[ARViewController alloc] init];
   [self.view addSubview:arView.view];
   arView.view.hidden = TRUE;
}


- (void) dealloc
{

   [arView release];
   [_ARData release];
   [mapViewController release];
   [super dealloc];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)createModel {
   
   NSArray *keys = [NSArray arrayWithObjects: @"resultsPerPage", 
                     nil];
   
   NSArray *values = [NSArray arrayWithObjects: @"10",
                       nil];
   
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
