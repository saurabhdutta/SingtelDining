//
//  DetailsObject.h
//  SingtelDining
//
//  Created by Alex Yao on 6/24/10.
//  Copyright 2010 CellCity. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface DetailsObject : NSObject {
  int _rid;
  NSString *_title;
  float _rating;
  int _review;
  NSArray *_offers;
  NSString *_address;
  NSString *_phone;
  float _latitude;
  float _longitude;
  NSString *_descriptionString;
  NSArray *_branches;
}

@property (readwrite) int rid;
@property (readwrite) float rating;
@property (readwrite) int review;
@property (readwrite) float latitude;
@property (readwrite) float longitude;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSArray *offers;
@property (nonatomic, copy) NSString *address;
@property (nonatomic, copy) NSString *phone;
@property (nonatomic, copy) NSString *descriptionString;
@property (nonatomic, copy) NSArray *branches;


@end
