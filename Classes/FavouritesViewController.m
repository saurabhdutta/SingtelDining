//
//  FavouritesViewController.m
//  SingtelDining
//
//  Created by Alex Yao on 6/16/10.
//  Copyright 2010 CellCity. All rights reserved.
//

#import "FavouritesViewController.h"
#import "SDBoxView.h"


@implementation FavouritesViewController

- (void)loadView {
  [super loadView];
  
  SDBoxView *boxView = [[SDBoxView alloc] initWithFrame:CGRectMake(5, 0, 310, 359)];
  [self.view addSubview:boxView];
  [boxView release];
}

@end
