//
//  CreditViewController.h
//  SingtelDining
//
//  Created by Alex Yao on 6/11/10.
//  Copyright 2010 CellCity. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SDViewController.h"

#import "Three20UI/TTTableView.h"
#import "Three20UI/TTTableViewDelegate.h"
#import "Three20UI/TTTableViewVarHeightDelegate.h"
#import "Three20UI/UIViewAdditions.h"
#import "Three20UI/UITableViewAdditions.h"

@protocol TTTableViewDataSource;

@interface CreditViewController : TTViewController <TTTabDelegate, TTTableViewDelegate> {

}

@end
