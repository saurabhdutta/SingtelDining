//
//  DirectionsController.m
//  UOB_LadiesSoulMate
//
//  Created by Tonytoons on 5/15/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "DirectionsController.h"
#import "AppDelegate.h"
#import "AddressAnnotation.h"
#import "CSImageAnnotationView.h"
#import "StringTable.h"
//#import "KBBar.h"
#import "JSONRequest.h"
#import "AppDelegate.h"
//#import "NavBarButton.h"

@implementation DirectionsController
@synthesize lblAddress, segment, mapViewer, mapIcons, txtFrom, btnGo, directionView, routeView, dirMapIcons;
@synthesize request, directions, fromAddress, toAddress, btnCollapse, lblDirection, lblFrom, strAddr;
@synthesize /*kbBar, */strLat, strLong, strTitle;

/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
 - (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
 if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
 // Custom initialization
 }
 return self;
 }
 */

- (void) loadView
{
   
	self.view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 380)];
	//scroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 50, 320, 368)];
	backgroundImage = [[UIImageView alloc] initWithFrame:CGRectMake(5, 110, 310, 320)];
	segment = [[UISegmentedControl alloc] initWithFrame:CGRectMake(30,40,261,30)]; 
	lblAddress = [[UILabel alloc] initWithFrame:CGRectMake(5, 70, 310, 40)];
	lblFrom = [[UILabel alloc] initWithFrame:CGRectMake(5, 70, 45, 40)];
	txtFrom = [[UITextField alloc] initWithFrame:CGRectMake(50, 75, 200, 30)];
	btnGo = [UIButton buttonWithType:UIButtonTypeRoundedRect];//initWithFrame:CGRectMake(262, 75, 50, 32)];
	mapViewer = [[MKMapView alloc] initWithFrame:CGRectMake(10, 120, 300, 300)];
	directionView = [[MKMapView alloc] initWithFrame:CGRectMake(10, 120, 300, 300)];
	btnCollapse = [[UIButton alloc] initWithFrame:CGRectMake(10,120,261,26)];
	lblDirection = [[UITextView alloc] initWithFrame:CGRectMake(150, 129, 261, 0)];
	
	//[scroll setBackgroundColor:[UIColor whiteColor]];
   
   [btnGo setFrame:CGRectMake(262, 75, 50, 30)];
   [btnGo setTitle:@"Go" forState:UIControlStateNormal];
   [btnGo addTarget:self action:@selector(go:) forControlEvents:UIControlEventTouchDown];
   
   [lblAddress setBackgroundColor:[UIColor clearColor]];
	
	[segment insertSegmentWithTitle:@"Map" atIndex:0 animated:NO];
	[segment insertSegmentWithTitle:@"Directions" atIndex:1 animated:NO];
	[segment setSegmentedControlStyle:UISegmentedControlStyleBar];
   [segment addTarget:self action:@selector(switchView:) forControlEvents:UIControlEventValueChanged];
   
   
   [btnCollapse setBackgroundImage:[UIImage imageNamed:@"mapcategory_hide.png"] forState:UIControlStateNormal];
   [btnCollapse addTarget:self action:@selector(collapse:) forControlEvents:UIControlEventTouchDown];
	
	mapViewer.mapType = MKMapTypeStandard;
   mapViewer.tag = 0;
	mapViewer.delegate = self;
   
   directionView.tag = 1;
   directionView.delegate = self;
	
	[backgroundImage setBackgroundColor:[UIColor whiteColor]];
	
	[lblFrom setText:@"From:"];
   [lblFrom setBackgroundColor:[UIColor clearColor]];
   [lblFrom setTextAlignment:UITextAlignmentRight];
   lblFrom.font = [UIFont fontWithName:@"Helvetica" size:15.0];
   
   txtFrom.font = [UIFont fontWithName:@"Helvetica" size:15.0];
   txtFrom.borderStyle = UITextBorderStyleRoundedRect;
   txtFrom.delegate = self;
   //[txtFrom setReturnKeyType:UIReturnKeyDone];
	
	[self.view addSubview:backgroundImage];
	[self.view addSubview:segment];
	[self.view addSubview:lblAddress];
	[self.view addSubview:lblFrom];
	[self.view addSubview:txtFrom];
	[self.view addSubview:btnGo];
	[self.view addSubview:mapViewer];
	[self.view addSubview:directionView];
	[self.view addSubview:btnCollapse];
	[self.view addSubview:lblDirection];
   
   lblFrom.hidden = TRUE;
   txtFrom.hidden = TRUE;
   directionView.hidden = TRUE;
   btnCollapse.hidden = TRUE;
   lblDirection.hidden = TRUE;
   btnGo.hidden = TRUE;
	
	
	
}

