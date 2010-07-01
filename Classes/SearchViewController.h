//
//  SearchViewController.h
//  SingtelDining
//
//  Created by Alex Yao on 6/21/10.
//  Copyright 2010 CellCity. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SDViewController.h"
#import "SDBoxView.h"


@interface SearchViewController : SDViewController <UISearchBarDelegate> {
  UIToolbar *keyboardBar;
}

@end
