//
//  HTableItem.h
//  HTable
//
//  Created by Alex Yao Cheng on 6/28/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface HTableItem : TTTableImageItem {
  NSString* _tickURL;
  BOOL _selected;
}

@property (nonatomic, copy) NSString* tickURL;
@property BOOL selected;

@end
