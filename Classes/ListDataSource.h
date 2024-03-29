//
//  ListDataSource.h
//  SingtelDining
//
//  Created by Alex Yao on 6/19/10.
//  Copyright 2010 CellCity. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ListDataModel.h"

typedef enum {
	ListDataTypeLocation,
	ListDataTypeRestaurants,
	ListDataTypeCuisines,
	ListDataTypeSearch
} ListDataType;

@interface ListDataSource : TTListDataSource {
  ListDataModel *_dataModel;
   id dataDelegate;
   BOOL isNearbySearch;
}

- (void) setDelegate:(id) val;
- (id) delegate;
- (id)initWithType:(NSString *)type;
- (id)initWithType:(NSString *)type andSortBy:(NSString *)sortBy withKeys:(NSArray*) keys andValues:(NSArray*) values;
- (id)initWithType:(NSString *)type andCategory:(NSString *)category;
- (id)initWithType:(NSString *)type andCategory:(NSString *)category andBank:(NSString *)bank;
- (id)initWithSearchKeyword:(NSString*)keyword;

- (id)initWithDataType:(ListDataType)listDataType andParameter:(NSDictionary*)parameter;

@end
