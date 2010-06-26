//
//  TwitterViewController.m
//  SingtelDining
//
//  Created by Alex Yao Cheng on 6/27/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "TwitterViewController.h"
#import <extThree20JSON/extThree20JSON.h>


@implementation TwitterViewController

- (id)init {
  if (self = [super init]) {
    self.tableViewStyle = UITableViewStyleGrouped;
    self.autoresizesForKeyboard = YES;
    self.variableHeightRows = YES;
  }
  return self;
}

- (void)loadView {
  [super loadView];
  self.tableView.backgroundColor = [UIColor clearColor];
  
  username = [[[UITextField alloc] init] autorelease];
  username.placeholder = @"Username";
  username.font = TTSTYLEVAR(font);
  [username setAutocapitalizationType:UITextAutocapitalizationTypeNone];
  
  password = [[[UITextField alloc] init] autorelease];
  password.placeholder = @"Password";
  password.secureTextEntry = YES;
  password.font = TTSTYLEVAR(font);
  
  editor = [[[TTTextEditor alloc] init] autorelease];
  editor.font = TTSTYLEVAR(font);
  editor.backgroundColor = TTSTYLEVAR(backgroundColor);
  editor.autoresizesToText = NO;
  editor.minNumberOfLines = 5;
  editor.placeholder = @"Tweet";
  editor.delegate = self;
  
  self.dataSource = [TTListDataSource dataSourceWithObjects:username, password, 
                     editor, [TTTableGrayTextItem itemWithText:@"#Singtel #SGBestDeals"], 
                     [TTTableButton itemWithText:@"Submit" URL:@"#submitTweet"], 
                     nil];
  
}

- (void)dealloc {
  TT_RELEASE_SAFELY(username);
  TT_RELEASE_SAFELY(password);
  TT_RELEASE_SAFELY(editor);
  [super dealloc];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark TTTextEditorDelegate
- (void)textEditorDidChange:(TTTextEditor*)textEditor {
  NSLog(@"character count: %i", [textEditor.text length]);
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)submitTweet {
  
  NSString *url = [NSString stringWithFormat:@"http://%@:%@@twitter.com/statuses/update.json",
                   username.text, password.text];
  NSString *status = [editor.text stringByAppendingString:@" #Singtel #SGBestDeals"];
  
  NSLog(@"submitTweet %@, %@, %@", username.text, password.text, status);
  
  TTURLRequest *request = [TTURLRequest requestWithURL:url delegate:self];
  request.httpMethod = @"POST";
  request.cachePolicy = TTURLRequestCachePolicyNoCache;
  
  request.response = [[[TTURLJSONResponse alloc] init] autorelease];
  
  [request.parameters setObject:status forKey:@"status"];
  
  NSLog(@"request: %@", request);
  [request send];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)requestDidFinishLoad:(TTURLRequest*)request {
  TTURLJSONResponse* response = request.response;
  TTDASSERT([response.rootObject isKindOfClass:[NSDictionary class]]);
  
  NSDictionary* feed = response.rootObject;
  NSLog(@"feed: %@",feed);
  
  [self dismissModalViewControllerAnimated:YES];
  /*
  TTDASSERT([[feed objectForKey:@"data"] isKindOfClass:[NSArray class]]);
  
  NSArray* entries = [feed objectForKey:@"data"];
  totalResults = [[feed objectForKey:@"totalResults"] intValue];
  */
}

- (void)request:(TTURLRequest*)request didFailLoadWithError:(NSError*)error {
  UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Twitter" message:@"Post tweet failed, Please check your Username and Password." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
  [alert show];
  [alert release];
  NSLog(@"request: %@, error: %@",request,error);
}

@end
