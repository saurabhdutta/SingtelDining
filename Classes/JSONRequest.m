//
//  JSONRequest.m
//  DBSIndulge
//
//  Created by System Administrator on 28/11/2009.
//  Copyright 2009 Cellcity Pte Ltd. All rights reserved.
//

#import "JSONRequest.h"
#import "StringTable.h"
#import "AppDelegate.h"

@implementation JSONRequest

@synthesize responseData;
@synthesize owner;

- (id)initWithOwner:(id)del {
	if (self = [super init]) {
      self.owner = del;
   }
	return self;
}

- (NSString *) htmlencode: (NSString *) url{
   NSArray *escapeChars = [NSArray arrayWithObjects:@"<" , @">" , nil];
   
   NSArray *replaceChars = [NSArray arrayWithObjects:@"&lt;" , @"&gt;", nil];
   
   int len = [escapeChars count];
   
   NSMutableString *temp = [url mutableCopy];
   
   int i;
   for(i = 0; i < len; i++)
   {
      
      [temp replaceOccurrencesOfString: [escapeChars objectAtIndex:i]
                            withString:[replaceChars objectAtIndex:i]
                               options:NSLiteralSearch
                                 range:NSMakeRange(0, [temp length])];
   }
   
   NSString *out = [NSString stringWithString: temp];
   
   return out;
}

- (NSString *) urlencode: (NSString *) url{
   /*NSArray *escapeChars = [NSArray arrayWithObjects:@";" , @"/" , @"?" , @":" ,
    @"@" , @"&" , @"=" , @"+" ,
    @"$" , @"," , @"[" , @"]",
    @"#", @"!", @"'", @"(", 
    @")", @"*", nil];
    
    NSArray *replaceChars = [NSArray arrayWithObjects:@"%3B" , @"%2F" , @"%3F" ,
    @"%3A" , @"%40" , @"%26" ,
    @"%3D" , @"%2B" , @"%24" ,
    @"%2C" , @"%5B" , @"%5D", 
    @"%23", @"%21", @"%27",
    @"%28", @"%29", @"%2A", nil];
    
    int len = [escapeChars count];
    
    NSMutableString *temp = [url mutableCopy];
    
    int i;
    for(i = 0; i < len; i++)
    {
    
    [temp replaceOccurrencesOfString: [escapeChars objectAtIndex:i]
    withString:[replaceChars objectAtIndex:i]
    options:NSLiteralSearch
    range:NSMakeRange(0, [temp length])];
    }
    
    NSString *out = [NSString stringWithString: temp];
    
    return out;*/
   
   NSString *result = (NSString *) CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef) url, NULL, CFSTR("?=&+"), kCFStringEncodingUTF8);
   return [result autorelease];                                                                                                                        
}

- (void) loadData: (NSString *)baseURL pkeys:(NSArray *)keys pvalues:(NSArray *)values isXML:(BOOL) xml{
   isXMLResponse = xml;
   //if( ![baseURL isEqualToString:URL_REVERSE_GEO] ){
	   //UOB_LadiesSoulMateAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
   	//[delegate showLoading: YES];
   //}
   
   NSString * parameters = @"";
   int index = -1;
   
   for(NSString *v in values) {
      index++;
      NSString * encoded = [v stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
      encoded = [self urlencode:encoded];
      
      NSString * key = [keys objectAtIndex: index];
      
      if( ![parameters isEqualToString: @""] ) parameters = [parameters stringByAppendingString: @"&"];
      parameters = [parameters stringByAppendingFormat:@"%@=%@", key, encoded];
   }
   
   NSString * urlquery = [baseURL stringByAppendingFormat: @"?%@", parameters];
   NSLog(@"url is %@",urlquery);
   
   responseData = [[NSMutableData alloc] init];
	NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString: urlquery]];
	[[NSURLConnection alloc] initWithRequest:request delegate:self];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
	[responseData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
	[responseData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
	UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Connection Error!" message: [NSString stringWithFormat:@"Error: %@", [error localizedDescription]] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
	[alert show];
	[alert release];
	
	[connection release];
	responseData = nil;
	[responseData release];
   
   [owner onErrorLoad];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
	[connection release];
	
	//[[[UIApplication sharedApplication] delegate] showLoading: FALSE];
	NSString *responseString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
	responseData = nil;
	[responseData release];
   responseString = [responseString stringByReplacingOccurrencesOfString:@"{}" withString:@"\"\""];
   
   //NSLog(responseString);
   
   if( isXMLResponse ){
      
   }
   else{
		NSData *jsonData = [responseString dataUsingEncoding:NSUTF8StringEncoding];
		NSError *error = nil;
	
		NSArray * dics = [[CJSONDeserializer deserializer] deserializeAsDictionary: jsonData error: &error];
		
		[owner onDataLoad: dics];
   }
}

- (void)dealloc {
   [responseData release];
   [super dealloc];
}

@end
