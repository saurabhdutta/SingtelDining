//
//  CouponTableItem.h
//  SingtelDining
//
//  Created by Alex Yao Cheng on 11/2/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface CouponTableItem : TTTableMessageItem {
  NSString* _rightLabel;
}

@property (nonatomic, copy) NSString* rightLabel;

@end
