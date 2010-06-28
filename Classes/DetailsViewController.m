//
//  DetailsViewController.m
//  SingtelDining
//
//  Created by Alex Yao on 6/18/10.
//  Copyright 2010 CellCity. All rights reserved.
//

#import "DetailsViewController.h"
#import "FBConnect/FBConnect.h"
#import "DetailsModel.h"
#import "DetailsObject.h"
#import "DirectionsController.h"
#import "AppDelegate.h"

static NSString *k_FB_API_KEY = @"26d970c5b5bd69b1647c46b8d683da5a";
static NSString *k_FB_API_SECRECT = @"c9ee4fe5d0121eda4dec46d7b61762b3";


@implementation DetailsViewController

- (id)initWithRestaurantId:(int)RestaurantId {
  if (self = [super init]) {
    self.model = [[[DetailsModel alloc] initWithRestarantsId:RestaurantId] autorelease];
  }
  return self;
}

- (void)dealloc {
  TT_RELEASE_SAFELY(restaurantInfo);
  TT_RELEASE_SAFELY(ratingView);
  TT_RELEASE_SAFELY(_FBSession);
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

- (IBAction)backButtonClicked:(id)sender {
  [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)mapButtonClicked:(id)sender {
   //TTOpenURL(@"http://maps.google.com/maps");
	//[[TTNavigator navigator] openURLAction:[[TTURLAction actionWithURLPath:@"http://maps.google.com/maps"] applyAnimated:YES]];
	//[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://maps.google.com/maps"]];
	AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
	DirectionsController * direction = [[DirectionsController alloc] init];
	//[self.view addSubview:direction.view];
	[direction setToAddress:details.address];
	[direction setFromAddress: delegate.currentLocation];
	[direction setStrTitle:details.title];
	[direction setStrAddr:details.address];
	[direction setStrLat:[NSString stringWithFormat:@"%f",details.latitude]];
	[direction setStrLong:[NSString stringWithFormat:@"%f",details.longitude]];
	NSLog(@"Testing: %@\n",details.title);
	NSLog(@"Current Location %@\n", delegate.currentLocation);
	[self.navigationController pushViewController:direction animated:YES];
}

/////////////////////////////////////////////////////////////////////////////////////////////
// facebook
- (IBAction)loginFacebook:(id)sender {
  if (_FBSession.isConnected) {
    [_FBSession logout];
  } else {
    FBLoginDialog* dialog = [[[FBLoginDialog alloc] initWithSession:_FBSession] autorelease];
    [dialog show];
  }
}

- (void)session:(FBSession*)session didLogin:(FBUID)uid {
  NSLog(@"User with id %lld logged in.", uid);
  FBPermissionDialog* dialog = [[[FBPermissionDialog alloc] init] autorelease];
	dialog.delegate = self;
	dialog.permission = @"status_update";
	[dialog show];
}

- (void)dialogDidSucceed:(FBDialog*)dialog {
  if (![dialog isKindOfClass:[FBStreamDialog class]]) {
    NSLog(@"got permission");
    FBStreamDialog* streamDialog = [[[FBStreamDialog alloc] init] autorelease];
    streamDialog.delegate = self;
    streamDialog.userMessagePrompt = @"I like this ";
    streamDialog.attachment = @"{\"name\":\"Singtel Dining\",\"href\":\"http://www.cellcitycrop.com\",\"caption\":\"Singtel Dining\",\"description\":\"Singtel Dining Application on iPhone\",\"media\":[{\"type\":\"image\",\"src\":\"http://uob.dc2go.net/singtel/images/icon.png\",\"href\":\"http://www.cellcitycrop.com/\"}],\"properties\":{\"another link\":{\"text\":\"Singtel web site\",\"href\":\"http://www.Singtel.com\"}}}";
    // replace this with a friend's UID
    // dialog.targetId = @"999999";
    [streamDialog show];
  }
}

/////////////////////////////////////////////////////////////////////////////////////////////

- (void)loadView {
  [super loadView];
  
  self.view.backgroundColor = [UIColor clearColor];
  self.navigationController.navigationBar.backgroundColor = [UIColor clearColor];
  
  // back button
  UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 57, 30)];
  [backButton setImage:[UIImage imageNamed:@"button-list.png"] forState:UIControlStateNormal];
  [backButton addTarget:self action:@selector(backButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
  UIBarButtonItem *barDoneButton = [[UIBarButtonItem alloc] initWithCustomView:backButton];
  [backButton release];
  self.navigationItem.leftBarButtonItem = barDoneButton;
  [barDoneButton release];
  
  // favorite button
  UIButton *favoriteButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 42, 30)];
  [favoriteButton setImage:[UIImage imageNamed:@"button-favourites-add.png"] forState:UIControlStateNormal];
  //[favoriteButton addTarget:self action:@selector(backButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
  UIBarButtonItem *barfavoriteButton = [[UIBarButtonItem alloc] initWithCustomView:favoriteButton];
  [favoriteButton release];
  self.navigationItem.rightBarButtonItem = barfavoriteButton;
  [barfavoriteButton release];
  
  // hide tabbar;
  CGRect frame = self.tabBarController.view.frame;
  [self.tabBarController.view setFrame:CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, frame.size.height+50)];
  
}

