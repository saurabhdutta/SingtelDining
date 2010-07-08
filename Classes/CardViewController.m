//
//  CardViewController.m
//  SingtelDining
//
//  Created by Alex Yao Cheng on 7/5/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "CardViewController.h"
#import "CardSettingDataSource.h"
#import "SDBoxView.h"


@implementation CardViewController

#pragma mark -
#pragma mark IBAction
- (IBAction)doneButtonClicked:(id)sender {
  
  if (!userSelectedIndexPaths.count && !isSelectAll ) {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil 
                                                    message:@"You haven't selected your credit cards, Do you want to go back and configure?" 
                                                   delegate:self 
                                          cancelButtonTitle:@"Yes" 
                                          otherButtonTitles:nil];
    [alert addButtonWithTitle:@"No"];
    [alert show];
    [alert release];
  } else {
    NSMutableDictionary* selectedCards = [[NSMutableDictionary alloc] init];
    [selectedCards setObject:[NSMutableArray array] forKey:@"Citibank"];
    [selectedCards setObject:[NSMutableArray array] forKey:@"DBS"];
    [selectedCards setObject:[NSMutableArray array] forKey:@"OCBC"];
    [selectedCards setObject:[NSMutableArray array] forKey:@"UOB"];
    NSArray* bankArray = [NSArray arrayWithObjects:@"Citibank", @"DBS", @"OCBC", @"UOB", nil];
    for (NSIndexPath* ip in userSelectedIndexPaths) {
      NSString* bankName = [bankArray objectAtIndex:ip.section];
      NSMutableArray* bankSection = [selectedCards objectForKey:bankName];
      [bankSection addObject:[NSNumber numberWithInt:ip.row]];
    }
    
    //NSLog(@"selected: %@", selectedCards);
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:YES forKey:K_UD_CONFIGED_CARD];
    [defaults setBool:isSelectAll forKey:K_UD_SELECT_ALL];
    [defaults setObject:selectedCards forKey:K_UD_SELECT_CARDS];
    [self dismissModalViewControllerAnimated:YES];
  }

}

- (IBAction)segmentedControlValueChanged:(id)sender {
  
  isSelectAll = ([(UISegmentedControl *)sender selectedSegmentIndex] == 0);
    
  NSMutableArray* ipArray = [[NSMutableArray alloc] init];
  for (int i = 0; i < [self.tableView numberOfSections]; i++) {
    for (int j = 0; j < [self.tableView numberOfRowsInSection:i]; j++) {
      NSIndexPath *ip = [NSIndexPath indexPathForRow:j inSection:i];
      TTTableRightImageItem *item = [self.dataSource tableView:self.tableView objectForRowAtIndexPath:ip];
      
      if (isSelectAll) {
        item.imageURL = kImageChecked;
      } else {
        if ([userSelectedIndexPaths containsObject:ip]) {
          item.imageURL = kImageChecked;
        } else {
          item.imageURL = kImageUnchecked;
        }
      }
      [ipArray addObject:ip];
    }
  }
  [self.tableView reloadRowsAtIndexPaths:ipArray withRowAnimation:UITableViewRowAnimationFade];
  //[self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
  TT_RELEASE_SAFELY(ipArray);
}

- (IBAction)selectBank:(id)sender {
  UIButton* theButton = sender;
  for (id object in [[theButton superview] subviews]) {
    if ([object isKindOfClass:[UIButton class]]) {
      [(UIButton *)object setSelected:NO];
    }
  }
  theButton.selected = YES;
  
  NSIndexPath* ip = [NSIndexPath indexPathForRow:0 inSection:theButton.tag-1];
  [self.tableView scrollToRowAtIndexPath:ip atScrollPosition:UITableViewScrollPositionTop animated:YES];
}

////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark View
- (id)init {
  if (self = [super init]) {
    self.tableViewStyle = UITableViewStyleGrouped;
    userSelectedIndexPaths = [[NSMutableArray alloc] init];
  }
  return self;
}