- (void)viewDidLoad {
   [super viewDidLoad];
   
   hasCollapsed = FALSE;
   UIFont *f = [UIFont fontWithName:@"Helvetica-Bold" size:12.0];
   lblDirection.font = f;
   
   /*NavBarButton *btnBack = [[NavBarButton alloc] init];   
    [btnBack setTitle:@"Back" forState:UIControlStateNormal];
    [btnBack addTarget:self action:@selector(goback:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem * backButton = [[UIBarButtonItem alloc] initWithCustomView:btnBack];
    self.navigationItem.backBarButtonItem = nil;
    self.navigationItem.leftBarButtonItem = backButton;
    [backButton release];*/
}

/*
 // Override to allow orientations other than the default portrait orientation.
 - (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
 // Return YES for supported orientations
 return (interfaceOrientation == UIInterfaceOrientationPortrait);
 }
 */

- (void) viewWillAppear: (BOOL) animated{
   AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
   //delegate.header_img = @"header_plain.png";
   
   /*if( kbBar == nil){
    NSArray * topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"KBBar" owner:nil options:nil];		
    for(id currentObject in topLevelObjects){
    if([currentObject isKindOfClass:[KBBar class]]){
    kbBar = (KBBar *) currentObject;
    kbBar.owner = self;
    [kbBar setFrame: CGRectMake(0.0,368.0,320,44) ];
    kbBar.segment.hidden = TRUE;            
    [kbBar retain];
    break;
    }
    }
    
    [self.view addSubview: kbBar];
    }*/
   
   lblAddress.font = [UIFont fontWithName:@"Helvetica" size:13.0];
   lblAddress.textAlignment = UITextAlignmentCenter;
   lblAddress.text = self.strAddr; 
   lblAddress.numberOfLines = 2;
   [self loadMap];
   txtFrom.text = delegate.currentLocation;
   segment.selectedSegmentIndex = 0;
   
}

- (IBAction) goback: (id) sender{
   /* UOB_LadiesSoulMateAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    
    if( delegate.tabBarController.selectedIndex == 0 ) [delegate.mainNavController popViewControllerAnimated: YES];
    else if( delegate.tabBarController.selectedIndex == 1 ) [delegate.searchNavController popViewControllerAnimated: YES];
    else if( delegate.tabBarController.selectedIndex == 2 ) [delegate.arNavController popViewControllerAnimated: YES];*/
}

