//
//  CoordinateView.h
//  iPhoneAugmentedRealityLib
//
//  Created by Niels W Hansen on 12/19/09.
//  Copyright 2009 Agilite Software. All rights reserved.
//

#import <UIKit/UIKit.h>


@class ARCoordinate;

@interface CoordinateView : UIView {   
	id _owner;
   SEL _callback;
}

@property id _owner;
@property SEL _callback;

- (id)initForCoordinate:(ARCoordinate *)coordinate owner:(id) o callback:(SEL) cb;
- (IBAction) onARIconClicked: (id) sender;

@end
