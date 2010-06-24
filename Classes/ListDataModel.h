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
  
  NSArray*  _posts;
}
@property (nonatomic, copy)     NSString* searchQuery;
@property (nonatomic, readonly) NSArray*  posts;

- (id)initWithSearchQuery:(NSString*)searchQuery;
- (id)initWithSearchQuery:(NSString*)searchQuery withSearchParameterValues:(NSArray*) values andKeys:(NSArray*) keys;
- (NSString *) urlencode: (NSString *) url;
@end
