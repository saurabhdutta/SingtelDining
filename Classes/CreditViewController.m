//
//  CreditViewController.m
//  SingtelDining
//
//  Created by Alex Yao on 6/11/10.
//  Copyright 2010 CellCity. All rights reserved.
//


#import "CreditViewController.h"
#import "SDBoxView.h"
#import "CardListDataSource.h"


@implementation CreditViewController

#pragma mark -


- (void)yesToAlert {
  
}

- (void)noToAlert {
  [self dismissModalViewControllerAnimated:YES];
}

- (void)doneButtonClicked {
  
  int selectedCount;
  
  for (NSString *bank in [selectedCards keyEnumerator]) {
    selectedCount += [[selectedCards objectForKey:bank] count];
  }
  
  if ((!selectedCount) && (!selectAll)) {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil 
                                                    message:@"You haven't selected your credit cards, Do you want to go back and configure?" 
                                                   delegate:self 
                                          cancelButtonTitle:@"Yes" 
                                          otherButtonTitles:nil];
    [alert addButtonWithTitle:@"No"];
    [alert show];
    [alert release];
  } else {
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:YES forKey:K_UD_CONFIGED_CARD];
    [defaults setBool:selectAll forKey:K_UD_SELECT_ALL];
    [defaults setObject:selectedCards forKey:K_UD_SELECT_CARDS];
    [self dismissModalViewControllerAnimated:YES];
  }
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

- (IBAction)cardSegmentClicked:(id)sender {
  selectAll = ([(UISegmentedControl *)sender selectedSegmentIndex] == 0);
  if (selectAll) {
    self.dataSource = [[[CardListDataSource alloc] initWithBank:selectedBank selectAll:selectAll] autorelease];
  } else {
    self.dataSource = [[[CardListDataSource alloc] initWithBank:selectedBank] autorelease];
  }
}

- (IBAction)selectBank:(id)sender {
  UIButton *theButton = (UIButton *)sender;
  for (id object in [[theButton superview] subviews]) {
    if ([object isKindOfClass:[UIButton class]]) {
      [(UIButton *)object setSelected:NO];
    }
  }
  theButton.selected = YES;
  msg.hidden = YES;
  
  selectedBank = [bankArray objectAtIndex:theButton.tag-1];
  [selectedBank retain];
  if (TTIsStringWithAnyText(selectedBank)) {
    NSLog(@"update datasource");
    if (selectAll) {
      self.dataSource = [[[CardListDataSource alloc] initWithBank:selectedBank selectAll:selectAll] autorelease];
    } else {
      self.dataSource = [[[CardListDataSource alloc] initWithBank:selectedBank] autorelease];
    }
  }
}

#pragma mark -
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
  if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
    //self.title = @"Singtel Dining";
    self.tableViewStyle = UITableViewStyleGrouped;
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults objectForKey:K_UD_SELECT_CARDS] != nil) {
      selectedCards = [[NSMutableDictionary alloc] initWithDictionary:[defaults objectForKey:K_UD_SELECT_CARDS]];
    } else {
      selectedCards = [[NSMutableDictionary alloc] init];
      [selectedCards setObject:[NSMutableArray array] forKey:@"Citibank"];
      [selectedCards setObject:[NSMutableArray array] forKey:@"DBS"];
      [selectedCards setObject:[NSMutableArray array] forKey:@"OCBC"];
      [selectedCards setObject:[NSMutableArray array] forKey:@"UOB"];
    }
    
    bankArray = [[selectedCards allKeys] sortedArrayUsingSelector:@selector(compare:)];
    [bankArray retain];
    NSLog(@"sorted keys %@", bankArray);
  }
  return self;
}

