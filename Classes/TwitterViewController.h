//
//  TwitterViewController.h
//  SingtelDining
//
//  Created by Alex Yao Cheng on 6/27/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SDViewController.h"
#import "MBProgressHUD.h"


@interface TwitterViewController : TTTableViewController <TTTextEditorDelegate,UITextFieldDelegate> {
  UITextField* username;
  UITextField* password;
  TTTextEditor* editor;
  MBProgressHUD* hud;
}

@end
