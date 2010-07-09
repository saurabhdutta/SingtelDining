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
  UIBarButtonItem *barBackButton = [[UIBarButtonItem alloc] initWithCustomView:backButton];
  [backButton release];
  self.navigationItem.leftBarButtonItem = barBackButton;
  [barBackButton release];
  
  UIButton *doneButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 57, 30)];
  [doneButton setImage:[UIImage imageNamed:@"button-done.png"] forState:UIControlStateNormal];
  [doneButton addTarget:self action:@selector(dismissKeyboard:) forControlEvents:UIControlEventTouchUpInside];
  UIBarButtonItem *barDoneButton = [[UIBarButtonItem alloc] initWithCustomView:doneButton];
  [doneButton release];
  self.navigationItem.rightBarButtonItem = barDoneButton;
  [barDoneButton release];
  self.navigationItem.rightBarButtonItem.customView.hidden = YES;
  
  username = [[[UITextField alloc] init] autorelease];
  username.placeholder = @"Username";
  username.font = TTSTYLEVAR(font);
  username.delegate = self;
  username.tag = 0;
  [username setAutocapitalizationType:UITextAutocapitalizationTypeNone];
  
  password = [[[UITextField alloc] init] autorelease];
  password.placeholder = @"Password";
  password.secureTextEntry = YES;
  password.delegate = self;
  password.tag = 1;
  password.font = TTSTYLEVAR(font);
  
  editor = [[[TTTextEditor alloc] init] autorelease];
  editor.font = TTSTYLEVAR(font);
  editor.backgroundColor = TTSTYLEVAR(backgroundColor);
  editor.autoresizesToText = NO;
  editor.minNumberOfLines = 5;
  editor.placeholder = @"Tweet";
  editor.delegate = self;
  editor.tag = 2;
  
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
  
  
  hud = [[MBProgressHUD alloc] initWithView:self.view];
  [self.view addSubview:hud];
}

- (void)dealloc {
  TT_RELEASE_SAFELY(hud);
  [super dealloc];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark TTTextEditorDelegate
- (void)textEditorDidChange:(TTTextEditor*)textEditor {
  NSLog(@"character count: %i", [textEditor.text length]);
}
- (void)textEditorDidBeginEditing:(TTTextEditor*)textEditor {
  self.navigationItem.rightBarButtonItem.customView.hidden = NO;
  self.navigationItem.rightBarButtonItem.customView.tag = textEditor.tag;
}
- (void)textEditorDidEndEditing:(TTTextEditor*)textEditor {
  self.navigationItem.rightBarButtonItem.customView.hidden = YES;
  [textEditor resignFirstResponder];
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
  
  if (!TTIsStringWithAnyText(status)) {
    status = @"#SingTel #ILoveDeals";
  }
  [request.parameters setObject:status forKey:@"status"];
  
  NSLog(@"request: %@", request);
  [request send];
  [hud show:YES];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)requestDidFinishLoad:(TTURLRequest*)request {
  hud.customView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]] autorelease];
  hud.mode = MBProgressHUDModeCustomView;
  [hud hide:YES];
  
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
  [hud hide:YES];
  UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Twitter" message:@"Post tweet failed, Please check your Username and Password." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
  [alert show];
  [alert release];
  NSLog(@"request: %@, error: %@",request,error);
}

#pragma mark -
#pragma mark UITextField
- (void)textFieldDidBeginEditing:(UITextField *)textField {
  self.navigationItem.rightBarButtonItem.customView.hidden = NO;
  self.navigationItem.rightBarButtonItem.customView.tag = textField.tag;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
  self.navigationItem.rightBarButtonItem.customView.hidden = YES;
  [textField resignFirstResponder];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
	[textField resignFirstResponder];
  return YES;
}

- (IBAction)dismissKeyboard:(id)sender {
  UIButton* theButton = sender;
  switch (theButton.tag) {
    case 0:
      [username resignFirstResponder];
      break;
    case 1:
      [password resignFirstResponder];
      break;
    case 2:
      [editor resignFirstResponder];
      break;
    default:
      break;
  }
}

@end