- (void)loadView {
  [super loadView];
  self.tableView.backgroundColor = [UIColor clearColor];
  self.tableView.frame = CGRectMake(5, 150, 310, 255);
  self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
  self.tableView.separatorColor = [UIColor clearColor];
  [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
  
  UIButton *infoBt = [UIButton buttonWithType:UIButtonTypeInfoLight];
  [infoBt addTarget:kAppInfoURLPath action:@selector(openURLFromButton:) forControlEvents:UIControlEventTouchUpInside];
  self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:infoBt];
  
  UIButton *doneButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 57, 30)];
  [doneButton setImage:[UIImage imageNamed:@"button-done.png"] forState:UIControlStateNormal];
  [doneButton addTarget:self action:@selector(doneButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
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
    cardSegment = [[UISegmentedControl alloc] initWithFrame:CGRectMake(5, 40, 300, 34)];
    cardSegment.tintColor = [UIColor clearColor];
    [cardSegment insertSegmentWithTitle:@"Select All" atIndex:0 animated:NO];
    [cardSegment insertSegmentWithTitle:@"Select My Cards" atIndex:1 animated:NO];
    [cardSegment setSegmentedControlStyle:UISegmentedControlStylePlain];
    [cardSegment addTarget:self action:@selector(segmentedControlValueChanged:) forControlEvents:UIControlEventValueChanged];
    [boxView addSubview:cardSegment];
    
    UIScrollView *bankBox = [[UIScrollView alloc] initWithFrame:CGRectMake(4, 75, 302, 70)];
    bankBox.backgroundColor = [UIColor whiteColor];
    bankBox.layer.cornerRadius = 6;
    bankBox.layer.masksToBounds = YES;
    bankBox.scrollEnabled = YES;
    {
      int tagIndex = 0;
      
      UIButton *citibankButton = [[UIButton alloc] init];
      [citibankButton setImage:[UIImage imageNamed:@"citibank1.png"] forState:UIControlStateNormal];
      [citibankButton setImage:[UIImage imageNamed:@"citibank2.png"] forState:UIControlStateSelected];
      [citibankButton addTarget:self action:@selector(selectBank:) forControlEvents:UIControlEventTouchUpInside];
      citibankButton.frame = CGRectMake(79*(tagIndex++), 7, 65, 65);
      citibankButton.tag = tagIndex;
      [bankBox addSubview:citibankButton];
      TT_RELEASE_SAFELY(citibankButton);
      
      UIButton *dbsButton = [[UIButton alloc] init];
      [dbsButton setImage:[UIImage imageNamed:@"dbs1.png"] forState:UIControlStateNormal];
      [dbsButton setImage:[UIImage imageNamed:@"dbs2.png"] forState:UIControlStateSelected];
      [dbsButton addTarget:self action:@selector(selectBank:) forControlEvents:UIControlEventTouchUpInside];
      dbsButton.frame = CGRectMake(79*(tagIndex++), 7, 65, 65);
      dbsButton.tag = tagIndex;
      [bankBox addSubview:dbsButton];
      TT_RELEASE_SAFELY(dbsButton);
      
      UIButton *ocbcButton = [[UIButton alloc] init];
      [ocbcButton setImage:[UIImage imageNamed:@"ocbc1.png"] forState:UIControlStateNormal];
      [ocbcButton setImage:[UIImage imageNamed:@"ocbc2.png"] forState:UIControlStateSelected];
      [ocbcButton addTarget:self action:@selector(selectBank:) forControlEvents:UIControlEventTouchUpInside];
      ocbcButton.frame = CGRectMake(79*(tagIndex++), 7, 65, 65);
      ocbcButton.tag = tagIndex;
      [bankBox addSubview:ocbcButton];
      TT_RELEASE_SAFELY(ocbcButton);
      
      UIButton *uobButton = [[UIButton alloc] init];
      [uobButton setImage:[UIImage imageNamed:@"uob1.png"] forState:UIControlStateNormal];
      [uobButton setImage:[UIImage imageNamed:@"uob2.png"] forState:UIControlStateSelected];
      [uobButton addTarget:self action:@selector(selectBank:) forControlEvents:UIControlEventTouchUpInside];
      uobButton.frame = CGRectMake(79*(tagIndex++), 7, 65, 65);
      uobButton.tag = tagIndex;
      [bankBox addSubview:uobButton];
      TT_RELEASE_SAFELY(uobButton);
      
      [bankBox setContentSize:CGSizeMake(310, 60)];
    }
    
    [boxView addSubview:bankBox];
    TT_RELEASE_SAFELY(bankBox);
  }
  
  [self.view addSubview:boxView];
  [boxView release];
  
  [self.view bringSubviewToFront:self.tableView];
  
  NSUserDefaults *settings = [NSUserDefaults standardUserDefaults];
  if (![settings boolForKey:K_UD_CONFIGED_CARD]) {
    UIAlertView *alertMsg = [[UIAlertView alloc] initWithTitle:nil message:@"select your credit card so that all the deals are customized for your card" delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil];
    [alertMsg show];
    [alertMsg release];
  }
}