- (void)didLoadModel:(BOOL)firstTime {
  
  details = (DetailsObject*)((DetailsModel*)_model).data;
  
  [super didLoadModel:firstTime];
  
  UIScrollView *restaurantBox = [[UIScrollView alloc] initWithFrame:CGRectMake(5, 0 + 20, 310, 120)];
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
    titleLabel.text = details.title; // @"Aans Korea Restaurant";
    [restaurantBox addSubview:titleLabel];
    TT_RELEASE_SAFELY(titleLabel);
    
    /*
    // category
    UILabel *categoryLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 25, 220, 15)];
    //categoryLabel.backgroundColor = [UIColor redColor];
    categoryLabel.font = [UIFont systemFontOfSize:14];
    categoryLabel.textColor = [UIColor blueColor];
    categoryLabel.text = @"Korean";
    [restaurantBox addSubview:categoryLabel];
    TT_RELEASE_SAFELY(categoryLabel);
    */
    
    // rating
    CGRect ratingFrame = CGRectMake(220, 10, 70, 20);
    ratingView = [[RatingView alloc] init];
    [ratingView setImagesDeselected:@"s0.png" partlySelected:@"s1.png" fullSelected:@"s2.png" andDelegate:nil];
    [ratingView displayRating:details.rating];
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
  
  UIScrollView *cardBox = [[UIScrollView alloc] initWithFrame:CGRectMake(5, 125 + 20, 310, 75)];
  cardBox.backgroundColor = [UIColor whiteColor];
  cardBox.layer.cornerRadius = 6;
  cardBox.layer.masksToBounds = YES;
  cardBox.scrollEnabled = YES;
  {
    UIImage *buttonImage = [UIImage imageNamed:@"Citibank Dividend Platinum Mastercard.jpg"];
    UIImage *buttonSelectImage = [UIImage imageNamed:@"Citibank Dividend Platinum Mastercard.jpg"];
    for (int i=0; i<10; i++) {
      UIButton *cardButton = [[UIButton alloc] init];
      [cardButton setImage:buttonImage forState:UIControlStateNormal];
      [cardButton setImage:buttonSelectImage forState:UIControlStateSelected];
      [cardButton addTarget:self action:@selector(selectCard:) forControlEvents:UIControlEventTouchUpInside];
      cardButton.frame = CGRectMake(95*i + 5, 7, 95, 60);
      cardButton.tag = i;
      [cardBox addSubview:cardButton];
      TT_RELEASE_SAFELY(cardButton);
    }
    [cardBox setContentInset:UIEdgeInsetsMake(0, 5, 0, 5)];
    [cardBox setContentSize:CGSizeMake(1000, 45)];
  }
  [self.view addSubview:cardBox];
  TT_RELEASE_SAFELY(cardBox);
  
  UIScrollView *descriptionBox = [[UIScrollView alloc] initWithFrame:CGRectMake(5, 175 + 20 + 30, 310, 205)];
  descriptionBox.backgroundColor = [UIColor whiteColor];
  descriptionBox.layer.cornerRadius = 6;
  descriptionBox.layer.masksToBounds = YES;
  descriptionBox.scrollEnabled = YES;
  
  {
    // address
    UILabel *address = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, 300, 20)];
    address.font = [UIFont systemFontOfSize:14];
    address.text = details.address; //@"#03-02, Wisma Atria, Orchard Road, (S)303909";
    [descriptionBox addSubview:address];
    TT_RELEASE_SAFELY(address);
  }
  {
    // icon buttons
    UIButton *phoneButton = [[UIButton alloc] initWithFrame:CGRectMake(5, 30, 65, 65)];
    [phoneButton setImage:[UIImage imageNamed:@"phone-icon2.png"] forState:UIControlStateNormal];
    [descriptionBox addSubview:phoneButton];
    TT_RELEASE_SAFELY(phoneButton);
    
    UIButton *mapButton = [[UIButton alloc] initWithFrame:CGRectMake(75, 30, 65, 65)];
    [mapButton setImage:[UIImage imageNamed:@"map-icon2.png"] forState:UIControlStateNormal];
    [mapButton addTarget:self action:@selector(mapButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [descriptionBox addSubview:mapButton];
    TT_RELEASE_SAFELY(mapButton);
    
    /*
    UIButton *directionButton = [[UIButton alloc] initWithFrame:CGRectMake(145, 30, 65, 65)];
    [directionButton setImage:[UIImage imageNamed:@"direction-icon2.png"] forState:UIControlStateNormal];
    [descriptionBox addSubview:directionButton];
    TT_RELEASE_SAFELY(directionButton);
    */
    
    _FBSession = [[FBSession sessionForApplication:k_FB_API_KEY secret:k_FB_API_SECRECT delegate:self] retain];
    
    UIButton *facebookButton = [[UIButton alloc] initWithFrame:CGRectMake(145, 30, 65, 65)];
    [facebookButton setImage:[UIImage imageNamed:@"facebook-icon2.png"] forState:UIControlStateNormal];
    [facebookButton addTarget:self action:@selector(loginFacebook:) forControlEvents:UIControlEventTouchUpInside];
    [descriptionBox addSubview:facebookButton];
    TT_RELEASE_SAFELY(facebookButton);
    
    UIButton *twitterButton = [[UIButton alloc] initWithFrame:CGRectMake(215, 30, 65, 65)];
    [twitterButton setImage:[UIImage imageNamed:@"twitter-icon2.png"] forState:UIControlStateNormal];
    [twitterButton addTarget:kAppTwitterURLPath action:@selector(openURLFromButton:) forControlEvents:UIControlEventTouchUpInside];
    [descriptionBox addSubview:twitterButton];
    TT_RELEASE_SAFELY(twitterButton);
    
  }
  {
    UIButton *branchesButton = [[UIButton alloc] initWithFrame:CGRectMake(5, 100, 75, 20)];
    [branchesButton setImage:[UIImage imageNamed:@"branches-icon.png"] forState:UIControlStateNormal];
    [descriptionBox addSubview:branchesButton];
    TT_RELEASE_SAFELY(branchesButton);
  }
  {
    UILabel *descTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 125, 310, 25)];
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
    
    NSString *descText = details.descriptionString; //@"Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do\
    eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud\
    exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.";
    TTStyledTextLabel *descView = [[TTStyledTextLabel alloc] initWithFrame:CGRectMake(0, 150, 310, 45)];
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

/////////////////////////////////////////////////////////////////////////////////////////////////// 
// TTStateAwareViewController 
- (NSString*)titleForLoading { 
  return @"Loading Data..."; 
}

- (NSString*)titleForEmpty { 
  return @"No data found."; 
}

- (NSString*)subtitleForError:(NSError*)error { 
  return @"Sorry, there was an error loading the Data"; 
}

@end
