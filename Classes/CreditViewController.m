//
//  CreditViewController.m
//  SingtelDining
//
//  Created by Alex Yao on 6/11/10.
//  Copyright 2010 CellCity. All rights reserved.
//

#import "CreditViewController.h"
#import "SDBoxView.h"


@implementation CreditViewController

#pragma mark -
- (void)doneButtonClicked {
  // 
  [self dismissModalViewControllerAnimated:YES];
}

- (IBAction)segmentButtonClicked:(UIButton *)button {
  
  if (button.selected == NO) {
    button.selected = YES;
    NSLog(@"tag: %i",abs(button.tag - 1));
    UIButton *anotherButton = (UIButton *)[[button superview] viewWithTag:(button.tag == 1)?2:1];
    anotherButton.selected = NO;
  } else {
    NSLog(@"ignore radio button click event");
  }
}

#pragma mark -
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
  self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg.png"]];
  
  //UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleBordered target:self action:@selector(doneButtonClicked)];
  UIButton *doneButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 57, 30)];
  [doneButton setImage:[UIImage imageNamed:@"button-done.png"] forState:UIControlStateNormal];
  [doneButton addTarget:self action:@selector(doneButtonClicked) forControlEvents:UIControlEventTouchUpInside];
  UIBarButtonItem *barDoneButton = [[UIBarButtonItem alloc] initWithCustomView:doneButton];
  [doneButton release];
  self.navigationItem.rightBarButtonItem = barDoneButton;
  [barDoneButton release];
  
  // box view
  UIImageView *titleView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 128, 19)];
  titleView.image = [UIImage imageNamed:@"credit-title.png"];
  SDBoxView *boxView = [[SDBoxView alloc] initWithFrame:CGRectMake(5, 0, 310, kBoxMaxHeight) titleView:titleView];
  [titleView release];
  
  // card selection button
  {
    /*
    UISegmentedControl *cardSegment = [[UISegmentedControl alloc] initWithFrame:CGRectMake(5, 40, 300, 34)];
    //cardSegment.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"card-segment-bg.png"]];
    //cardSegment.segmentedControlStyle = UISegmentedControlStyleBordered;
    cardSegment.tintColor = [UIColor clearColor];
    [cardSegment insertSegmentWithTitle:@"All Credit Cards" atIndex:0 animated:NO];
    [cardSegment insertSegmentWithTitle:@"My Credit Cards" atIndex:1 animated:NO];
    [boxView addSubview:cardSegment];
    [cardSegment release];
    */
    UIButton *allCardButton = [[UIButton alloc] initWithFrame:CGRectMake(40, 45, 107, 20)];
    [allCardButton setImage:[UIImage imageNamed:@"all-card.png"] forState:UIControlStateNormal];
    [allCardButton setImage:[UIImage imageNamed:@"all-card-selected.png"] forState:UIControlStateSelected];
    [allCardButton addTarget:self action:@selector(segmentButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [allCardButton setTag:1];
    [allCardButton setSelected:YES];
    [boxView addSubview:allCardButton];
    [allCardButton release];
    
    UIButton *myCardButton = [[UIButton alloc] initWithFrame:CGRectMake(160, 45, 110, 20)];
    [myCardButton setImage:[UIImage imageNamed:@"my-card.png"] forState:UIControlStateNormal];
    [myCardButton setImage:[UIImage imageNamed:@"my-card-selected.png"] forState:UIControlStateSelected];
    [myCardButton addTarget:self action:@selector(segmentButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [myCardButton setTag:2];
    [boxView addSubview:myCardButton];
    [myCardButton release];
    
    /*
    UIImageView *bankIcons = [[UIImageView alloc] initWithFrame:CGRectMake(4, 80, 302, 92)];
    bankIcons.image = [UIImage imageNamed:@"select-bank-icons.png"];
    [boxView addSubview:bankIcons];
    [bankIcons release];
    */
    
    TTTabBar *bankTabs = [[TTTabStrip alloc] initWithFrame:CGRectMake(4, 80, 302, 40)];
    [bankTabs setTabStyle:@"launcherButtonImage:"];
    [bankTabs setDelegate:self];
    TTTabItem *item = [[TTTabItem alloc] initWithTitle:@"UOB"];
    item.icon = @"bundle://uob-card.png";
    bankTabs.tabItems = [NSArray arrayWithObjects: 
                         item,
                         item,
                         item,
                         item,
                         item,
                         item,
                         item,
                         item,
                         nil];
    [item release];
    [boxView addSubview:bankTabs];
    [bankTabs release];
    
    // bank card table
    {
      TTTableView *cardTable = [[TTTableView alloc] initWithFrame:CGRectMake(0, 130, 310, 280) 
                                                            style:UITableViewStyleGrouped];
      cardTable.backgroundColor = [UIColor clearColor];
      cardTable.dataSource = [[TTListDataSource dataSourceWithObjects:
                              [TTTableTextItem itemWithText:@"UOB Visa Infinite Card"], 
                              [TTTableTextItem itemWithText:@"UOB Visa Cold Card"], 
                              [TTTableTextItem itemWithText:@"UOB Lady's Card"], 
                              [TTTableTextItem itemWithText:@"UOB Master Card Classic Card"], 
                              [TTTableTextItem itemWithText:@"UOB Visa Classic Card"], 
                              [TTTableTextItem itemWithText:@"UOB Visa Infinite Card"], 
                              [TTTableTextItem itemWithText:@"UOB Visa Cold Card"], 
                              [TTTableTextItem itemWithText:@"UOB Lady's Card"], 
                              [TTTableTextItem itemWithText:@"UOB Master Card Classic Card"], 
                              [TTTableTextItem itemWithText:@"UOB Visa Classic Card"],
                              nil] retain];
      [boxView addSubview:cardTable];
      [cardTable release];
    }
  }
  
  [self.view addSubview:boxView];
  [boxView release];
  
  self.navigationController.navigationBar.backgroundColor = [UIColor clearColor];
}

#pragma mark -
#pragma mark TTTabDelegate
- (void)tabBar:(TTTabBar*)tabBar tabSelected:(NSInteger)selectedIndex {
  NSLog(@"tab selected index: %i", selectedIndex);
}

@end
