//
//  ListDataModel.h
//  SingtelDining
//
//  Created by Alex Yao on 6/23/10.
//  Copyright 2010 CellCity. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface ListDataModel : TTURLRequestModel {
  NSString* _searchQuery;
  int page;
  NSMutableArray*  _posts;
  int totalResults;
   
}
@property (nonatomic, copy)     NSString* searchQuery;
@property (nonatomic, retain) NSMutableArray*  posts;
@property (readonly) int page;
@property (readonly) int totalResults;



- (id)initWithSearchQuery:(NSString*)searchQuery;
- (id)initWithSearchQuery:(NSString*)searchQuery withSearchParameterValues:(NSArray*) values andKeys:(NSArray*) keys;
- (void)loadDataWithSearchQuery:(NSString*)searchQuery;
- (NSString *) urlencode: (NSString *) url;
- (id)initWithSearchKeyword:(NSString *)keyword;

- (id)initWithURL:(NSString*)url;

@end
