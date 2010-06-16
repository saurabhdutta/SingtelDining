//
//  SplashViewController.m
//  SingtelDining
//
//  Created by Alex Yao Cheng on 6/15/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "SplashViewController.h"


@implementation SplashViewController

-(void)myMovieFinishedCallback:(NSNotification*)aNotification 
{
	NSLog(@"finish");
  MPMoviePlayerController* theMovie=[aNotification object];
  [[NSNotificationCenter defaultCenter] removeObserver:self 
                                                  name:MPMoviePlayerPlaybackDidFinishNotification 
                                                object:theMovie];
	
    // Release the movie instance created in playMovieAtURL
  [theMovie release];
	
	TTNavigator *navigator = [TTNavigator navigator];
  [navigator.URLMap removeURL:kAppSplashURLPath];
  [navigator openURLAction:[[TTURLAction actionWithURLPath:kAppRootURLPath] applyAnimated:YES]];
}

- (void)loadView {
  [super loadView];
  
  self.navigationController.navigationBar.hidden = YES;
  
  NSString *moviePath = [[NSBundle mainBundle] pathForResource:@"splash" ofType:@"m4v"];
	
	MPMoviePlayerController *theMovie = [[MPMoviePlayerController alloc] initWithContentURL:[NSURL fileURLWithPath:moviePath]];
	
	theMovie.movieControlMode = MPMovieControlModeHidden; // hidden controls
	theMovie.scalingMode = MPMovieScalingModeAspectFill;
	
	[[NSNotificationCenter defaultCenter] addObserver:self 
                                           selector:@selector(myMovieFinishedCallback:) 
                                               name:MPMoviePlayerPlaybackDidFinishNotification 
                                             object:theMovie];
	
	[theMovie play];
}

@end
