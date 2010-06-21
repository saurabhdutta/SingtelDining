//
//  ListDataSource.h
//  SingtelDining
//
//  Created by Alex Yao on 6/19/10.
//  Copyright 2010 CellCity. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface ListDataSource : TTListDataSource {

}

- (id)initWithType:(NSString *)type;
- (id)initWithType:(NSString *)type andSortBy:(NSString *)sortBy;
- (id)initWithType:(NSString *)type andCategory:(NSString *)category;
- (id)initWithType:(NSString *)type andCategory:(NSString *)category andBank:(NSString *)bank;
- (id)initWithSearchQuery:(NSString*)searchQuery;

@end
