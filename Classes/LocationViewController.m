//
//  LocationViewController.m
//  SingtelDining
//
//  Created by Alex Yao on 6/14/10.
//  Copyright 2010 CellCity. All rights reserved.
//

#import "LocationViewController.h"
#import "TableListViewController.h"


@implementation LocationViewController

#pragma mark -

- (void)settingButtonClicked:(id)sender {
  TTNavigator *navigator = [TTNavigator navigator];
  [navigator openURLAction:[[TTURLAction actionWithURLPath:kAppCuisinesURLPath] applyAnimated:YES]];
}

- (void)toggleListView:(id)sender {
  NSLog(@"toggle %i", [sender selectedSegmentIndex]);
  UIView *tableView = [[self.view viewWithTag:100] viewWithTag:1001];
  UIView *mapView = [[self.view viewWithTag:100] viewWithTag:1002];
  tableView.hidden = mapView.hidden;
  mapView.hidden = !tableView.hidden;
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
	[super dealloc];
}

#pragma mark -
#pragma mark TTViewController
- (void)loadView {
  [super loadView];
  self.view.backgroundColor = [UIColor clearColor];
  self.navigationController.navigationBar.backgroundColor = [UIColor clearColor];
  
  // tab bar item
  //self.tabBarItem = [[[UITabBarItem alloc] initWithTitle:@"" image:[UIImage imageNamed:@"tab-location.png"] tag:1] autorelease];
  UIButton *settingButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 34, 34)];
  [settingButton setImage:[UIImage imageNamed:@"button-setting.png"] forState:UIControlStateNormal];
  [settingButton addTarget:self action:@selector(settingButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
  UIBarButtonItem *barSettingButton = [[UIBarButtonItem alloc] initWithCustomView:settingButton];
  [settingButton release];
  self.navigationItem.leftBarButtonItem = barSettingButton;
  [barSettingButton release];

  
  UIView *boxView = [[UIView alloc] initWithFrame:CGRectMake(5, 0, 310, 360)];
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
      /*
      dropdownBox.layer.cornerRadius = 6;
      dropdownBox.layer.masksToBounds = YES;
      dropdownBox.layer.borderColor = [[UIColor grayColor] CGColor];
      dropdownBox.layer.borderWidth = 2;
      dropdownBox.backgroundColor = [UIColor whiteColor];
      */
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
        //TTTableView *tableView = [[TTTableView alloc] initWithFrame:CGRectMake(5, 40, 300, 300)];
        TTTableView *tableView = [[TTTableView alloc] initWithFrame:CGRectMake(5, 40, 300, 315)];
        tableView.delegate = self;
        tableView.tag = 1001;
        tableView.dataSource = [[TTListDataSource dataSourceWithItems:
                                [NSArray arrayWithObjects:
                                 [TTTableSubtitleItem itemWithText:@"Aans Korea Resturants" subtitle:@"Orchard Central, #12-08" imageURL:@"bundle://sample-list-image.png" URL:kAppLocaltionURLPath],
                                 [TTTableSubtitleItem itemWithText:@"Aans Korea Resturants" subtitle:@"Orchard Central, #12-08" imageURL:@"bundle://sample-list-image.png" URL:kAppLocaltionURLPath],
                                 [TTTableSubtitleItem itemWithText:@"Aans Korea Resturants" subtitle:@"Orchard Central, #12-08" imageURL:@"bundle://sample-list-image.png" URL:kAppLocaltionURLPath],
                                 [TTTableSubtitleItem itemWithText:@"Aans Korea Resturants" subtitle:@"Orchard Central, #12-08" imageURL:@"bundle://sample-list-image.png" URL:kAppLocaltionURLPath],
                                 [TTTableSubtitleItem itemWithText:@"Aans Korea Resturants" subtitle:@"Orchard Central, #12-08" imageURL:@"bundle://sample-list-image.png" URL:kAppLocaltionURLPath],
                                 [TTTableSubtitleItem itemWithText:@"Aans Korea Resturants" subtitle:@"Orchard Central, #12-08" imageURL:@"bundle://sample-list-image.png" URL:kAppLocaltionURLPath],
                                 [TTTableSubtitleItem itemWithText:@"Aans Korea Resturants" subtitle:@"Orchard Central, #12-08" imageURL:@"bundle://sample-list-image.png" URL:kAppLocaltionURLPath],
                                 [TTTableSubtitleItem itemWithText:@"Aans Korea Resturants" subtitle:@"Orchard Central, #12-08" imageURL:@"bundle://sample-list-image.png" URL:kAppLocaltionURLPath],
                                 nil]] 
                                retain];
        
        [boxView addSubview:tableView];
        [tableView release];
      }
        // map view
      {
        MKMapView *mapView = [[MKMapView alloc] initWithFrame:CGRectMake(5, 40, 300, 315)];
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
  
  UILabel *testLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 20)];
  testLabel.textAlignment = UITextAlignmentCenter;
  //testLabel.text = @"location world";
  testLabel.backgroundColor = [UIColor clearColor];
  [self.view addSubview:testLabel];
  [testLabel release];
  
}

@end
