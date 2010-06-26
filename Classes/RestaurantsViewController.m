//
//  RestaurantsViewController.m
//  SingtelDining
//
//  Created by Alex Yao on 6/16/10.
//  Copyright 2010 CellCity. All rights reserved.
//

#import "RestaurantsViewController.h"
#import "SDListView.h"
#import "ListDataSource.h"


@implementation RestaurantsViewController

#pragma mark -
- (IBAction)selectCard:(id)sender {
  
}

#pragma mark -

- (void)loadView {
  [super loadView];
  
  SDListView *boxView = [[SDListView alloc] initWithFrame:CGRectMake(5, 0, 310, 275)];
  
  {
    self.tableView.frame = CGRectMake(5, 40, 300, 230);
    self.tableView.backgroundColor = [UIColor clearColor];
    
    [boxView addSubview:self.tableView];
  }
  
  [self.view addSubview:boxView];
  [boxView release];
  
  // cards box
  UIScrollView *cardBox = [[UIScrollView alloc] initWithFrame:CGRectMake(45, 284, 270, 75)];
  cardBox.backgroundColor = [UIColor whiteColor];
  cardBox.layer.cornerRadius = 6;
  cardBox.layer.masksToBounds = YES;
  cardBox.scrollEnabled = YES;
  {
    // setting button
    UIButton *settingButton = [[UIButton alloc] initWithFrame:CGRectMake(5, 284, 34, 75)];
    [settingButton setImage:[UIImage imageNamed:@"button-setting.png"] forState:UIControlStateNormal];
    [settingButton addTarget:kAppCreditURLPath action:@selector(openURLFromButton:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barSettingButton = [[UIBarButtonItem alloc] initWithCustomView:settingButton];
    [settingButton release];
    [self.view addSubview:settingButton];
    [barSettingButton release];
    
    NSMutableArray *selectedCardList = [NSMutableArray array];
    NSDictionary *cardList = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"CreditCard" ofType:@"plist"]];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *selectedCards = [defaults objectForKey:K_UD_SELECT_CARDS];
    NSArray *bankKeys = [[selectedCards allKeys] sortedArrayUsingSelector:@selector(compare:)];
    for (NSString *bankName in bankKeys) {
      NSArray *selected = [selectedCards objectForKey:bankName];
      for (id index in selected) {
        NSArray *cardInBank = [cardList objectForKey:bankName];
        NSDictionary *card = [cardInBank objectAtIndex:[(NSNumber*)index intValue]];
        [selectedCardList addObject:card];
      }
    }
    
    int i = 0;
    for (NSDictionary *card in selectedCardList) {
      UIButton *cardButton = [[UIButton alloc] init];
      [cardButton setImage:[UIImage imageNamed:[card objectForKey:@"Icon"]] forState:UIControlStateNormal];
      [cardButton setImage:[UIImage imageNamed:[card objectForKey:@"Icon"]] forState:UIControlStateSelected];
      [cardButton addTarget:self action:@selector(selectCard:) forControlEvents:UIControlEventTouchUpInside];
      cardButton.frame = CGRectMake(95*i + 5, 7, 95, 60);
      cardButton.tag = i;
      [cardBox addSubview:cardButton];
      TT_RELEASE_SAFELY(cardButton);
      i ++;
    }
    [cardBox setContentInset:UIEdgeInsetsMake(0, 5, 0, 5)];
    [cardBox setContentSize:CGSizeMake(95*i+10, 45)];
  }
  [self.view addSubview:cardBox];
  TT_RELEASE_SAFELY(cardBox);
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)createModel {
  self.dataSource = [[[ListDataSource alloc] initWithType:@"any"] autorelease];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (id<UITableViewDelegate>)createDelegate {
  return [[[TTTableViewPlainVarHeightDelegate alloc] initWithController:self] autorelease];
}

@end
