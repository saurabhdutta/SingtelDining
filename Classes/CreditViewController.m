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

- (IBAction)selectBank:(id)sender {
  UIButton *theButton = (UIButton *)sender;
  for (id object in [[theButton superview] subviews]) {
    if ([object isKindOfClass:[UIButton class]]) {
      [(UIButton *)object setSelected:NO];
    }
  }
  theButton.selected = YES;
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
  TT_RELEASE_SAFELY(cardSegment);
  TT_RELEASE_SAFELY(selectedCards);
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
    [boxView addSubview:cardSegment];
        
    UIScrollView *bankBox = [[UIScrollView alloc] initWithFrame:CGRectMake(4, 80, 302, 60)];
    bankBox.backgroundColor = [UIColor whiteColor];
    bankBox.layer.cornerRadius = 6;
    bankBox.layer.masksToBounds = YES;
    bankBox.scrollEnabled = YES;
    {
      int tagIndex = 0;
      
      UIButton *ocbcButton = [[UIButton alloc] init];
      [ocbcButton setImage:[UIImage imageNamed:@"ocbc1.png"] forState:UIControlStateNormal];
      [ocbcButton setImage:[UIImage imageNamed:@"ocbc2.png"] forState:UIControlStateSelected];
      [ocbcButton addTarget:self action:@selector(selectBank:) forControlEvents:UIControlEventTouchUpInside];
      ocbcButton.frame = CGRectMake(60*(tagIndex++), 7, 60, 46);
      ocbcButton.tag = tagIndex;
      [bankBox addSubview:ocbcButton];
      TT_RELEASE_SAFELY(ocbcButton);
      
      UIButton *posbButton = [[UIButton alloc] init];
      [posbButton setImage:[UIImage imageNamed:@"posb1.png"] forState:UIControlStateNormal];
      [posbButton setImage:[UIImage imageNamed:@"posb2.png"] forState:UIControlStateSelected];
      [posbButton addTarget:self action:@selector(selectBank:) forControlEvents:UIControlEventTouchUpInside];
      posbButton.frame = CGRectMake(60*(tagIndex++), 7, 60, 46);
      posbButton.tag = tagIndex;
      [bankBox addSubview:posbButton];
      TT_RELEASE_SAFELY(posbButton);
      
      UIButton *uobButton = [[UIButton alloc] init];
      [uobButton setImage:[UIImage imageNamed:@"uob1.png"] forState:UIControlStateNormal];
      [uobButton setImage:[UIImage imageNamed:@"uob2.png"] forState:UIControlStateSelected];
      [uobButton addTarget:self action:@selector(selectBank:) forControlEvents:UIControlEventTouchUpInside];
      uobButton.frame = CGRectMake(60*(tagIndex++), 7, 60, 46);
      uobButton.tag = tagIndex;
      [bankBox addSubview:uobButton];
      TT_RELEASE_SAFELY(uobButton);
      
      UIButton *dbsButton = [[UIButton alloc] init];
      [dbsButton setImage:[UIImage imageNamed:@"dbs1.png"] forState:UIControlStateNormal];
      [dbsButton setImage:[UIImage imageNamed:@"dbs2.png"] forState:UIControlStateSelected];
      [dbsButton addTarget:self action:@selector(selectBank:) forControlEvents:UIControlEventTouchUpInside];
      dbsButton.frame = CGRectMake(60*(tagIndex++), 7, 60, 46);
      dbsButton.tag = tagIndex;
      [bankBox addSubview:dbsButton];
      TT_RELEASE_SAFELY(dbsButton);
      
      UIButton *citibankButton = [[UIButton alloc] init];
      [citibankButton setImage:[UIImage imageNamed:@"citibank1.png"] forState:UIControlStateNormal];
      [citibankButton setImage:[UIImage imageNamed:@"citibank2.png"] forState:UIControlStateSelected];
      [citibankButton addTarget:self action:@selector(selectBank:) forControlEvents:UIControlEventTouchUpInside];
      citibankButton.frame = CGRectMake(60*(tagIndex++), 7, 60, 46);
      citibankButton.tag = tagIndex;
      [bankBox addSubview:citibankButton];
      TT_RELEASE_SAFELY(citibankButton);
      
      [bankBox setContentSize:CGSizeMake(320, 60)];
    }
    
    [boxView addSubview:bankBox];
    TT_RELEASE_SAFELY(bankBox);
    
    // bank card table
    {
      self.tableView.backgroundColor = [UIColor clearColor];
      self.tableView.frame = CGRectMake(0, 140, 310, 270);
      self.tableViewStyle = UITableViewStyleGrouped;
      self.variableHeightRows = YES;
      self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
      self.tableView.separatorColor = [UIColor clearColor];
      [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
      [boxView addSubview:self.tableView];
    }
  }
  
  [self.view addSubview:boxView];
  [boxView release];
}

- (void)viewDidAppear:(BOOL)animated  {
  [super viewDidAppear:animated];
  NSUserDefaults *settings = [NSUserDefaults standardUserDefaults];
  if (![settings boolForKey:K_UD_SELECT_ALL]) {
    NSLog(@"not select all");
    [cardSegment setSelectedSegmentIndex:1];
  } else {
    NSLog(@"select all");
    [cardSegment setSelectedSegmentIndex:0];
  }
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
    NSLog(@"indexpath: %i, %i", indexPath.section, indexPath.row);
    TTTableImageItemCell *cell = (TTTableImageItemCell *)[self.tableView cellForRowAtIndexPath:indexPath];
    
    NSMutableArray *bank = [selectedCards objectForKey:@"UOB"];
    NSNumber *row = [NSNumber numberWithInt:indexPath.row];
    
    if ([object imageURL] == kImageUnchecked) {
      [object setImageURL:kImageChecked];
      [cell setBackgroundColor:[UIColor redColor]];
      if (![bank containsObject:row]) {
        [bank addObject:row];
      }
    } else {
      [object setImageURL:kImageUnchecked];
      [cell setBackgroundColor:[UIColor whiteColor]];
      if ([bank containsObject:row]) {
        [bank removeObject:row];
      }
    }
    
    NSLog(@"cards: %@", selectedCards);
    
    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationNone];
  } else
    [super didSelectObject:object atIndexPath:indexPath];
}
///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)createModel {
  self.dataSource = [[[CardListDataSource alloc] initWithBank:@"UOB"] autorelease];
}
///////////////////////////////////////////////////////////////////////////////////////////////////
- (id<UITableViewDelegate>)createDelegate {
  return [[[TTTableViewPlainDelegate alloc] initWithController:self] autorelease];
}
@end
