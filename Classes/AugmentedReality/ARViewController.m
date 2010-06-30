//
//  ARViewController.m
//  MiniPages
//
//  Created by Tonytoons on 4/13/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "ARViewController.h"
#import "AugmentedRealityController.h"
#import "CoordinateView.h"
#import "ARGeoCoordinate.h"
#import "ARCoordinate.h"
#import "AppDelegate.h"
#import "ListObject.h"

@implementation ARViewController
@synthesize arView;


 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
/*- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
    }
    return self;
}*/





/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/



- (IBAction) closeAR:(id) sender{
   [self.arView stop];
   [self.navigationController popViewControllerAnimated:NO];
    //segment.selectedSegmentIndex = 0;
}

- (UIButton *) getExitButton{
   UIButton * btnExit = [UIButton buttonWithType: UIButtonTypeCustom];
   btnExit.frame = CGRectMake(10, 10, 57, 30);
   [btnExit setBackgroundImage:[UIImage imageNamed:@"button-done.png"] forState:UIControlStateNormal];			
   [btnExit addTarget:self action:@selector(closeAR:) forControlEvents:UIControlEventTouchUpInside];
   //[btnExit setTitle:@"Back" forState: UIControlStateNormal];
   //[btnExit setTitleColor: [UIColor blackColor] forState: UIControlStateNormal];
   //[btnExit setFont: [UIFont boldSystemFontOfSize: 15.0]];
   
   return btnExit;
}

- (UIImageView *) getHeaderImage
{
   UIImageView * headerImage = [[UIImageView alloc] initWithImage: [UIImage imageNamed:@"header.png"]];
   headerImage.frame = CGRectMake(120, 0, 89, 56);
   return headerImage;
}

- (CGRect) getExitButton_rect:(UIDeviceOrientation) orientation{
   if (orientation == UIDeviceOrientationLandscapeLeft) return CGRectMake(10, 10, 57, 30);
   else if (orientation == UIDeviceOrientationLandscapeRight) return CGRectMake(10, 10, 57, 30);
   else if (orientation == UIDeviceOrientationPortraitUpsideDown) return CGRectMake(10, 10, 57, 30);
   else return CGRectMake(10, 10, 57, 30);
}

- (CGRect) getHeaderImage_rect:(UIDeviceOrientation) orientation{
   if (orientation == UIDeviceOrientationLandscapeLeft) return CGRectMake(180, 10, 89, 56);
   else if (orientation == UIDeviceOrientationLandscapeRight) return CGRectMake(180, 10, 89, 56);
   else if (orientation == UIDeviceOrientationPortraitUpsideDown) return CGRectMake(120, 10, 89, 56);
   else return CGRectMake(120, 10, 89, 56);
}

- (void) showAR:(NSMutableArray *) listings owner:(id) o callback:(SEL) cb{
   [listings retain];
   AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
   if( self.arView == nil ){
	    self.arView = [[AugmentedRealityController alloc] initWithViewController:self];
    
    	[arView setDebugMode:NO];
	   [arView setScaleViewsBasedOnDistance:NO];
   	[arView setMinimumScaleFactor:0.5];
	   [arView setRotateViewsBasedOnPerspective:YES];    
   }  
   
   [arView clearCoordinates];
   
   if ([listings count] > 0) {
      
      ARGeoCoordinate *tempCoordinate;
      CLLocation		*tempLocation;
      
      for (int i=0; i< [listings count]; i++){
         
         NSDictionary * data = [NSDictionary dictionaryWithDictionary:[listings objectAtIndex:i]];
         
         //NSLog(@"data: %@\n",data);
         
         if( [[data objectForKey:@"Latitude"] doubleValue] != 0 ){
            tempLocation = [[CLLocation alloc] initWithLatitude:[[data objectForKey:@"Latitude"] doubleValue] longitude:[[data objectForKey:@"Longitude"] doubleValue]];
            tempCoordinate = [ARGeoCoordinate coordinateWithLocation:tempLocation locationTitle: [data objectForKey:@"RestaurantName"]];
            tempCoordinate.index = [[data objectForKey:@"ID"] intValue];
            
            
            tempCoordinate.subtitle = ([[data objectForKey:@"Distance"] doubleValue] > 0.0)?[NSString stringWithFormat:@"%0.1f km",[[data objectForKey:@"Distance"] doubleValue]]:@"";
            
            tempCoordinate.subtitle2 = [data objectForKey:@"Address"];
            
            
            
            
            CoordinateView *cv = [[CoordinateView alloc] initForCoordinate:(ARCoordinate *)tempCoordinate owner: o callback: cb];				    
            [arView addCoordinate:(ARCoordinate *)tempCoordinate augmentedView:cv animated:NO];
            
            [tempLocation release];
         }
      }
   
   }
   
    
   CLLocation *newCenter = [[CLLocation alloc] initWithLatitude:delegate.currentGeo.latitude longitude: delegate.currentGeo.longitude ];
   self.arView.centerLocation = newCenter;
   [newCenter release];
   
   if( self.arView.displayView != nil ) self.arView.displayView.hidden = FALSE;
   
   [self.arView startListening]; 
   [arView displayAR];
   [listings release];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
   return YES;
}

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}

- (void)dealloc {
   [arView release];
   [super dealloc];
}

@end