- (void)dealloc {
  TT_RELEASE_SAFELY(cardSegment);
  TT_RELEASE_SAFELY(selectedCards);
  TT_RELEASE_SAFELY(selectedBank);
  TT_RELEASE_SAFELY(bankArray);
  TT_RELEASE_SAFELY(msg);
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
    
    cardSegment = [[UISegmentedControl alloc] initWithFrame:CGRectMake(5, 40, 300, 34)];
    cardSegment.tintColor = [UIColor clearColor];
    [cardSegment insertSegmentWithTitle:@"All Credit Cards" atIndex:0 animated:NO];
    [cardSegment insertSegmentWithTitle:@"My Credit Cards" atIndex:1 animated:NO];
    [cardSegment setSegmentedControlStyle:UISegmentedControlStylePlain];
    [cardSegment addTarget:self action:@selector(cardSegmentClicked:) forControlEvents:UIControlEventValueChanged];
    [boxView addSubview:cardSegment];
        
    UIScrollView *bankBox = [[UIScrollView alloc] initWithFrame:CGRectMake(4, 80, 302, 70)];
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
    
    // bank card table
    {
      self.tableView.backgroundColor = [UIColor clearColor];
      self.tableView.frame = CGRectMake(0, 150, 310, 260);
      self.tableViewStyle = UITableViewStyleGrouped;
      self.variableHeightRows = YES;
      self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
      self.tableView.separatorColor = [UIColor clearColor];
      [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
      [boxView addSubview:self.tableView];
    }
    
    // text label
    {
      NSUserDefaults *settings = [NSUserDefaults standardUserDefaults];
      if (![settings boolForKey:K_UD_CONFIGED_CARD]) {
        UIAlertView *alertMsg = [[UIAlertView alloc] initWithTitle:nil message:@"Please select your Banks and Cards" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertMsg show];
        [alertMsg release];
      }
      /*
      msg = [[UILabel alloc] initWithFrame:CGRectMake(0, 150, 310, 260)];
      [msg setText:@"Please select your Banks and Cards"];
      [msg setNumberOfLines:0];
      [msg setLineBreakMode:UILineBreakModeWordWrap];
      [msg setTextAlignment:UITextAlignmentCenter];
      [boxView addSubview:msg];
      */
    }
  }
  
  [self.view addSubview:boxView];
  [boxView release];
}

- (void)viewDidAppear:(BOOL)animated  {
  [super viewDidAppear:animated];
  NSUserDefaults *settings = [NSUserDefaults standardUserDefaults];
  if (![settings boolForKey:K_UD_SELECT_ALL] && [settings boolForKey:K_UD_CONFIGED_CARD]) {
    NSLog(@"not select all");
    [cardSegment setSelectedSegmentIndex:1];
  } else {
    NSLog(@"select all");
    [cardSegment setSelectedSegmentIndex:0];
  }
}

- (void)didRefreshModel {
  NSLog(@"didRefreshModel");
  [super didRefreshModel];
}

#pragma mark -
#pragma mark TTTableViewDelegate
- (void)didSelectObject:(id)object atIndexPath:(NSIndexPath *)indexPath {
  
  if([object isKindOfClass:[TTTableRightImageItem class]] && selectAll == NO) {
    NSLog(@"indexpath: %i, %i", indexPath.section, indexPath.row);
    TTTableImageItemCell *cell = (TTTableImageItemCell *)[self.tableView cellForRowAtIndexPath:indexPath];
    
    NSMutableArray *bank = [NSMutableArray arrayWithArray:[selectedCards objectForKey:selectedBank]];
    NSNumber *row = [NSNumber numberWithInt:indexPath.row];
    
    if ([object imageURL] == kImageUnchecked) {
      [object setImageURL:kImageChecked];
      [cell setBackgroundColor:[UIColor redColor]];
      [cell setSelected:YES];
      if (![bank containsObject:row]) {
        [bank addObject:row];
      }
    } else {
      [object setImageURL:kImageUnchecked];
      [cell setBackgroundColor:[UIColor whiteColor]];
      [cell setSelected:NO];
      if ([bank containsObject:row]) {
        [bank removeObject:row];
      }
    }
    
    NSLog(@"cards: %@", selectedCards);
    [selectedCards setObject:bank forKey:selectedBank];
    
    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationNone];
  } else
    [super didSelectObject:object atIndexPath:indexPath];
}

- (void)didShowModel:(BOOL)firstTime {
  [super didShowModel:firstTime];
  NSArray *shouldBeSelected = [selectedCards objectForKey:selectedBank];
  NSMutableArray *selectedIndexPath = [[NSMutableArray alloc] init];
  for (id row in shouldBeSelected) {
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[(NSNumber *)row intValue] inSection:0];
    id object = [self.dataSource tableView:self.tableView objectForRowAtIndexPath:indexPath];
    if ([object isKindOfClass:[TTTableImageItem class]]) {
      [object setImageURL:kImageChecked];
    }
    [self.tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
    [selectedIndexPath addObject:indexPath];
  }
  [self.tableView reloadRowsAtIndexPaths:selectedIndexPath withRowAnimation:UITableViewRowAnimationNone];
  [selectedIndexPath release];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)createModel {
  self.dataSource = [TTListDataSource dataSourceWithItems:[NSMutableArray array]];
}
///////////////////////////////////////////////////////////////////////////////////////////////////
- (id<UITableViewDelegate>)createDelegate {
  return [[[TTTableViewPlainDelegate alloc] initWithController:self] autorelease];
}
@end
