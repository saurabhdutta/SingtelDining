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

/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
    }
    return self;
}
*/

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
}
*/

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
      
      /*for (int i=0; i< [listings count]; i++){
         Merchant * item = [listings objectAtIndex: i];
         
         if( [item.strLat doubleValue] != 0 ){
            tempLocation = [[CLLocation alloc] initWithLatitude:[item.strLat doubleValue] longitude:[item.strLng doubleValue]];
            tempCoordinate = [ARGeoCoordinate coordinateWithLocation:tempLocation locationTitle: item.strName];
            tempCoordinate.index = i;
            
            if( item.strDistance != nil ){
               if( ![item.strDistance isEqualToString:@""] ){
                  float d = [item.strDistance floatValue];
                  tempCoordinate.subtitle = [NSString stringWithFormat:@"%0.1f", d];
               }
               else tempCoordinate.subtitle = @"";
            }
            else tempCoordinate.subtitle = @"";
            //tempCoordinate.subtitle = @"";
            
            NSString * address = @"";      
            if( item.strStreet != nil && (NSNull *) item.strStreet != [NSNull null] && ![item.strStreet isEqualToString:@""] ){
               address = item.strStreet;
               
            }
            
            if( item.strHouseNum != nil && (NSNull *) item.strHouseNum != [NSNull null] && ![item.strHouseNum isEqualToString:@""] ){
               if( [address isEqualToString:@"" ] ) address = item.strHouseNum;
               else address = [address stringByAppendingFormat:@" %@", item.strHouseNum];
            }
            
            if( item.strCity != nil && (NSNull *) item.strCity != [NSNull null] && ![item.strCity isEqualToString:@""] ){
               if( [address isEqualToString:@"" ] ) address = item.strCity;
               else address = [address stringByAppendingFormat:@", %@", item.strCity];
            }
            
            [address retain];
            
            if( ![address isEqualToString:@""] ){
               
               tempCoordinate.subtitle2 = [NSString stringWithString:address];
            }
            else 
            {
               tempCoordinate.subtitle2 = @"";
            }
            
            
            CoordinateView *cv = [[CoordinateView alloc] initForCoordinate:(ARCoordinate *)tempCoordinate owner: o callback: cb];				    
            [arView addCoordinate:(ARCoordinate *)tempCoordinate augmentedView:cv animated:NO];
            [address release];
            [tempLocation release];
         }
      }*/
   }
   
    
   CLLocation *newCenter = [[CLLocation alloc] initWithLatitude:/*delegate.currentGeo.latitude*/0 longitude: /*delegate.currentGeo.longitude*/0 ];
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
