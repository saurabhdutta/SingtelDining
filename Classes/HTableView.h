//
//  HTableView.h
//  HTable
//
//  Created by Alex Yao Cheng on 6/28/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HTableItem.h"
#import "HTableItemCell.h"
#import "HTableDataSource.h"


@interface HTableView : TTTableView {
  NSMutableArray* _selectedRows;
}

@property (nonatomic, copy) NSMutableArray* selectedRows;
- (void)selectRowAtIndexPath:(NSIndexPath *)indexPath;

@end
