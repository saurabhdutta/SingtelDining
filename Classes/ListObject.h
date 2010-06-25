//
//  ListObject.h
//  SingtelDining
//
//  Created by Alex Yao on 6/23/10.
//  Copyright 2010 CellCity. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface ListObject : NSObject {
  NSNumber *_uid;
  NSString *_title;
  NSString *_image;
  NSString *_address;
  float _rating;
  NSString *_longitude;
  NSString *_latitude;

   
}

@property (nonatomic, retain) NSNumber *uid;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *image;
@property (nonatomic, copy) NSString *address;
@property (readwrite) float rating;
@property (nonatomic, copy) NSString *longitude;
@property (nonatomic, copy) NSString *latitude;

@end
