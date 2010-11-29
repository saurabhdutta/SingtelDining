//
//  TabBarController.m
//  SingtelDining
//
//  Created by Alex Yao on 6/14/10.
//  Copyright 2010 CellCity. All rights reserved.
//

#import "TabBarController.h"
#import <Three20UI/UITabBarControllerAdditions.h>

@interface UITabBarController (private)
- (UITabBar *)tabBar;
@end


@implementation TabBarController

- (void)viewDidLoad {
  [super viewDidLoad];
  
  [[UIApplication sharedApplication] setStatusBarHidden:NO animated:YES]; 
  
  CGRect frame = CGRectMake(0, 0, self.view.bounds.size.width, 50);
  UIView *v = [[UIView alloc] initWithFrame:frame];
  UIImage *i = [UIImage imageNamed:@"tabbar-bg.png"];
  UIColor *c = [[UIColor alloc] initWithPatternImage:i];
  v.backgroundColor = c;
  [c release];
  [[self tabBar] insertSubview:v atIndex:0];
  [v release];
  
  [self setTabURLs:[NSArray arrayWithObjects:
                    kAppLocaltionURLPath, 
                    kAppRestaurantsURLPath,
                    kAppCuisinesURLPath, 
                    kAppCouponURLPath, 
                    kAppMoreURLPath, 
                    nil]];
}

- (void)makeTabBarHidden:(BOOL)hide {
	if ( [self.view.subviews count] < 2 )
		return;
	
	UIView *contentView;
	
	if ( [[self.view.subviews objectAtIndex:0] isKindOfClass:[UITabBar class]] )
		contentView = [self.view.subviews objectAtIndex:1];
	else
		contentView = [self.view.subviews objectAtIndex:0];
	
	if ( hide ){
		contentView.frame = self.view.bounds;		
	}
	else{
		contentView.frame = CGRectMake(self.view.bounds.origin.x,
                                   self.view.bounds.origin.y,
                                   self.view.bounds.size.width,
                                   self.view.bounds.size.height - self.tabBar.frame.size.height);
	}
	
	self.tabBar.hidden = hide;
}

- (void)viewWillAppear:(BOOL)animated
{
  [super viewWillAppear: animated];
  //self.moreNavigationController.navigationBar.tintColor = [UIColor colorWithRed:.23 green:.03 blue:0.02 alpha:1.0];
  //self.customizableViewControllers = nil;
  self.moreNavigationController.delegate = self;
}

- (void)navigationController:(UINavigationController *)navigationController
      willShowViewController:(UIViewController *)viewController
                    animated:(BOOL)animated {
  
  UINavigationBar *morenavbar = navigationController.navigationBar;
  UINavigationItem *morenavitem = morenavbar.topItem;
  // We don't need Edit button in More screen. 
  morenavitem.rightBarButtonItem = nil;
  
  morenavbar.backgroundColor = [UIColor clearColor];
  viewController.title = @"";
  if ([viewController.title isEqualToString:@"More"]) {
    viewController.title = @"";
  }
}

@end
