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
//#import "GP_AutomobileAppDelegate.h"
//#import "Merchant.h"

@implementation ARViewController
@synthesize arView;


 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
/*- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
    }
    return self;
}*/



-(void)loadView
{
   self.view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 380) ];
//   [[[[UIApplication sharedApplication] delegate] window] addSubview:self.view];
}


/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/



- (IBAction) closeAR:(id) sender{
   [self.arView stop];
    //segment.selectedSegmentIndex = 0;
}

- (UIButton *) getExitButton{
   UIButton * btnExit = [UIButton buttonWithType: UIButtonTypeCustom];
   btnExit.frame = CGRectMake(210, 430, 100, 41);
   [btnExit setBackgroundImage:[UIImage imageNamed:@"small_button.png"] forState:UIControlStateNormal];			
   [btnExit addTarget:self action:@selector(closeAR:) forControlEvents:UIControlEventTouchUpInside];
   [btnExit setTitle:@"Back" forState: UIControlStateNormal];
   [btnExit setTitleColor: [UIColor blackColor] forState: UIControlStateNormal];
   [btnExit setFont: [UIFont boldSystemFontOfSize: 15.0]];
   
   return btnExit;
}

- (CGRect) getExitButton_rect:(UIDeviceOrientation) orientation{
   if (orientation == UIDeviceOrientationLandscapeLeft) return CGRectMake(370, 272, 100, 41);
   else if (orientation == UIDeviceOrientationLandscapeRight) return CGRectMake(370, 272, 100, 41);
   else if (orientation == UIDeviceOrientationPortraitUpsideDown) return CGRectMake(210, 430, 100, 41);
   else return CGRectMake(210, 430, 100, 41);
}

- (void) showAR:(NSMutableArray *) listings owner:(id) o callback:(SEL) cb{
   //GP_AutomobileAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
   if( self.arView == nil ){
	    self.arView = [[AugmentedRealityController alloc] initWithViewController:self];
    
    	[arView setDebugMode:NO];
	   [arView setScaleViewsBasedOnDistance:NO];
   	[arView setMinimumScaleFactor:0.5];
	   [arView setRotateViewsBasedOnPerspective:YES];    
   }  
   
   [arView clearCoordinates];
   
   if ([listings count] > 0) {
      NSMutableArray *tempLocationArray = [[NSMutableArray alloc] init];
      ARGeoCoordinate *tempCoordinate;
      CLLocation		*tempLocation;
      
      for (int i=0; i< [listings count]; i++){
         
         NSDictionary * dictionary = [NSDictionary dictionaryWithDictionary: [listings objectAtIndex:i]];
         
         if( [[dictionary objectForKey:@"Lat"] doubleValue] != 0 ){
            tempLocation = [[CLLocation alloc] initWithLatitude:[[dictionary objectForKey:@"Lat"] doubleValue] longitude:[[dictionary objectForKey:@"Long"] doubleValue]];
            tempCoordinate = [ARGeoCoordinate coordinateWithLocation:tempLocation locationTitle: [dictionary objectForKey:@"Name"]];
            tempCoordinate.index = i;
            
            
            tempCoordinate.subtitle = [dictionary objectForKey:@"SecondName"];
            
            tempCoordinate.subtitle2 = [dictionary objectForKey:@"ThirdName"];
            
            
            CoordinateView *cv = [[CoordinateView alloc] initForCoordinate:(ARCoordinate *)tempCoordinate owner: o callback: cb];				    
            [arView addCoordinate:(ARCoordinate *)tempCoordinate augmentedView:cv animated:NO];
            
            [tempLocation release];
         }
      }
   
   }
   
    
   CLLocation *newCenter = [[CLLocation alloc] initWithLatitude:kTestLatitude longitude: kTestLongitude ];
   self.arView.centerLocation = newCenter;
   [newCenter release];
   
   if( self.arView.displayView != nil ) self.arView.displayView.hidden = FALSE;
   
   [arView startListening]; 
   [arView displayAR];
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
