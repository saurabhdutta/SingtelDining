//
//  SDBoxView.m
//  SingtelDining
//
//  Created by Alex Yao on 6/16/10.
//  Copyright 2010 CellCity. All rights reserved.
//

#define kTopBarHeight 34

#import "SDBoxView.h"


@implementation SDBoxView

@synthesize topBarView;

- (void)dealloc {
  
  [topBarView release];
  [super dealloc];
}

- (id)init {
  if (self = [super init]) {
    [self myInit];
  }
  return self;
}

- (id)initWithFrame:(CGRect)frame {
  if (frame.size.height < kTopBarHeight) frame.size.height = kTopBarHeight;
  if (self = [super initWithFrame:frame]) {
    [self myInit];
  }
  return self;
}

- (void)myInit {
  // border
  self.layer.cornerRadius = 6;
  self.layer.masksToBounds = YES;
  
  // background color
  self.backgroundColor = [UIColor whiteColor];
  
  // top bar
  topBarView = [[TTView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, kTopBarHeight)];
  topBarView.style = [[TTStyleSheet globalStyleSheet] styleWithSelector:@"searchBar"];
  topBarView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin;
  topBarView.tag = 100;
  [self addSubview:topBarView];
}

- (id)initWithFrame:(CGRect)frame titleView:(UIView *)titleView {
  if (self = [super initWithFrame:frame]) {
    [self myInit];
    
    CGPoint position = titleView.frame.origin;
    position.x = (frame.size.width - titleView.frame.size.width) / 2;
    position.y = (kTopBarHeight - titleView.frame.size.height) / 2;
    titleView.frame = CGRectMake(position.x, position.y, titleView.frame.size.width, titleView.frame.size.height);
    
    [topBarView addSubview:titleView];
    //[topBarView setNeedsDisplay];
  }
  return self;
}

@end
