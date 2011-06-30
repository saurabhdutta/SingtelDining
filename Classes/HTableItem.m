//
//  HTableItem.m
//  HTable
//
//  Created by Alex Yao Cheng on 6/28/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "HTableItem.h"


@implementation HTableItem

@synthesize selectedImageURL = _selectedImageURL;
@synthesize tickURL = _tickURL;
@synthesize selected = _selected;
@synthesize bank;

- (void)dealloc {
  TT_RELEASE_SAFELY(_selectedImageURL);
  TT_RELEASE_SAFELY(_tickURL);
    TT_RELEASE_SAFELY(bank);
  [super dealloc];
}

@end
