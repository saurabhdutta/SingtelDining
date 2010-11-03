//
//  CouponTableItem.m
//  SingtelDining
//
//  Created by Alex Yao Cheng on 11/2/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "CouponTableItem.h"


@implementation CouponTableItem

@synthesize rightLabel = _rightLabel;

- (void)dealloc {
  if (_rightLabel != nil) {
    TT_RELEASE_SAFELY(_rightLabel);
  }
  
  [super dealloc];
}

#pragma mark -
#pragma mark NSCoding
- (id)initWithCoder:(NSCoder *)aDecoder {
  if (self = [super initWithCoder:aDecoder]) {
    self.rightLabel = [aDecoder decodeObjectForKey:@"rightLabel"];
  }
  return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
  [super encodeWithCoder:aCoder];
  if (self.rightLabel) {
    [aCoder encodeObject:self.rightLabel forKey:@"rightLabel"];
  }
}

@end
