//
//  TabBarController.h
//  SingtelDining
//
//  Created by Alex Yao on 6/14/10.
//  Copyright 2010 CellCity. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface TabBarController : UITabBarController <UINavigationControllerDelegate> {
}
- (void)makeTabBarHidden:(BOOL)hide;
@end
