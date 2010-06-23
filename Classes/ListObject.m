//
//  ListObject.m
//  SingtelDining
//
//  Created by Alex Yao on 6/23/10.
//  Copyright 2010 CellCity. All rights reserved.
//

#import "ListObject.h"


@implementation ListObject

///////////////////////////////////////////////////////////////////////////////////////////////////
@synthesize uid = _uid;
@synthesize title = _title;
@synthesize image = _image;
@synthesize address = _address;
@synthesize rating = _rating;

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)dealloc {
  TT_RELEASE_SAFELY(_uid);
  TT_RELEASE_SAFELY(_title);
  TT_RELEASE_SAFELY(_image);
  TT_RELEASE_SAFELY(_address);
  
  [super dealloc];
}
@end
