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

-(id)initWithCoder:(NSCoder *)decoder {
  if (self = [super init]) {
    _uid = [decoder decodeObjectForKey:@"uid"];
    _title = [decoder decodeObjectForKey:@"title"];
    _image = [decoder decodeObjectForKey:@"image"];
    _address = [decoder decodeObjectForKey:@"address"];
    _latitude = [decoder decodeObjectForKey:@"latitude"];
    _longitude = [decoder decodeObjectForKey:@"longitude"];
    _rating = [decoder decodeFloatForKey:@"rating"];
    _distance = [decoder decodeFloatForKey:@"distance"];
  }
  return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
  [encoder encodeObject:_uid forKey:@"uid"];
  [encoder encodeObject:_title forKey:@"title"];
  [encoder encodeObject:_image forKey:@"image"];
  [encoder encodeObject:_address forKey:@"address"];
  [encoder encodeObject:_latitude forKey:@"latitude"];
  [encoder encodeObject:_longitude forKey:@"longitude"];
  [encoder encodeFloat:_rating forKey:@"rating"];
  [encoder encodeFloat:_distance forKey:@"distance"];
}

@end
