//
//  ARViewController.h
//  MiniPages
//
//  Created by Tonytoons on 4/13/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AugmentedRealityController;
@class ARCoordinate;

@interface ARViewController : UIViewController {
	AugmentedRealityController * arView;
}

@property (nonatomic, retain) AugmentedRealityController * arView;

- (void) showAR:(NSMutableArray *) listings owner:(id) o callback:(SEL) cb;
- (UIButton *) getExitButton;
- (IBAction) closeAR:(id) sender;
- (CGRect) getExitButton_rect:(UIDeviceOrientation) orientation;

@end
