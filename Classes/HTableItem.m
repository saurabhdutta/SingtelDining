//
//  HTableItem.m
//  HTable
//
//  Created by Alex Yao Cheng on 6/28/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "HTableItem.h"


@implementation HTableItem

@synthesize tickURL = _tickURL;
@synthesize selected = _selected;

- (void)dealloc {
  TT_RELEASE_SAFELY(_tickURL);
  [super dealloc];
}

@end
