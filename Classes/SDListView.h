//
//  SDListView.h
//  SingtelDining
//
//  Created by Alex Yao on 6/15/10.
//  Copyright 2010 CellCity. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface SDListView : TTView {
  TTView *topBarView;
}
@property (nonatomic, retain) TTView *topBarView;

- (id)initWithFrame:(CGRect)frame;
- (void)myInit;

@end
