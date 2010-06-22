//
//  DetailsViewController.m
//  SingtelDining
//
//  Created by Alex Yao on 6/18/10.
//  Copyright 2010 CellCity. All rights reserved.
//

#import "DetailsViewController.h"


@implementation DetailsViewController

- (void)dealloc {
  TT_RELEASE_SAFELY(restaurantInfo);
  TT_RELEASE_SAFELY(ratingView);
  [super dealloc];
}

- (IBAction)ratingIt:(id)sender {
  RatingView *rv = [[RatingView alloc] init];
  rv.backgroundColor = [UIColor clearColor];
  [rv setImagesDeselected:@"0.png" partlySelected:@"1.png" fullSelected:@"2.png" andDelegate:self];
  [rv displayRating:rating];
  
  UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Rate it" message:@"\n\n\n" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
  [alert addButtonWithTitle:@"Submit"];
  [alert addSubview:rv];
  //[rv setFrame:CGRectMake(50, 50, 200, 30)];
  [rv setCenter:CGPointMake(140, 80)];
  [rv release];
  [alert show];
  [alert release];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
  if (buttonIndex == 1) {
    [ratingView displayRating:rating];
  }
}

- (void)ratingChanged:(float)newRating {
  rating = newRating;
}

- (IBAction)selectCard:(id)sender {
  UIButton *theButton = (UIButton *)sender;
  /*
  for (id object in theButton.superview) {
    if ([object isKindOfClass:[UIButton class]]) {
      [(UIButton*)object setSelected:NO];
    }
  }
  */
  theButton.selected = YES;
  NSLog(@"button %i clicked", [theButton tag]);
  [self updateInfoView:@"test"];
}

- (void)updateInfoView:(NSString *)infoText {
  //UIScrollView *restaurantBox = (UIScrollView *)[self.view viewWithTag:201];
  [UIView beginAnimations:@"animationID" context:nil];
	[UIView setAnimationDuration:0.5f];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
  [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:[self.view viewWithTag:201] cache:YES];
	[UIView setAnimationRepeatAutoreverses:NO];
  [UIView commitAnimations];
}

