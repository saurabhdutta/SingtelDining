//
//  DetailsModel.h
//  SingtelDining
//
//  Created by Alex Yao on 6/24/10.
//  Copyright 2010 CellCity. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DetailsObject;

@interface DetailsModel : TTURLRequestModel {
  int rid;
  DetailsObject *_data;
}

@property (nonatomic, copy) DetailsObject *data;

- (id)initWithRestarantsId:(int)restarantsId;

@end
