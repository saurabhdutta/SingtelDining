//
//  CouponListModel.h
//  SingtelDining
//
//  Created by Alex Yao Cheng on 11/2/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CouponListModel : TTURLRequestModel {
  //NSMutableDictionary* _parameters;
  NSArray* _list;
  
  NSString* _bank;
  NSInteger _cuisineTypeID;
  NSInteger _pageNum;
  NSInteger _resultsPerPage;
  NSInteger _totalResult;
}

@property (nonatomic, retain) NSArray* list;
@property (nonatomic, copy) NSString* bank;
@property (nonatomic) NSInteger cuisineTypeID;
@property (nonatomic) NSInteger pageNum;
@property (nonatomic) NSInteger resultsPerPage;
@property (nonatomic) NSInteger totalResult;

@end
