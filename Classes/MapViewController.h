//
//  MapViewController.h
//  SingtelDining
//
//  Created by System Administrator on 27/06/10.
//  Copyright 2010 Cellcity Pte Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@class AddressAnnotation;
@class CSImageAnnotationView;

@interface MapViewController : UIViewController<MKMapViewDelegate> {
   MKMapView *mapView;
   //AddressAnnotation * icon;
   CSImageAnnotationView* imageAnnotationView;
   NSMutableArray * mapIcons;
}
//- (void) reload;
- (void) showMapWithData:(NSMutableArray*) data;
- (void) zoomToFitMapAnnotations:(MKMapView*)mapView;
@end
