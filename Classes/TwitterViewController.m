//
//  TwitterViewController.m
//  SingtelDining
//
//  Created by Alex Yao Cheng on 6/27/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#define KTwitterUsername @"TwitterUsername"
#define KTwitterPassword @"TwitterPassword"

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
  self.view.backgroundColor = [UIColor clearColor];
  self.navigationController.navigationBar.backgroundColor = [UIColor clearColor];
  self.tableView.backgroundColor = [UIColor clearColor];
  
  UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 57, 30)];
  [backButton setImage:[UIImage imageNamed:@"button-back.png"] forState:UIControlStateNormal];
  [backButton addTarget:self action:@selector(backButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
  UIBarButtonItem *barDoneButton = [[UIBarButtonItem alloc] initWithCustomView:backButton];
  [backButton release];
  self.navigationItem.leftBarButtonItem = barDoneButton;
  [barDoneButton release];
  
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
  
  self.dataSource = [TTListDataSource dataSourceWithObjects:[TTTableControlItem itemWithCaption:@"Username:" control:username], 
                     [TTTableControlItem itemWithCaption:@"Password:" control:password], 
                     editor, [TTTableGrayTextItem itemWithText:@"#Singtel #ILoveDeals"], 
                     [TTTableButton itemWithText:@"Submit" URL:@"#submitTweet"], 
                     nil];
  
  NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
  NSString* tUsername = [defaults objectForKey:KTwitterUsername];
  NSString* tPassword = [defaults objectForKey:KTwitterPassword];
  
  if (TTIsStringWithAnyText(tUsername)) {
    username.text = tUsername;
  }
  if (TTIsStringWithAnyText(tPassword)) {
    password.text = tPassword;
  }
  
}

- (void)dealloc {
  [super dealloc];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark TTTextEditorDelegate
- (void)textEditorDidChange:(TTTextEditor*)textEditor {
  NSLog(@"character count: %i", [textEditor.text length]);
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (IBAction)backButtonClicked:(id)sender {
  [self dismissModalViewControllerAnimated:YES];
}

- (void)submitTweet {
  
  NSString *url = [NSString stringWithFormat:@"http://%@:%@@twitter.com/statuses/update.json",
                   username.text, password.text];
  NSString *status = [editor.text stringByAppendingString:@" #SingTel #ILoveDeals"];
  
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
  
  // store twitter username & password
  NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
  [defaults setObject:username.text forKey:KTwitterUsername];
  [defaults setObject:password.text forKey:KTwitterPassword];
  
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
