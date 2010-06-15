//
//  TabBarController.m
//  SingtelDining
//
//  Created by Alex Yao on 6/14/10.
//  Copyright 2010 CellCity. All rights reserved.
//

#import "TabBarController.h"

@interface UITabBarController (private)
- (UITabBar *)tabBar;
@end


@implementation TabBarController

- (void)viewDidLoad {
  [super viewDidLoad];
  
  CGRect frame = CGRectMake(0, 0, self.view.bounds.size.width, 50);
  UIView *v = [[UIView alloc] initWithFrame:frame];
  UIImage *i = [UIImage imageNamed:@"tabbar-bg.png"];
  UIColor *c = [[UIColor alloc] initWithPatternImage:i];
  v.backgroundColor = c;
  [c release];
  [[self tabBar] insertSubview:v atIndex:0];
  [v release];
  
  [self setTabURLs:[NSArray arrayWithObjects:kAppLocaltionURLPath, kAppRestaurantsURLPath,
                    kAppCuisinesURLPath, kAppFavouritesURLPath, kAPPSearchURLPath, nil]];
}

@end
