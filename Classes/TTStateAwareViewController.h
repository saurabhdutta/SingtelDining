//
//  TTStateAwareViewController.h
//  SingtelDining
//
//  Created by Alex Yao on 6/24/10.
//  Copyright 2010 CellCity. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface TTStateAwareViewController : TTModelViewController {
  UIView* _emptyView;
  UIView* _loadingView;
  UIView* _errorView;
  UIView* _overlayView;
}

@property (nonatomic, copy) UIView* emptyView;
@property (nonatomic, copy) UIView* loadingView;
@property (nonatomic, copy) UIView* errorView;
@property (nonatomic, copy) UIView* overlayView;

@end
