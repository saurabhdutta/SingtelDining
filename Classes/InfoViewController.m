//
//  InfoViewController.m
//  SingtelDining
//
//  Created by Alex Yao Cheng on 7/5/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "InfoViewController.h"


@implementation InfoViewController

- (IBAction)backButtonClicked:(id)sender {
  [self.navigationController popViewControllerAnimated:YES];
}

- (void)loadView {
  //[super loadView];
  
  self.view = [[[UIView alloc] initWithFrame:TTApplicationFrame()] autorelease];
  self.view.backgroundColor = [UIColor clearColor];
  self.navigationController.navigationBar.backgroundColor = [UIColor clearColor];
  
  UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 57, 30)];
  [backButton setImage:[UIImage imageNamed:@"button-back.png"] forState:UIControlStateNormal];
  [backButton addTarget:self action:@selector(backButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
  UIBarButtonItem *barDoneButton = [[UIBarButtonItem alloc] initWithCustomView:backButton];
  [backButton release];
  self.navigationItem.leftBarButtonItem = barDoneButton;
  [barDoneButton release];
  
  NSString* infoText = @"<p>Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aliquam gravida felis nec quam placerat mattis eleifend tellus rhoncus. Pellentesque vel augue tortor, id condimentum turpis. Pellentesque mollis, velit quis ullamcorper aliquet, dolor est ullamcorper orci, ut laoreet arcu arcu vitae mauris.</p> <p>Curabitur vitae enim a leo gravida tincidunt. Phasellus sodales mollis lacus sit amet molestie. Nullam non odio at odio porta sagittis vel non purus. Nulla id massa elit, vestibulum congue leo. Praesent lectus velit, venenatis quis dignissim et, egestas et lectus. Cras ante mi, facilisis ac euismod quis, feugiat in turpis. Aliquam egestas aliquam leo et auctor. Aliquam faucibus tempor lectus, id feugiat turpis consectetur sed. </p>";
  
  TTStyledTextLabel* infoLabel = [[TTStyledTextLabel alloc] initWithFrame:CGRectMake(5, 10, 300, 300)];
  infoLabel.font = [UIFont systemFontOfSize:14];
  infoLabel.backgroundColor = [UIColor clearColor];
  infoLabel.textColor = [UIColor whiteColor];
  infoLabel.text = [TTStyledText textFromXHTML:infoText lineBreaks:YES URLs:YES];
  [infoLabel sizeToFit];
  [self.view addSubview:infoLabel];
  
  TT_RELEASE_SAFELY(infoLabel);
}
  
@end
