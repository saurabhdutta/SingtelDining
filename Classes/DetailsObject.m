//
//  DetailsObject.m
//  SingtelDining
//
//  Created by Alex Yao on 6/24/10.
//  Copyright 2010 CellCity. All rights reserved.
//

#import "DetailsObject.h"


@implementation DetailsObject

@synthesize rid = _rid;
@synthesize rating = _rating;
@synthesize review = _review;
@synthesize latitude = _latitude;
@synthesize longitude = _longitude;

@synthesize title = _title;
@synthesize offers = _offers;
@synthesize address = _address;
@synthesize phone = _phone;
@synthesize descriptionString = _descriptionString;
@synthesize branches = _branches;

- (void)dealloc {
  TT_RELEASE_SAFELY(_title);
  TT_RELEASE_SAFELY(_offers);
  TT_RELEASE_SAFELY(_address);
  TT_RELEASE_SAFELY(_phone);
  TT_RELEASE_SAFELY(_descriptionString);
  TT_RELEASE_SAFELY(_branches);
  [super dealloc];
}

@end
