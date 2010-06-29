//
//  HTableItemCell.h
//  HTable
//
//  Created by Alex Yao Cheng on 6/28/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface HTableItemCell : TTTableImageItemCell {
  TTImageView* _tickView;
}

@property (nonatomic, readonly, retain) TTImageView* tickView;

@end