- (void)viewDidAppear:(BOOL)animated  {
  [super viewDidAppear:animated];
  NSUserDefaults *settings = [NSUserDefaults standardUserDefaults];
  if (![settings boolForKey:K_UD_SELECT_ALL] && [settings boolForKey:K_UD_CONFIGED_CARD]) {
    [cardSegment setSelectedSegmentIndex:1];
  } else {
    [cardSegment setSelectedSegmentIndex:0];
  }
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)createModel {
  self.dataSource = [[[CardSettingDataSource alloc] init] autorelease];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (id<UITableViewDelegate>)createDelegate {
  return [[[TTTableViewDelegate alloc] initWithController:self] autorelease];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)didShowModel:(BOOL)firstTime {
  [super didShowModel:firstTime];
  
  NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
  if ([defaults objectForKey:K_UD_SELECT_CARDS] != nil) {
    NSMutableDictionary* selectedCards = [[NSMutableDictionary alloc] initWithDictionary:[defaults objectForKey:K_UD_SELECT_CARDS]];
    NSArray* bankArray = [[selectedCards allKeys] sortedArrayUsingSelector:@selector(compare:)];
    for (int i=0; i<bankArray.count; i++) {
      NSString* bankName = [bankArray objectAtIndex:i];
      NSArray* bankSection = [selectedCards objectForKey:bankName];
      for (NSNumber* row in bankSection) {
        int j = [row intValue];
        NSIndexPath* ip = [NSIndexPath indexPathForRow:j inSection:i];
        //NSLog(@"index. path: %@", ip);
        TTTableRightImageItem* item = [self.dataSource tableView:self.tableView objectForRowAtIndexPath:ip];
        item.imageURL = kImageChecked;
        [userSelectedIndexPaths addObject:ip];
      }
    }
    [self.tableView reloadRowsAtIndexPaths:userSelectedIndexPaths withRowAnimation:UITableViewRowAnimationFade];
  }
}

#pragma mark -
#pragma mark TTTableViewDelegate
- (void)didSelectObject:(id)object atIndexPath:(NSIndexPath *)indexPath {
  
  if([object isKindOfClass:[TTTableRightImageItem class]]) {
    //NSLog(@"indexpath: %i, %i", indexPath.section, indexPath.row);
    TTTableImageItemCell *cell = (TTTableImageItemCell *)[self.tableView cellForRowAtIndexPath:indexPath];
    
    NSMutableArray* ips = [[NSMutableArray alloc] init];
    
    if (isSelectAll) {
      [userSelectedIndexPaths removeAllObjects];
      NSUInteger section, sectionCount = [self.tableView numberOfSections];
      for (section = 0; section < sectionCount; section++) {
        NSUInteger row, rowCount = [self.tableView numberOfRowsInSection:section];
        for (row = 0; row < rowCount; row++) {
          NSIndexPath *ip = [NSIndexPath indexPathForRow:row inSection:section];
          [userSelectedIndexPaths addObject:ip];
          [ips addObject:ip];
        }
      }
      [userSelectedIndexPaths removeObject:indexPath];
      [cardSegment setSelectedSegmentIndex:1];
    } else {
      if ([object imageURL] == kImageUnchecked) {
        [object setImageURL:kImageChecked];
        [cell setBackgroundColor:[UIColor redColor]];
        [cell setSelected:YES];
        [userSelectedIndexPaths addObject:indexPath];
      } else {
        [object setImageURL:kImageUnchecked];
        [cell setBackgroundColor:[UIColor whiteColor]];
        [cell setSelected:NO];
        if ([userSelectedIndexPaths containsObject:indexPath]) {
          [userSelectedIndexPaths removeObject:indexPath];
        }
      }
      [ips addObject:indexPath];
      [self.tableView reloadRowsAtIndexPaths:ips withRowAnimation:UITableViewRowAnimationNone];
    }
    
    [ips release];
  } else
    [super didSelectObject:object atIndexPath:indexPath];
}

@end