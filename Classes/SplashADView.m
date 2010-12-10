//
//  SplashADView.m
//  SingtelDining
//
//  Created by Alex Yao Cheng on 12/1/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "SplashADView.h"


@implementation SplashADView

- (id)init {
  if (self = [super initWithSession: [[[FBSession alloc] init] autorelease]]) {
    [self loadURL:URL_SPLASH_AD method:@"GET" get:nil post:nil];
    self.title = @"Loading...";
    _iconView.image = [UIImage imageNamed:@"icon14.png"];
  }
  return self;
}

@end
