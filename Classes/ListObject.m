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
@synthesize longitude = _longitude;
@synthesize latitude = _latitude;
@synthesize distance = _distance;

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)dealloc {
  TT_RELEASE_SAFELY(_uid);
  TT_RELEASE_SAFELY(_title);
  TT_RELEASE_SAFELY(_image);
  TT_RELEASE_SAFELY(_address);
  TT_RELEASE_SAFELY(_latitude);
  TT_RELEASE_SAFELY(_longitude); 

  [super dealloc];
}
@end
