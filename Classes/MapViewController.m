//
//  MapViewController.m
//  SingtelDining
//
//  Created by System Administrator on 27/06/10.
//  Copyright 2010 Cellcity Pte Ltd. All rights reserved.
//

#import "MapViewController.h"
#import "AddressAnnotation.h"
#import "CSImageAnnotationView.h"
#import "AppDelegate.h"
#import "ListObject.h"
#import "DetailsViewController.h"


@implementation MapViewController


/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
    }
    return self;
}
*/


// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
   
   self.view = [[UIView alloc] initWithFrame:CGRectMake(5, 40, 300, 249)];
   
   mapView = [[MKMapView alloc] initWithFrame:CGRectMake(0, 0, 300, 249)];
   mapView.mapType = MKMapTypeStandard;
   mapView.delegate = self;
   
}


- (void) showMapWithData:(NSMutableArray*) data
{
   
   if( mapIcons == nil ) mapIcons = [NSMutableArray array];
	else{
      for(AddressAnnotation * icon in mapIcons){
      	[mapView removeAnnotation: icon];
      }
      
      [mapIcons removeAllObjects];
      NSLog(@"Map Icons removed!");
   }
   
   
  
   
      
   for(int i=0; i< [data count]; i++){

      NSDictionary * restaurants = [NSDictionary dictionaryWithDictionary:[data objectAtIndex:i]];
      
      
      NSString * strLat = [restaurants objectForKey:@"Latitude"];
      if( strLat != nil && (NSNull *) strLat != [NSNull null] && ![strLat isEqualToString:@""] ){
	      CLLocationCoordinate2D location;
   	   location.latitude = [[restaurants objectForKey:@"Latitude"] floatValue];
      	location.longitude = [[restaurants objectForKey:@"Longitude"] floatValue];
         
         //NSLog(@"lat %f\n",location.latitude);
         //NSLog(@"long %f\n",location.longitude);
         
	      AddressAnnotation * icon = [[AddressAnnotation alloc] initWithCoordinate:location];
   	   icon.mTitle = [restaurants objectForKey:@"RestaurantName"];
      	icon.mSubtitle = [restaurants objectForKey:@"Address"];      
	      icon.annotationType = MapTypeTP;
   	   icon.mIndex = [[restaurants objectForKey:@"ID"] intValue];
			icon.strImg = @"icon_poi.png";  
         
         
	      [mapView addAnnotation:icon];
   	   [mapIcons addObject: icon];
	      [icon release];
      }
      
      
   }
   
   [mapIcons retain];
   [self zoomToFitMapAnnotations: mapView];
   [self.view addSubview:mapView];

}


- (void) zoomToFitMapAnnotations:(MKMapView*)mpView{
   if([mpView.annotations count] == 0)
      return;
   
   CLLocationCoordinate2D topLeftCoord;
   topLeftCoord.latitude = -90;
   topLeftCoord.longitude = 180;
   
   CLLocationCoordinate2D bottomRightCoord;
   bottomRightCoord.latitude = 90;
   bottomRightCoord.longitude = -180;
   
   for(AddressAnnotation* annotation in mpView.annotations)
   {
      topLeftCoord.longitude = fmin(topLeftCoord.longitude, annotation.coordinate.longitude);
      topLeftCoord.latitude = fmax(topLeftCoord.latitude, annotation.coordinate.latitude);
      
      bottomRightCoord.longitude = fmax(bottomRightCoord.longitude, annotation.coordinate.longitude);
      bottomRightCoord.latitude = fmin(bottomRightCoord.latitude, annotation.coordinate.latitude);
   }
   
   MKCoordinateRegion region;
   region.center.latitude = topLeftCoord.latitude - (topLeftCoord.latitude - bottomRightCoord.latitude) * 0.5;
   region.center.longitude = topLeftCoord.longitude + (bottomRightCoord.longitude - topLeftCoord.longitude) * 0.5;
   region.span.latitudeDelta = fabs(topLeftCoord.latitude - bottomRightCoord.latitude) * 1.1; // Add a little extra space on the sides
   region.span.longitudeDelta = fabs(bottomRightCoord.longitude - topLeftCoord.longitude) * 1.1; // Add a little extra space on the sides
   
   region = [mpView regionThatFits:region];
   [mpView setRegion:region animated:YES];
}


#pragma mark -
#pragma mark MapView delegate

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{	
	MKAnnotationView* annotationView = nil;	
	AddressAnnotation * adrAnno = (AddressAnnotation *) annotation;
	
   NSString* identifier = @"Image";
   
   imageAnnotationView = [[[CSImageAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier] autorelease];
   
   annotationView = imageAnnotationView;
   [annotationView setEnabled:YES];
   [annotationView setCanShowCallout:YES];
   
   //MKAnnotationView *customAnnotationView=[[[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:nil] autorelease];
//   UIImage *pinImage = [UIImage imageNamed:@"ReplacementPinImage.png"];
//   [customAnnotationView setImage:pinImage];
//   customAnnotationView.canShowCallout = YES;
//   UIImageView *leftIconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"LeftIconImage.png"]];
//   customAnnotationView.leftCalloutAccessoryView = leftIconView;
   UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
   rightButton.tag = adrAnno.mIndex;
   [rightButton addTarget:self action:@selector(annotationViewClick:) forControlEvents:UIControlEventTouchUpInside];
   annotationView.rightCalloutAccessoryView = rightButton;

	
	return annotationView;	
}


-(IBAction) annotationViewClick:(id)sender
{
   //DetailsViewController * controller = [[DetailsViewController alloc] initWithRestaurantId:[sender tag]];
//   [self.navigationController pushViewController:controller animated:YES];
//   [controller release];
   printf("tag %d\n",[sender tag]);
   TTOpenURL([NSString stringWithFormat:@"tt://details/%i", [sender tag]]);
}

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
   [mapIcons release];
   [mapView release];
   [imageAnnotationView release];
   [self.view release];
    [super dealloc];
}


@end
