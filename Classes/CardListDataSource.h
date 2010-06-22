//
//  CardListDataSource.h
//  SingtelDining
//
//  Created by Alex Yao on 6/22/10.
//  Copyright 2010 CellCity. All rights reserved.
//

#define kImageChecked @"bundle://checked.png"
#define kImageUnchecked @"bundle://unchecked.png"

#import <Foundation/Foundation.h>


@interface CardListDataSource : TTListDataSource {
  NSString *_bankName;
}

- (id)initWithBank:(NSString *)bankName;

@end
