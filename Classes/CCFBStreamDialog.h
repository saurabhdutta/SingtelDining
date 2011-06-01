//
//  CCFBStreamDialog.h
//  SingtelDining
//
//  Created by DBS Mobile Apps on 5/18/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FBConnect/FBStreamDialog.h"


@interface CCFBStreamDialog : FBStreamDialog {
	NSString *messge;
}

@property (nonatomic, retain) NSString *message;

@end