- (void) loadMap{
   AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
   
   if( mapIcons == nil ) mapIcons = [[NSMutableArray alloc] init];
   else{
      for(AddressAnnotation * icon in mapIcons){
         [mapViewer removeAnnotation: icon];
      }         
      [mapIcons removeAllObjects];
   }
   
   if( dirMapIcons == nil ) dirMapIcons = [[NSMutableArray alloc] init];
   else{
      for(AddressAnnotation * icon in dirMapIcons){
         [directionView removeAnnotation: icon];
      }         
      [dirMapIcons removeAllObjects];
   }
   
   if( routeView != nil ){
      [routeView removeMap];
      routeView = nil;
   }
   
   self.directions = nil;
	
	NSLog(@"StrLat %@\n",self.strLat);
	NSLog(@"StrLong %@\n",self.strLong);
	NSLog(@"StrAdd %@\n",self.strAddr);
	NSLog(@"Title %@\n",self.strTitle);
   
   if( [self.strLat doubleValue] != 0 ){
      self.toAddress = self.strAddr;
      [self.toAddress retain];
      
      CLLocationCoordinate2D location;
      location.latitude = [self.strLat doubleValue];
      location.longitude = [self.strLong doubleValue];
      
      toPoint.latitude = [self.strLat doubleValue];
      toPoint.longitude = [self.strLong doubleValue];
      
      AddressAnnotation * icon = [[AddressAnnotation alloc] initWithCoordinate:location];
      icon.mTitle = self.strTitle;
      icon.mSubtitle = self.strAddr;
      icon.annotationType = MapTypeOwn;
      
      [mapViewer addAnnotation:icon];
      [mapIcons addObject: icon];
      [mapIcons retain];
      
      [directionView addAnnotation:icon];
      [dirMapIcons addObject: icon];      
      [dirMapIcons retain];
      
      AddressAnnotation * icon2 = [[AddressAnnotation alloc] initWithCoordinate:delegate.currentGeo];
      icon2.mTitle = @"You are here.";
      icon2.mSubtitle = delegate.currentLocation;
      icon2.annotationType = MapTypeUser;
      
      [mapViewer addAnnotation:icon2];
      [mapIcons addObject: icon2];
      
      [directionView addAnnotation:icon2];
      [dirMapIcons addObject: icon2];
      
      [mapIcons retain];
      [dirMapIcons retain];
      
      [icon release];
      [icon2 release];
   }
   
   [self zoomToFitMapAnnotations: mapViewer];
   [self zoomToFitMapAnnotations: directionView];
   
   lblDirection.text = @"Driving Directions";
}

- (IBAction) collapse:(id) sender{
   [self toggle];
}

- (void) toggle{
   if( hasCollapsed ){
      [UIView beginAnimations:nil context:NULL];
      [UIView setAnimationDuration: 0.5];      
      btnCollapse.frame = CGRectMake(28, 129, 261, 26);
      lblDirection.frame = CGRectMake(28, 129, 261, 0);      
      [UIView commitAnimations];
      
      [btnCollapse setBackgroundImage:[UIImage imageNamed:@"mapcategory_hide.png"] forState:UIControlStateNormal];
   }
   else{      
      [txtFrom resignFirstResponder];
      
      if( directions != nil ){
         lblDirection.text = dir;
         
      }
      
      [UIView beginAnimations:nil context:NULL];
      [UIView setAnimationDuration: 0.5];      
      btnCollapse.frame = CGRectMake(28, 309, 261, 26);
      lblDirection.frame = CGRectMake(28, 129, 261, 180);
      //kbBar.frame = CGRectMake(0.0,368,320,44);
      [UIView commitAnimations];
      
      [btnCollapse setBackgroundImage:[UIImage imageNamed:@"mapcategory_unhide.png"] forState:UIControlStateNormal];
   }
   
   hasCollapsed = !hasCollapsed;
}

- (IBAction) switchView:(id) sender{
   NSLog(@"switching....\n");
   
   if( segment.selectedSegmentIndex == 0 ){
      lblFrom.hidden = TRUE;
      txtFrom.hidden = TRUE; 
      btnGo.hidden = TRUE;       
      directionView.hidden = TRUE;
      btnCollapse.hidden = TRUE;
      lblDirection.hidden = TRUE;
      
      lblAddress.hidden = FALSE;      
      mapViewer.hidden = FALSE;
   }
   else{
      lblAddress.hidden = TRUE;      
      mapViewer.hidden = TRUE;      
      
      lblFrom.hidden = FALSE;
      txtFrom.hidden = FALSE;
      btnGo.hidden = FALSE; 
      directionView.hidden = FALSE;
      btnCollapse.hidden = FALSE;
      lblDirection.hidden = FALSE;
   }
}

