//
//  CreditViewController.m
//  SingtelDining
//
//  Created by Alex Yao on 6/11/10.
//  Copyright 2010 CellCity. All rights reserved.
//

#define kImageChecked @"bundle://checked.png"
#define kImageUnchecked @"bundle://unchecked.png"


#import "CreditViewController.h"
#import "SDBoxView.h"


@implementation CreditViewController

#pragma mark -

- (void)yesToAlert {
  
}

- (void)noToAlert {
  [self dismissModalViewControllerAnimated:YES];
}

- (void)doneButtonClicked {
  UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil 
                                                  message:@"You haven't selected your credit cards, Do you want to go back and configure?" 
                                                 delegate:self 
                                        cancelButtonTitle:@"Yes" 
                                        otherButtonTitles:nil];
  [alert addButtonWithTitle:@"No"];
  [alert show];
  [alert release];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
  switch (buttonIndex) {
    case 0:
      NSLog(@"button 0");
      [self yesToAlert];
      break;
      
    case 1:
      NSLog(@"button 1");
      [self noToAlert];
      break;

    default:
      break;
  }
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
    self.tableViewStyle = UITableViewStyleGrouped;
    selectedCards = [[NSMutableDictionary alloc] init];
    NSMutableArray *tmpArray = [[NSMutableArray alloc] init];
    [selectedCards setObject:[NSMutableArray arrayWithArray:tmpArray] forKey:@"UOB"];
    [selectedCards setObject:[NSMutableArray arrayWithArray:tmpArray] forKey:@"POSB"];
    [selectedCards setObject:[NSMutableArray arrayWithArray:tmpArray] forKey:@"OCBC"];
    [selectedCards setObject:[NSMutableArray arrayWithArray:tmpArray] forKey:@"DBS"];
    [tmpArray release];
  }
  return self;
}

- (void)dealloc {
  [selectedCards release];
	[super dealloc];
}

#pragma mark -
#pragma mark TTViewController
- (void)loadView {
  [super loadView];
  self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg.png"]];
  self.navigationController.navigationBar.backgroundColor = [UIColor clearColor];
  
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
      self.tableView.backgroundColor = [UIColor clearColor];
      self.tableView.frame = CGRectMake(0, 130, 310, 280);
      self.tableViewStyle = UITableViewStyleGrouped;
      self.variableHeightRows = YES;
      self.dataSource = [TTListDataSource dataSourceWithObjects:
                              [TTTableRightImageItem itemWithText:@"UOB Visa Infinite Card" imageURL:kImageUnchecked], 
                              [TTTableRightImageItem itemWithText:@"UOB Visa Cold Card" imageURL:kImageUnchecked],
                              [TTTableRightImageItem itemWithText:@"UOB Lady's Card" imageURL:kImageUnchecked],
                              [TTTableRightImageItem itemWithText:@"UOB Master Card Classic Card" imageURL:kImageUnchecked],
                              [TTTableRightImageItem itemWithText:@"UOB Visa Classic Card" imageURL:kImageUnchecked],
                              [TTTableRightImageItem itemWithText:@"UOB Visa Infinite Card" imageURL:kImageUnchecked],
                              [TTTableRightImageItem itemWithText:@"UOB Visa Cold Card" imageURL:kImageUnchecked],
                              [TTTableRightImageItem itemWithText:@"UOB Lady's Card" imageURL:kImageUnchecked],
                              [TTTableRightImageItem itemWithText:@"UOB Master Card Classic Card" imageURL:kImageUnchecked],
                              [TTTableRightImageItem itemWithText:@"UOB Visa Infinite Card" imageURL:kImageUnchecked], 
                              nil];
      [boxView addSubview:self.tableView];
    }
  }
  
  [self.view addSubview:boxView];
  [boxView release];
}

#pragma mark -
#pragma mark TTTabDelegate
- (void)tabBar:(TTTabBar*)tabBar tabSelected:(NSInteger)selectedIndex {
  NSLog(@"tab selected index: %i", selectedIndex);
}

#pragma mark -
#pragma mark TTTableViewDelegate
- (void)didSelectObject:(id)object atIndexPath:(NSIndexPath *)indexPath {
  
  if([object isKindOfClass:[TTTableRightImageItem class]]) {
    
    //TTTableImageItemCell *cell = (TTTableImageItemCell *)[self.tableView cellForRowAtIndexPath:indexPath];
    
    NSMutableArray *bank = [selectedCards objectForKey:@"UOB"];
    NSNumber *row = [NSNumber numberWithInt:indexPath.row];
    
    if ([object imageURL] == kImageUnchecked) {
      [object setImageURL:kImageChecked];
      if (![bank containsObject:row]) {
        [bank addObject:row];
      }
    } else {
      [object setImageURL:kImageUnchecked];
      if ([bank containsObject:row]) {
        [bank removeObject:row];
      }
    }
    
    NSLog(@"cards: %@", selectedCards);
    
    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationNone];
  } else
    [super didSelectObject:object atIndexPath:indexPath];
}

@end
