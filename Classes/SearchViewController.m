//
//  SearchViewController.m
//  SingtelDining
//
//  Created by Alex Yao on 6/21/10.
//  Copyright 2010 CellCity. All rights reserved.
//

#import "SearchViewController.h"
#import "ListDataSource.h"


@implementation SearchViewController

- (void)dealloc {
  TT_RELEASE_SAFELY(keyboardBar);
  [super dealloc];
}

- (void)loadView {
  [super loadView];
  
  
  SDBoxView *boxView = [[SDBoxView alloc] initWithFrame:CGRectMake(5, 0, 310, kBoxNormalHeight)];
  
  {
    self.tableView.frame = CGRectMake(5, 40, 300, 310);
    self.tableView.backgroundColor = [UIColor clearColor];
    [boxView addSubview:self.tableView];
  }
  
  {
    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 3, 310, 30)];
    searchBar.delegate = self;
    searchBar.placeholder = @"keyword";
    searchBar.tag = 1001;
    [[searchBar.subviews objectAtIndex:0] setHidden:YES];
    [boxView addSubview:searchBar];
    TT_RELEASE_SAFELY(searchBar);
  }
  
  [self.view addSubview:boxView];
  [boxView release];
  
  
  NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
  [nc addObserver:self selector:@selector(keyboardWillShow:) name: UIKeyboardWillShowNotification object:nil];
  [nc addObserver:self selector:@selector(keyboardWillHide:) name: UIKeyboardWillHideNotification object:nil];
  
  keyboardBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 480, 320, 40)];
  UIBarButtonItem *flexSpaceButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
  UIBarButtonItem *dismissKeyboardButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStyleBordered target:self action:@selector(dismissKeyboard:)];
  [keyboardBar setItems:[NSArray arrayWithObjects:flexSpaceButton, dismissKeyboardButton, nil]];
  TT_RELEASE_SAFELY(dismissKeyboardButton);
  TT_RELEASE_SAFELY(flexSpaceButton);
  [self.view addSubview:keyboardBar];
}

/////////////////////////////////////////////////////////////////////////////////////
- (void)createModel {
  self.dataSource = [TTListDataSource dataSourceWithItems:[NSMutableArray array]];
}
///////////////////////////////////////////////////////////////////////////////////////////////////
- (id<UITableViewDelegate>)createDelegate {
  return [[[TTTableViewPlainVarHeightDelegate alloc] initWithController:self] autorelease];
}

/////////////////////////////////////////////////////////////////////////////////////
#pragma mark UISearchBarDelegate

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    // Configure our TTModel with the user's search terms
    // and tell the TTModelViewController to reload.
  [searchBar resignFirstResponder];
  self.dataSource = [[[ListDataSource alloc] initWithSearchKeyword:[searchBar text]] autorelease];
  [self reload];
  [self.tableView scrollToTop:YES];
}


- (IBAction)dismissKeyboard:(id)sender {
  [[self.view viewWithTag:1001] resignFirstResponder];
}

-(void) keyboardWillShow:(NSNotification *)notification{
  
  [UIView beginAnimations:nil context:NULL];
  [UIView setAnimationCurve:[[[notification userInfo] objectForKey:UIKeyboardAnimationCurveUserInfoKey] intValue]];
  [UIView setAnimationDuration:[[[notification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue]];
  
  CGRect frame = keyboardBar.frame;
  frame.origin.y -= [[[notification userInfo] objectForKey:UIKeyboardBoundsUserInfoKey] CGRectValue].size.height +100;
  keyboardBar.frame = frame;
  
  [UIView commitAnimations];
}

-(void) keyboardWillHide:(NSNotification *)notification{
  [UIView beginAnimations:nil context:NULL];
  [UIView setAnimationCurve:[[[notification userInfo] objectForKey:UIKeyboardAnimationCurveUserInfoKey] intValue]];
  [UIView setAnimationDuration:[[[notification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue]];
  
  CGRect frame = keyboardBar.frame;
  frame.origin.y += [[[notification userInfo] objectForKey:UIKeyboardBoundsUserInfoKey] CGRectValue].size.height +100;
  keyboardBar.frame = frame;
  
  [UIView commitAnimations];
}


@end
