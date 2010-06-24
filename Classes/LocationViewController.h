//
//  LocationViewController.h
//  SingtelDining
//
//  Created by Alex Yao on 6/14/10.
//  Copyright 2010 CellCity. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import "SDViewController.h"
#import "StringTable.h"

@class ARViewController;



@interface LocationViewController : SDViewController  {
   ARViewController * arView;
   NSMutableArray * tempListings;
   
}
@property (nonatomic, retain) ARViewController * arView;

-(void) searchRestaurants;
-(void) closeARView;
- (void) showAR:(NSMutableArray *) listings owner:(id) o callback:(SEL) cb;
- (UIButton *) getExitButton;
- (IBAction) closeAR:(id) sender;
- (CGRect) getExitButton_rect:(UIDeviceOrientation) orientation;
@end
