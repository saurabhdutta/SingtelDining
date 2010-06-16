//
//  SDBoxView.h
//  SingtelDining
//
//  Created by Alex Yao on 6/16/10.
//  Copyright 2010 CellCity. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface SDBoxView : TTView {
  TTView *topBarView;
}

@property (nonatomic, retain) TTView *topBarView;

- (id)initWithFrame:(CGRect)frame;
- (void)myInit;

- (id)initWithFrame:(CGRect)frame titleView:(UIView *)titleView;

@end
