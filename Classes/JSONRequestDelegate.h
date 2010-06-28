//
//  JSONRequestDelegate.h
//  DBSIndulge
//
//  Created by System Administrator on 28/11/2009.
//  Copyright 2009 Cellcity Pte Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol JSONRequestDelegate 
- (void) onDataLoad: (NSArray *) results;
- (void) onErrorLoad;
@end
