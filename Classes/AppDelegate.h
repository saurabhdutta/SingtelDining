//
//  SingtelDiningAppDelegate.h
//  SingtelDining
//
//  Created by Alex Yao on 6/11/10.
//  Copyright 2010 CellCity. All rights reserved.
//

@interface AppDelegate : NSObject <UIApplicationDelegate> {
  NSMutableDictionary *settings;
}
@property (nonatomic, retain) NSMutableDictionary *settings;

- (void)loadSettings;
- (void)saveSettings;

@end

