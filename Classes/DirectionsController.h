//
//  DirectionsController.h
//  UOB_LadiesSoulMate
//
//  Created by Tonytoons on 5/15/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "CSMapRouteLayerView.h"
#import "JSONRequestDelegate.h"
//#import "KBBar.h"

@class CSMapRouteLayerView;
@class JSONRequest;
//@class KBBar;

@interface DirectionsController : UIViewController <JSONRequestDelegate, MKMapViewDelegate/*, *KBBarDelegate*/>{
	UIScrollView * scroll;
	UILabel * lblAddress;
	UISegmentedControl * segment;
	MKMapView * mapView;
	UILabel * lblFrom;
	UITextField * txtFrom;
	UIButton * btnGo;
	UIButton * btnCollapse;
	UITextView * lblDirection;
	UIImageView * backgroundImage;
	
	MKMapView * directionView;
	CSMapRouteLayerView* routeView;
	
	NSMutableArray * mapIcons;
	NSMutableArray * dirMapIcons;
	
	JSONRequest * request;
	NSArray * directions;
	bool hasCollapsed;
	
	CLLocationCoordinate2D toPoint;
	NSString * fromAddress;
	NSString * toAddress;
	NSString * dir;
	NSString * strAddr;
	NSString * strLat;
	NSString * strLong;
	NSString * strTitle;
   
   //KBBar * kbBar;
}

@property (nonatomic, retain) NSString * strLat;
@property (nonatomic, retain) NSString * strLong;
@property (nonatomic, retain) NSString * strTitle;

//@property (nonatomic, retain) KBBar * kbBar;
@property (nonatomic, retain) IBOutlet UIScrollView * scroll;

@property (nonatomic, retain) NSString * strAddr; 
@property (nonatomic, retain) IBOutlet UILabel * lblFrom;
@property (nonatomic, retain) NSString * dir;
@property (nonatomic, retain) IBOutlet UITextView * lblDirection;
@property (nonatomic, retain) IBOutlet UIButton * btnCollapse;
@property (nonatomic, retain) NSString * fromAddress;
@property (nonatomic, retain) NSString * toAddress;

@property (nonatomic, retain) JSONRequest * request;
@property (nonatomic, retain) NSArray * directions;

@property (nonatomic, retain) IBOutlet MKMapView * directionView;
@property (nonatomic, retain) CSMapRouteLayerView* routeView;
@property (nonatomic, retain) IBOutlet UITextField * txtFrom;
@property (nonatomic, retain) IBOutlet UIButton * btnGo;
@property (nonatomic, retain) IBOutlet UILabel * lblAddress;
@property (nonatomic, retain) IBOutlet UISegmentedControl * segment;
@property (nonatomic, retain) IBOutlet MKMapView * mapView;
@property (nonatomic, retain) NSMutableArray * mapIcons;
@property (nonatomic, retain) NSMutableArray * dirMapIcons;

- (IBAction) toggle:(id) sender;
- (IBAction) switchView:(id) sender;
- (IBAction) go:(id) sender;
- (IBAction) collapse:(id) sender;
- (void) toggle;
- (void) loadMap;
- (IBAction) goback: (id) sender;
- (void) zoomToFitMapAnnotations:(MKMapView*)mapVieww;
@end