- (IBAction) go:(id) sender{
   [txtFrom resignFirstResponder];
   
   [UIView beginAnimations:nil context:NULL];
   [UIView setAnimationDuration: 0.5];      
   //kbBar.frame = CGRectMake(0.0,368,320,44);
   [UIView commitAnimations];
   
   btnCollapse.frame = CGRectMake(28, 129, 261, 26);
   lblDirection.frame = CGRectMake(28, 129, 261, 0);
   [btnCollapse setBackgroundImage:[UIImage imageNamed:@"mapcategory_hide.png"] forState:UIControlStateNormal];
   hasCollapsed = FALSE;
   
   AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
   //if( [[@"Address" lowercaseString] isEqualToString: [txtFrom.text lowercaseString] ] ){   
	   NSArray *keys = [NSArray arrayWithObjects: @"format", @"stripHTML", @"rdetail", @"f", @"t", @"type", @"w", @"h", nil];
   	NSArray *values = [NSArray arrayWithObjects: @"pjson", @"1", @"1", [NSString stringWithFormat:@"%f,%f", delegate.currentGeo.latitude, delegate.currentGeo.longitude], [NSString stringWithFormat:@"%f,%f", toPoint.latitude, toPoint.longitude], @"gps", @"320", @"330", nil];
      
	   if( request == nil ) request = [[JSONRequest alloc] initWithOwner:self];
   	[request loadData:URL_DIRECTION pkeys:keys pvalues:values isXML: FALSE];   
   //}
   /*else{
      NSString * from = [NSString stringWithFormat:@"%@, singapore", txtFrom.text];
      
      NSArray *keys = [NSArray arrayWithObjects: @"format", @"stripHTML", @"rdetail", @"f", @"t", @"type", @"w", @"h", nil];
      NSArray *values = [NSArray arrayWithObjects: @"pjson", @"1", @"1", from, [NSString stringWithFormat:@"%f,%f", toPoint.latitude, toPoint.longitude], @"addr", @"320", @"330", nil];
      
      if( request == nil ) request = [[JSONRequest alloc] initWithOwner:self];
      [request loadData:URL_DIRECTION pkeys:keys pvalues:values isXML: FALSE];
   }*/
}

#pragma mark TextField
- (void)textFieldDidBeginEditing:(UITextField *)textField{
   //kbBar.index = [textField tag];
   
   [UIView beginAnimations:@"MoveUp" context:nil];
   [UIView setAnimationDuration: 0.3];
   [UIView setAnimationBeginsFromCurrentState:YES];
   //kbBar.frame = CGRectMake(0.0,158,320,44);
   btnCollapse.frame = CGRectMake(28, 129, 261, 26);
   lblDirection.frame = CGRectMake(28, 129, 261, 0);       
   [UIView commitAnimations];
   
   [btnCollapse setBackgroundImage:[UIImage imageNamed:@"mapcategory_hide.png"] forState:UIControlStateNormal];
   hasCollapsed = FALSE;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
   [textField resignFirstResponder];
   return YES;
}


- (void) onPrevious:(int) index{ 
}

- (void) onNext:(int) index{  
}

