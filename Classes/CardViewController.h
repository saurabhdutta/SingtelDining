//
//  CardViewController.h
//  SingtelDining
//
//  Created by Alex Yao Cheng on 7/5/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SDViewController.h"


@interface CardViewController : SDViewController <TTURLRequestDelegate> {
  UISegmentedControl* cardSegment;
  NSMutableArray* userSelectedIndexPaths;
  BOOL isSelectAll;
}

@end