- (void)loadView {
  [super loadView];
  self.view.backgroundColor = [UIColor clearColor];
  self.navigationController.navigationBar.backgroundColor = [UIColor clearColor];
  
  UIScrollView *restaurantBox = [[UIScrollView alloc] initWithFrame:CGRectMake(5, 0, 310, 120)];
  restaurantBox.tag = 201;
  restaurantBox.backgroundColor = [UIColor whiteColor];
  restaurantBox.layer.cornerRadius = 6;
  restaurantBox.layer.masksToBounds = YES;
  restaurantBox.scrollEnabled = YES;
  {
    // title
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 220, 18)];
    //titleLabel.backgroundColor = [UIColor grayColor];
    titleLabel.font = [UIFont boldSystemFontOfSize:17];
    titleLabel.textColor = [UIColor grayColor];
    titleLabel.text = @"Aans Korea Restaurant";
    [restaurantBox addSubview:titleLabel];
    TT_RELEASE_SAFELY(titleLabel);
    
    // category
    UILabel *categoryLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 25, 220, 15)];
    //categoryLabel.backgroundColor = [UIColor redColor];
    categoryLabel.font = [UIFont systemFontOfSize:14];
    categoryLabel.textColor = [UIColor blueColor];
    categoryLabel.text = @"Korean";
    [restaurantBox addSubview:categoryLabel];
    TT_RELEASE_SAFELY(categoryLabel);
    
    // rating
    CGRect ratingFrame = CGRectMake(220, 10, 70, 20);
    ratingView = [[RatingView alloc] init];
    [ratingView setImagesDeselected:@"s0.png" partlySelected:@"s1.png" fullSelected:@"s2.png" andDelegate:nil];
    [ratingView displayRating:rating];
    [ratingView setFrame:ratingFrame];
    [restaurantBox addSubview:ratingView];
    
    UIButton *ratingButton = [[UIButton alloc] initWithFrame:ratingFrame];
    [ratingButton addTarget:self action:@selector(ratingIt:) forControlEvents:UIControlEventTouchUpInside];
    [restaurantBox addSubview:ratingButton];
    TT_RELEASE_SAFELY(ratingButton);
    
    // photo
    UIImageView *photoView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 40, 90, 70)];
    photoView.image = [UIImage imageNamed:@"rastauran-photo.png"];
    [restaurantBox addSubview:photoView];
    TT_RELEASE_SAFELY(photoView);
    
    // info
    NSString *infoText = @"<div class=\"offer\">Citibank Offer:</div><div class=\"highlight\">1 for 1 Lunch promo</div><div class=\"grey\">Valid till 30 jun 2010</div>";
    restaurantInfo = [[TTStyledTextLabel alloc] initWithFrame:CGRectMake(125, 40, 185, 60)];
    restaurantInfo.font = [UIFont systemFontOfSize:15];
    restaurantInfo.text = [TTStyledText textFromXHTML:infoText lineBreaks:YES URLs:YES];
    restaurantInfo.contentInset = UIEdgeInsetsMake(10, 10, 10, 10);
    [restaurantInfo sizeToFit];
    [restaurantBox addSubview:restaurantInfo];
    TT_RELEASE_SAFELY(restaurantInfo); 
  }
  
  [restaurantBox setContentSize:CGSizeMake(280, 200)];
  [self.view addSubview:restaurantBox];
  TT_RELEASE_SAFELY(restaurantBox);
  
  UIScrollView *cardBox = [[UIScrollView alloc] initWithFrame:CGRectMake(5, 125, 310, 45)];
  cardBox.backgroundColor = [UIColor whiteColor];
  cardBox.layer.cornerRadius = 6;
  cardBox.layer.masksToBounds = YES;
  cardBox.scrollEnabled = YES;
  {
    UIImage *buttonImage = [UIImage imageNamed:@"uob-card.png"];
    UIImage *buttonSelectImage = [UIImage imageNamed:@"active-uob-cardbg.png"];
    for (int i=0; i<10; i++) {
      UIButton *cardButton = [[UIButton alloc] init];
      [cardButton setImage:buttonImage forState:UIControlStateNormal];
      [cardButton setImage:buttonSelectImage forState:UIControlStateSelected];
      [cardButton addTarget:self action:@selector(selectCard:) forControlEvents:UIControlEventTouchUpInside];
      cardButton.frame = CGRectMake(60*i, 7, 60, 30);
      cardButton.tag = i;
      [cardBox addSubview:cardButton];
      TT_RELEASE_SAFELY(cardButton);
    }
    [cardBox setContentSize:CGSizeMake(600, 45)];
  }
  [self.view addSubview:cardBox];
  TT_RELEASE_SAFELY(cardBox);
  
  UIScrollView *descriptionBox = [[UIScrollView alloc] initWithFrame:CGRectMake(5, 175, 310, 185)];
  descriptionBox.backgroundColor = [UIColor whiteColor];
  descriptionBox.layer.cornerRadius = 6;
  descriptionBox.layer.masksToBounds = YES;
  descriptionBox.scrollEnabled = YES;
  {
    // icon buttons
    UIButton *phoneButton = [[UIButton alloc] initWithFrame:CGRectMake(5, 5, 30, 30)];
    [phoneButton setImage:[UIImage imageNamed:@"phone-icon.png"] forState:UIControlStateNormal];
    [descriptionBox addSubview:phoneButton];
    TT_RELEASE_SAFELY(phoneButton);
    
    UIButton *mapButton = [[UIButton alloc] initWithFrame:CGRectMake(40, 5, 30, 30)];
    [mapButton setImage:[UIImage imageNamed:@"map-icon.png"] forState:UIControlStateNormal];
    [descriptionBox addSubview:mapButton];
    TT_RELEASE_SAFELY(mapButton);
    
    UIButton *directionButton = [[UIButton alloc] initWithFrame:CGRectMake(75, 5, 30, 30)];
    [directionButton setImage:[UIImage imageNamed:@"direction-icon.png"] forState:UIControlStateNormal];
    [descriptionBox addSubview:directionButton];
    TT_RELEASE_SAFELY(directionButton);
    
    UIButton *facebookButton = [[UIButton alloc] initWithFrame:CGRectMake(235, 5, 30, 30)];
    [facebookButton setImage:[UIImage imageNamed:@"facebook-icon.png"] forState:UIControlStateNormal];
    [descriptionBox addSubview:facebookButton];
    TT_RELEASE_SAFELY(facebookButton);
    
    UIButton *twitterButton = [[UIButton alloc] initWithFrame:CGRectMake(270, 5, 30, 30)];
    [twitterButton setImage:[UIImage imageNamed:@"twitter-icon.png"] forState:UIControlStateNormal];
    [descriptionBox addSubview:twitterButton];
    TT_RELEASE_SAFELY(twitterButton);
    
  }
  {
    // address
    UILabel *address = [[UILabel alloc] initWithFrame:CGRectMake(5, 40, 300, 20)];
    address.font = [UIFont systemFontOfSize:14];
    address.text = @"#03-02, Wisma Atria, Orchard Road, (S)303909";
    [descriptionBox addSubview:address];
    TT_RELEASE_SAFELY(address);
  }
  {
    UIButton *branchesButton = [[UIButton alloc] initWithFrame:CGRectMake(5, 65, 75, 20)];
    [branchesButton setImage:[UIImage imageNamed:@"branches-icon.png"] forState:UIControlStateNormal];
    [descriptionBox addSubview:branchesButton];
    TT_RELEASE_SAFELY(branchesButton);
  }
  {
    UILabel *descTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 90, 310, 25)];
    descTitle.backgroundColor = [UIColor colorWithRed:0.75 green:0.75 blue:0.75 alpha:1];
    descTitle.text = @" Description";
    [descriptionBox addSubview:descTitle];
    TT_RELEASE_SAFELY(descTitle);
    
    /*
    UITextView *descView = [[UITextView alloc] initWithFrame:CGRectMake(5, 120, 300, 45)];
    descView.text = @"Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do\
    eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud\
    exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.";
    descView.editable = NO;
    descView.font = [UIFont systemFontOfSize:14];
    descView.textColor = [UIColor grayColor];
    [descriptionBox addSubview:descView];
    TT_RELEASE_SAFELY(descView);
    */
    
    NSString *descText = @"Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do\
    eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud\
    exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.";
    TTStyledTextLabel *descView = [[TTStyledTextLabel alloc] initWithFrame:CGRectMake(0, 115, 310, 45)];
    descView.font = [UIFont systemFontOfSize:14];
    descView.text = [TTStyledText textFromXHTML:descText lineBreaks:YES URLs:YES];
    descView.contentInset = UIEdgeInsetsMake(10, 10, 10, 10);
    [descView sizeToFit];
    [descriptionBox addSubview:descView];
    TT_RELEASE_SAFELY(descView); 
  }
  
  [descriptionBox setContentSize:CGSizeMake(310, 300)];
  [self.view addSubview:descriptionBox];
}

@end
