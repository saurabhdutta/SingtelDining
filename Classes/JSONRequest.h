//
//  JSONRequest.h
//  DBSIndulge
//
//  Created by System Administrator on 28/11/2009.
//  Copyright 2009 Cellcity Pte Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONRequestDelegate.h"

@class CJSONDeserializer;

@interface JSONRequest : NSObject {
   NSMutableData * responseData;
  
   id <JSONRequestDelegate> owner;
   BOOL isXMLResponse;
}

@property (nonatomic, retain) NSMutableData * responseData;
@property id <JSONRequestDelegate> owner;

- (id)initWithOwner:(id)del;
- (NSString *) urlencode: (NSString *) url;
- (void) loadData: (NSString *)baseURL pkeys:(NSArray *)keys pvalues:(NSArray *)values isXML:(BOOL) xml;

@end
