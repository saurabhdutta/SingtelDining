//
//  SingtelDiningAppDelegate.m
//  SingtelDining
//
//  Created by Alex Yao on 6/11/10.
//  Copyright 2010 CellCity. All rights reserved.
//


#pragma mark -
#pragma mark UINavigationBar
@implementation UINavigationBar (UINavigationBarCategory)
- (void)drawRect:(CGRect)rect {
  UIImage *image = [UIImage imageNamed:@"header.png"];
	[image drawInRect:CGRectMake(self.frame.size.width/2 - 89/2, 7, 89, 56)];
  NSLog(@"drawRect");
}

@end 
#pragma mark -

 
#import "AppDelegate.h"

#import "SplashViewController.h"
#import "TabBarController.h"
#import "CreditViewController.h"
#import "CreditViewController.h"
#import "LocationViewController.h"
#import "RestaurantsViewController.h"
#import "CuisinesViewController.h"
#import "FavouritesViewController.h"
#import "DetailsViewController.h"


///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
@implementation AppDelegate


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)applicationDidFinishLaunching:(UIApplication *)application {
  TTNavigator* navigator = [TTNavigator navigator];
  
  
  // add global backgound image
  /*
  UIImageView *backgroundImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 480.0f)];
  backgroundImageView.image = [UIImage imageNamed:@"bg.png"];
  [navigator.window addSubview:backgroundImageView];
  [backgroundImageView release];
  */
  
  navigator.window.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg.png"]];
  
  
  // navigationItem background
  
  navigator.persistenceMode = TTNavigatorPersistenceModeNone;

  TTURLMap* map = navigator.URLMap;

  [map from:@"*" toViewController:[TTWebController class]];
  [map from:kAppSplashURLPath toViewController:[SplashViewController class]];
  [map from:kAppRootURLPath toSharedViewController:[TabBarController class]];
  [map from:kAppCreditURLPath toModalViewController:[CreditViewController class]];
  [map from:kAppLocaltionURLPath toViewController:[LocationViewController class]];
  [map from:kAppRestaurantsURLPath toViewController:[RestaurantsViewController class]];
  [map from:kAppCuisinesURLPath toViewController:[CuisinesViewController class]];
  [map from:kAppFavouritesURLPath toViewController:[FavouritesViewController class]];
  [map from:kAPPSearchURLPath toViewController:[CreditViewController class]];
  [map from:kAppDetailsURLPath toSharedViewController:[DetailsViewController class]];

  if (![navigator restoreViewControllers]) {
    //[navigator openURLAction:[TTURLAction actionWithURLPath:kAppSplashURLPath]];
    [navigator openURLAction:[TTURLAction actionWithURLPath:kAppRootURLPath]];
  }
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (BOOL)navigator:(TTNavigator*)navigator shouldOpenURL:(NSURL*)URL {
  return YES;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (BOOL)application:(UIApplication*)application handleOpenURL:(NSURL*)URL {
  [[TTNavigator navigator] openURLAction:[TTURLAction actionWithURLPath:URL.absoluteString]];
  return YES;
}


@end
