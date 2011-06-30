//
//  HTableItem.h
//  HTable
//
//  Created by Alex Yao Cheng on 6/28/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface HTableItem : TTTableImageItem {
  NSString* _selectedImageURL;
  NSString* _tickURL;
  BOOL _selected;
    NSString* bank;
}

@property (nonatomic, copy) NSString* tickURL;
@property (nonatomic, copy) NSString* selectedImageURL;
@property (nonatomic, retain) NSString* bank;
@property BOOL selected;

@end
