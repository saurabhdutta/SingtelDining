//
//  SDListView.m
//  SingtelDining
//
//  Created by Alex Yao on 6/15/10.
//  Copyright 2010 CellCity. All rights reserved.
//

#define kTopBarHeight 34

#import "SDListView.h"


@implementation SDListView
@synthesize topBarView;

#pragma mark -
#pragma mark NSObject

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
  NSLog(@"size: %f, %f", frame.size.width, frame.size.height);
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
  [topBarView release];
  NSLog(@"topbar: %i", [topBarView retainCount]);
  NSLog(@"subview: %i", [[self viewWithTag:100] retainCount]);
}

@end