- (void) zoomToFitMapAnnotations:(MKMapView*)mapView{
   if([mapView.annotations count] == 0)
      return;
   
   if( [mapView.annotations count] == 1 ){
      AddressAnnotation* annotation = [mapView.annotations objectAtIndex:0];
      
      MKCoordinateRegion region;
   	MKCoordinateSpan span;
      
  		span.latitudeDelta = 0.007;
   	span.longitudeDelta = 0.007;
      
   	region.span = span;
   	region.center = annotation.coordinate;
      [mapView setRegion:region animated:TRUE];
   	[mapView regionThatFits: region];
   }
   else{
      CLLocationCoordinate2D topLeftCoord;
      topLeftCoord.latitude = -90;
      topLeftCoord.longitude = 180;
      
      CLLocationCoordinate2D bottomRightCoord;
      bottomRightCoord.latitude = 90;
      bottomRightCoord.longitude = -180;
      
      for(AddressAnnotation* annotation in mapView.annotations)
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
      
      region = [mapView regionThatFits:region];
      [mapView setRegion:region animated:YES];
   }
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation{	
   //if( [mapView tag] == 0 ){
   MKAnnotationView* annotationView = nil;	
   AddressAnnotation * adrAnno = (AddressAnnotation *) annotation;
   
   if( adrAnno.annotationType == MapTypeOwn ){
      NSString *defaultPinID = @"AddressAnnotation";	
      MKPinAnnotationView *pin = nil;
      pin = (MKPinAnnotationView *) [mapView dequeueReusableAnnotationViewWithIdentifier: defaultPinID];
      if( pin == nil ){
         pin = pin = [[[MKPinAnnotationView alloc] initWithAnnotation: annotation reuseIdentifier: defaultPinID] autorelease];
      }
      
      if( pin ){	
         AddressAnnotation * adrAnno = (AddressAnnotation *) annotation;
         [pin setPinColor: MKPinAnnotationColorGreen];
         pin.rightCalloutAccessoryView = nil;
         
         pin.animatesDrop = YES;
         pin.canShowCallout = YES;
      }
      annotationView = pin;
   }
   else if( adrAnno.annotationType == MapTypeOther ){
      NSString* identifier = @"Image";      
      CSImageAnnotationView* imageAnnotationView = [[[CSImageAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier] autorelease];
      
      if( adrAnno.annotationType != MapTypeUser ){
         //UIButton *btnDetails = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
         //         btnDetails.tag = adrAnno.mIndex;
         //         [btnDetails addTarget:self action:@selector(goDetails:) forControlEvents:UIControlEventTouchUpInside];
         //         imageAnnotationView.rightCalloutAccessoryView = btnDetails;
         //imageAnnotationView.rightCalloutAccessoryView = nil;
      }
      
      annotationView = imageAnnotationView;
      [annotationView setEnabled:YES];
      [annotationView setCanShowCallout:YES];
   }
   else{
      NSString *defaultPinID = @"AddressAnnotation";	
      MKPinAnnotationView *pin = nil;
      pin = (MKPinAnnotationView *) [mapView dequeueReusableAnnotationViewWithIdentifier: defaultPinID];
      if( pin == nil ){
         pin = pin = [[[MKPinAnnotationView alloc] initWithAnnotation: annotation reuseIdentifier: defaultPinID] autorelease];
      }
      
      if( pin ){	
         AddressAnnotation * adrAnno = (AddressAnnotation *) annotation;
         [pin setPinColor: MKPinAnnotationColorRed];
         
         pin.rightCalloutAccessoryView = nil;
         
         pin.animatesDrop = NO;
         pin.canShowCallout = YES;
      }
      annotationView = pin;
   }
   
   return annotationView;
   //}
   //else return nil;
}

- (void)mapView:(MKMapView *)mapView regionWillChangeAnimated:(BOOL)animated{
   if( [mapView tag] == 1 ){
		if( routeView != nil ) routeView.hidden = YES;
   }
}

- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated{
   NSLog(@"Did change!!!! tag= %d\n",mapView.tag);
   if( [mapView tag] == 1 ){
		if( routeView != nil ){
      	routeView.hidden = NO;
      	[routeView setNeedsDisplay];
   	}
   }
}

- (void) onDataLoad: (NSArray *) dics{
   if( dirMapIcons == nil ) dirMapIcons = [[NSMutableArray alloc] init];
   else{
      for(AddressAnnotation * icon in dirMapIcons){
         [directionView removeAnnotation: icon];
      }         
      [dirMapIcons removeAllObjects];
   }
   
   if( routeView != nil ){
      [routeView removeMap];
      routeView = nil;
   }
   
   NSLog(@"Dics %@\n",dics);
   
   directions = [dics objectForKey:@"Steps"];	
	[directions retain];
   
   if( directions != nil ){
      if( [directions count] > 0 ){
         fromAddress = [dics objectForKey:@"From"];
         
         CLLocationCoordinate2D fromLocation;
         fromLocation.latitude = [[[[[directions objectAtIndex:0] objectForKey:@"Point"] objectForKey:@"coordinates"] objectAtIndex:1] doubleValue];
         fromLocation.longitude = [[[[[directions objectAtIndex:0] objectForKey:@"Point"] objectForKey:@"coordinates"] objectAtIndex:0] doubleValue];
         
         AddressAnnotation * fromAnnotation = [[AddressAnnotation alloc] initWithCoordinate:fromLocation];
         fromAnnotation.mTitle = fromAddress;
         fromAnnotation.mSubtitle = @"";
         fromAnnotation.annotationType = MapTypeOwn;		
         [directionView addAnnotation:fromAnnotation];
         [dirMapIcons addObject: fromAnnotation];
         
         int lastIndex = [directions count] - 1;
         CLLocationCoordinate2D toLocation;
         toLocation.latitude = [[[[[directions objectAtIndex:lastIndex] objectForKey:@"Point"] objectForKey:@"coordinates"] objectAtIndex:1] doubleValue];
         toLocation.longitude = [[[[[directions objectAtIndex:lastIndex] objectForKey:@"Point"] objectForKey:@"coordinates"] objectAtIndex:0] doubleValue];
         
         AddressAnnotation * toAnnotation = [[AddressAnnotation alloc] initWithCoordinate:toLocation];
         toAnnotation.mTitle = toAddress;
         toAnnotation.mSubtitle = @"";
         toAnnotation.annotationType = MapTypeUser;
         
         [directionView addAnnotation:toAnnotation];
         [dirMapIcons addObject: toAnnotation];
         
         dir = @"";
         int count = 0;
         for(NSDictionary * dc in directions){
            count++;
            dir = [dir stringByAppendingFormat:@"%d. %@\r\n\r\n", count, [dc objectForKey:@"descriptionHtml"] ];
         }
         [dir retain];
         
         if( [dir isEqualToString:@""] ) dir = @"No driving directions available.";
         
         NSMutableArray* points;         
         points = [[NSMutableArray alloc] init];
         
         NSArray * polylines = [dics objectForKey:@"polylines"];
         
         for(NSDictionary * poly in polylines){
            CLLocationDegrees plat   = [[poly objectForKey:@"latitude"] doubleValue]; 
            CLLocationDegrees plongi = [[poly objectForKey:@"longitude"] doubleValue]; 
            
            CLLocation* p = [[[CLLocation alloc] initWithLatitude:plat longitude:plongi] autorelease];
            [points addObject:p];
         }
         
         NSLog(@"%d points found.", [points count]);
         
         routeView = [[CSMapRouteLayerView alloc] initWithRoute:points mapView: directionView];         
         [points release];
         
         [self zoomToFitMapAnnotations: directionView];
      }
   }
}

- (void) onErrorLoad{
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
   [strLat release];
   [strLong release];
   [strTitle release];
   //[kbBar release];
   [strAddr release];
   [lblFrom release];
   [dir release];
   [lblDirection release];
   [btnCollapse release];
   [fromAddress release];
   [toAddress release];
   [request release];
   [directions release];
   [dirMapIcons release];
   [directionView release];
   [routeView release];
   [btnGo release];
   [txtFrom release];
   [mapIcons release];
   [mapViewer release];
   [segment release];
   [lblAddress release];
   [backgroundImage release];
   [super dealloc];
}

@end
