//
//  HTableView.m
//  HTable
//
//  Created by Alex Yao Cheng on 6/28/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "HTableView.h"


@implementation HTableView

@synthesize selectedRows = _selectedRows;

- (void)dealloc {
  TT_RELEASE_SAFELY(_selectedRows);
  [super dealloc];
}

- (id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
  if (self = [super initWithFrame:frame style:style]) {
    self.transform = CGAffineTransformMakeRotation(-M_PI/2);
    self.frame = frame;
    self.rowHeight = 200;
    _selectedRows = [[NSMutableArray alloc] init];
  }
  return self;
}

- (void)selectRowAtIndexPath:(NSIndexPath *)indexPath {
  NSLog(@"selectRowAtIndexPath");
  if ([_selectedRows containsObject:indexPath]) {
    [_selectedRows removeObject:indexPath];
  } else {
    [_selectedRows addObject:indexPath];
	  NSLog(@"_selectedRows %@",_selectedRows);
  }

}

@end
