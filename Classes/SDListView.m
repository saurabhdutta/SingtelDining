//
//  SDListView.m
//  SingtelDining
//
//  Created by Alex Yao on 6/15/10.
//  Copyright 2010 CellCity. All rights reserved.
//

#import "SDListView.h"


@implementation SDListView

#pragma mark -
#pragma mark NSObject

- (void)dealloc {
  
  [super dealloc];
}

- (id)init {
  if (self = [super init]) {
    [self myInit];
  }
  return self;
}

- (id)initWithFrame:(CGRect)frame {
  if (self = [super initWithFrame:frame]) {
    [self myInit];
  }
  return self;
}

- (void)myInit {
  [super myInit];
  
  // refresh button
  /*{
    UIButton *refreshButton = [[UIButton alloc] initWithFrame:CGRectMake(2, 0, 34, 33)];
    [refreshButton setImage:[UIImage imageNamed:@"button-refresh.png"] forState:UIControlStateNormal];
    [refreshButton addTarget:self action:nil forControlEvents:UIControlEventTouchUpInside];
    [self.topBarView addSubview:refreshButton];
    [refreshButton release];
  }*/
  // dropdown box
  {
    
    TTView *dropdownBox = [[TTView alloc] initWithFrame:CGRectMake(37, 2, 160, 30)];
    dropdownBox.style = [[TTStyleSheet globalStyleSheet] styleWithSelector:@"searchTextField"];
    dropdownBox.backgroundColor = [UIColor clearColor];
    dropdownBox.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin;
    // text
    {
      UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(8, 5, 140, 18)];
      textLabel.text = @"";
      textLabel.font = [UIFont systemFontOfSize:14];
      textLabel.backgroundColor = [UIColor clearColor];
      textLabel.textColor = [UIColor redColor];
      [dropdownBox addSubview:textLabel];
      [textLabel release];
    }
    
    [self.topBarView addSubview:dropdownBox];
    [dropdownBox release];
  }
  // map and list SegmentedControl
  /*{
    UISegmentedControl *viewTypeSegment = [[UISegmentedControl alloc] initWithFrame:CGRectMake(208, 3, 100, 27)];
    [viewTypeSegment insertSegmentWithImage:[UIImage imageNamed:@"seg-map.png"] atIndex:0 animated:NO];
    [viewTypeSegment insertSegmentWithImage:[UIImage imageNamed:@"seg-ar.png"] atIndex:1 animated:NO];
    [viewTypeSegment setMomentary:YES];
    [viewTypeSegment addTarget:self action:@selector(toggleListView:) forControlEvents:UIControlEventValueChanged];
    [self.topBarView addSubview:viewTypeSegment];
    [viewTypeSegment release];
  }*/
}

@end
