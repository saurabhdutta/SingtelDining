//
//  CreditViewController.h
//  SingtelDining
//
//  Created by Alex Yao on 6/11/10.
//  Copyright 2010 CellCity. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SDViewController.h"

@interface CreditViewController : SDViewController {
  NSMutableDictionary *selectedCards;
  UISegmentedControl *cardSegment;
  NSArray *bankArray;
  UILabel *msg;
  NSString *selectedBank;
  BOOL selectAll;
}

@end
