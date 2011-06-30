//
//  DetailsViewController.m
//  SingtelDining
//
//  Created by Alex Yao on 6/18/10.
//  Copyright 2010 CellCity. All rights reserved.
//

#import "DetailsViewController.h"
#import "DetailsModel.h"
#import "DetailsObject.h"
#import "DirectionsController.h"
#import "AppDelegate.h"
#import "ListObject.h"
#import <extThree20JSON/extThree20JSON.h>
#import "CardOfferDataSource.h"
#import "MBProgressHUD.h"
#import <MessageUI/MFMailComposeViewController.h>
#import	"CCFBStreamDialog.h"
#import "WebViewController.h"

// Flurry analytics
#import "FlurryAPI.h"

#import "SHK.h"
#import "SHKFacebook.h"

static NSString *k_FB_API_KEY = @"8a710cdf7a8f707fe3c4043428c00619";
static NSString *k_FB_API_SECRECT = @"f687d73dbc545562fbf8d3ee893a28c4";
static NSString *k_CITIBANK_IMAGE = @"bundle://citibank-restaurant-image.png";
static NSString *k_AMEX_IMAGE = @"bundle://AMEXSelects-image.png";
static NSString *k_FAR_Raffles_IMAGE = @"bundle://FAR_Raffles.png";
static NSString *k_10TIME_IMAGE = @"bundle://10TimesPlatinum.png";


@implementation DetailsViewController

- (id)initWithRestaurantId:(int)RestaurantId {
  if (self = [super init]) {
    self.model = [[[DetailsModel alloc] initWithRestarantsId:RestaurantId] autorelease];
    
    isFavorite = NO;
  }
  return self;
}

- (void)dealloc {
  TT_RELEASE_SAFELY(restaurantInfo);
  TT_RELEASE_SAFELY(restaurantBox);
  TT_RELEASE_SAFELY(photoView);
  TT_RELEASE_SAFELY(ratingView);
  TT_RELEASE_SAFELY(reviewCount);
  TT_RELEASE_SAFELY(hud);
  [super dealloc];
}

- (IBAction)ratingIt:(id)sender {
  RatingView *rv = [[RatingView alloc] init];
  rv.backgroundColor = [UIColor clearColor];
  [rv setImagesDeselected:@"0.png" partlySelected:@"1.png" fullSelected:@"2.png" andDelegate:self];
  [rv displayRating:rating];
  
  UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Rate Outlet" message:@"\n\n\n" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
  [alert addButtonWithTitle:@"Submit"];
  [alert addSubview:rv];
  //[rv setFrame:CGRectMake(50, 50, 200, 30)];
  [rv setCenter:CGPointMake(140, 80)];
  [rv release];
  [alert show];
  [alert release];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
  if (buttonIndex == 1) {
    
    NSString *url = [NSString stringWithFormat: [URL_POST_RATING stringByAppendingFormat:@"?id=%i&rating=%f",details.rid, rating]];
    TTURLRequest *request = [TTURLRequest requestWithURL:url delegate:self];
    request.cachePolicy = TTURLRequestCachePolicyNoCache;
    request.response = [[[TTURLJSONResponse alloc] init] autorelease];
    [request send];
    NSLog(@"request: %@", request);
  }
}
///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)requestDidFinishLoad:(TTURLRequest*)request {
  TTURLJSONResponse* response = request.response;
  TTDASSERT([response.rootObject isKindOfClass:[NSDictionary class]]);
  NSDictionary* feed = response.rootObject;
  NSDictionary* data = [feed objectForKey:@"data"];
  
  rating = [[data objectForKey:@"rating"] floatValue];
  
  [ratingView displayRating:rating];
  reviewCount.text = [NSString stringWithFormat:@"Reviews: %@", [data objectForKey:@"totalreview"]];
  
  // totalreview
}

///////////////////////////////////////////////////////////////////////////////////////////////////
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

- (IBAction)addToFavorite:(id)sender {
  
  UIButton *theButton = (UIButton *)sender;
  
  NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
  NSMutableArray *favorite = [NSMutableArray arrayWithArray:[defaults objectForKey:@"favorite"]];
  NSMutableArray *savedIDs = [NSMutableArray arrayWithArray:[defaults objectForKey:@"favoriteSavedIDs"]];
  
  UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"" message:@"" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
  
  if (isFavorite) {
    // remove
    [savedIDs removeObject:[NSNumber numberWithInt:details.rid]];
    for (NSDictionary *item in favorite) {
      if ([[item objectForKey:@"uid"] intValue] == details.rid) {
        [favorite removeObject:item];
        
        NSLog(@"removed %i", details.rid);
        break;
      }
    }
    isFavorite = NO;
    [theButton setImage:[UIImage imageNamed:@"button-favourites-add.png"] forState:UIControlStateNormal];
    [alert setMessage:@"Successfully removed from favourites."];
  } else {
    
    NSLog(@"add %i", details.rid);
    NSMutableDictionary *item = [[NSMutableDictionary alloc] init];
    [item setObject:[NSNumber numberWithInt:details.rid] forKey:@"uid"];
    [item setObject:details.title forKey:@"title"];
    [item setObject:details.address forKey:@"address"];
    [item setObject:details.thumb forKey:@"image"];
    [savedIDs addObject:[item objectForKey:@"uid"]];
    [favorite addObject:item];
    
    TT_RELEASE_SAFELY(item);
    isFavorite = YES;
    [theButton setImage:[UIImage imageNamed:@"button-favourites-remove.png"] forState:UIControlStateNormal];
    [alert setMessage:@"Successfully saved to favourites."];
    
    
    // Flurry analytics
    NSMutableDictionary* analytics = [[NSMutableDictionary alloc] init];
    [analytics setObject:details.title forKey:@"MERCHANT_NAME"];
    [analytics setObject:[NSString stringWithFormat:@"%d", details.rid] forKey:@"MERCHANT_ID"];
    [FlurryAPI logEvent:@"EVENT_FAVORITE" withParameters:analytics];
    [analytics release];
  }
  [defaults setObject:favorite forKey:@"favorite"];
  [defaults setObject:savedIDs forKey:@"favoriteSavedIDs"];
  
  [alert show];
  [alert release];
}

- (void)updateInfoView:(NSString *)infoText {
	cardIndex = [infoText intValue];
	NSDictionary *offer = [details.offers objectAtIndex:[infoText intValue]];

	NSString *bankString = [offer objectForKey:@"bank"];
	
	// Flurry analytics
	NSMutableDictionary* analytics = [[NSMutableDictionary alloc] init];
	[analytics setObject:bankString forKey:@"BANK"];
	[FlurryAPI logEvent:@"BANK_OFFER" withParameters:analytics timed:YES];
	[analytics release];
	
	NSLog(@"bank offer: %@", bankString);
	
	NSString *offerFormat = @"<div class=\"offer\">%@ Offer:</div><div class=\"highlight\">%@</div>";
	NSString *offerString = @"";
	NSString *imageID = @"";
	

	offerString = [NSString stringWithFormat:offerFormat, bankString, [offer objectForKey:@"offer"]];
	tnc = [NSString stringWithString:[offer objectForKey:@"tnc"]];
	imageID = [NSString stringWithFormat:@"%@", [offer objectForKey:@"ImageID"]];
   
	isAmexBank = FALSE;
  
  if ([bankString isEqualToString:@"Citibank"]) {
    NSLog(@"update citibank image %@", bankString);
    [photoView unsetImage];
    photoView.urlPath = k_CITIBANK_IMAGE;
    [photoView reload];
    NSLog(@"urlPath: %@", photoView.urlPath);
  }else if ([bankString isEqualToString:@"AMEX"] ) {
	  if([imageID isEqualToString:@"1"]) {
		  [photoView unsetImage];
		  photoView.urlPath = k_FAR_Raffles_IMAGE;
		  [photoView reload];
	  } else if([imageID isEqualToString:@"2"]) {
		  [photoView unsetImage];
		  photoView.urlPath = k_10TIME_IMAGE;
		  [photoView reload];
	  } else {
		  [photoView unsetImage];
		  photoView.urlPath = k_AMEX_IMAGE;
		  [photoView reload];
	  }
	  isAmexBank = TRUE;
	  NSLog(@"urlPath: %@", photoView.urlPath);
  } else {
    NSLog(@"revert remote image %@", bankString);
    photoView.urlPath = details.img;
    NSLog(@"urlPath: %@", photoView.urlPath);
  }
  
  restaurantInfo.text = [TTStyledText textFromXHTML:offerString lineBreaks:YES URLs:YES];
  [restaurantBox setContentSize:CGSizeMake(200, 200 + restaurantInfo.frame.size.height - 75)];
  
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

- (IBAction)callButtonClick:(id)sender {
    TTOpenURL([NSString stringWithFormat:@"tel://%@", details.phone]);
}

- (IBAction)showTC:(id)sender {
	if(isAmexBank){
		WebViewController * controller = [[WebViewController alloc] initWithURL:tnc];
		[self.navigationController pushViewController:controller animated:YES];
		//[controller createWebViewWithHTML:@""];
		
		 
	}else{
		UIAlertView* tcView = [[UIAlertView alloc] initWithTitle:@"" message:tnc delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[tcView show];
		[tcView release];
	}
}

- (IBAction)showBranches:(id)sender {
  UIButton* theButton = sender;
  UIScrollView* dbox = (UIScrollView*)[self.view viewWithTag:200];
  UILabel* titleLabel = (UILabel*)[dbox viewWithTag:2001];
  TTStyledTextLabel* descLabel = (TTStyledTextLabel*)[dbox viewWithTag:2002];
  
  CGRect f = titleLabel.frame;
  if (f.origin.y == 125) {
    titleLabel.frame = CGRectMake(f.origin.x, f.origin.y+theButton.tag, f.size.width, f.size.height);
    f = descLabel.frame;
    descLabel.frame = CGRectMake(f.origin.x, f.origin.y+theButton.tag, f.size.width, f.size.height);
  }
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

-(void)mailComposeController:(MFMailComposeViewController *)mailer didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
	[self becomeFirstResponder];
	[self dismissModalViewControllerAnimated:YES];

}


-(IBAction)mailClicked:(id)sender{
	NSLog(@"Inside Mail Clicked ===");
	
	MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
	picker.mailComposeDelegate = self; 
	
	NSString *infoText1 = @"%@ %@ Dining Offers";
	
	NSString *subject = @"[ILoveDeals]";
	NSDictionary *offer = [details.offers objectAtIndex:cardIndex];
	
	subject= [NSString stringWithFormat:infoText1,subject, [offer objectForKey:@"bank"]];
	
	[picker setSubject:subject];
	/*NSArray *toRecipients = [NSArray arrayWithObject:@""]; 
	
	[picker setToRecipients:NULL]; */

	
	
	// Fill out the email body text
	NSString *emailBody =details.title;
	
	NSString *infoText = @"<div class=\"offer\">%@ Offer:</div><div class=\"highlight\">%@</div>";
   
	NSLog(@"%@ %@" , [offer objectForKey:@"bank"], [offer objectForKey:@"offer"]);
	NSString *offerString = [NSString stringWithFormat:infoText, [offer objectForKey:@"bank"], [offer objectForKey:@"offer"]];
    emailBody = [NSString stringWithFormat:@"<b>%@</b> \n %@",emailBody,offerString];
	
	[picker setMessageBody:emailBody isHTML:YES]; 
	
	//picker.navigationBar.barStyle = UIBarStyleBlack; 
	
	[[self navigationController] presentModalViewController:picker animated:YES];
	
	[[picker navigationBar] setTintColor:[UIColor blackColor]];
	//	[[[[picker navigationBar] items] objectAtIndex:0] setTitle:@"Mail"];

	UIImage *image = [UIImage imageNamed: @"headlogo.jpg"];
	UIImageView * iv = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,320,42)];
	iv.image = image;
	iv.contentMode = UIViewContentModeCenter;
	[[[picker viewControllers] lastObject] navigationItem].titleView = iv;
	[[picker navigationBar] sendSubviewToBack:iv];
	[iv release];
	
	[picker release];
	
}

/////////////////////////////////////////////////////////////////////////////////////////////
// facebook
/*
- (IBAction)loginFacebook:(id)sender {
	
	// Flurry analytics
	NSMutableDictionary* analytics = [[NSMutableDictionary alloc] init];
	[analytics setObject:@"BAR" forKey:@"FOO"];
	[FlurryAPI logEvent:@"FACEBOOK_CLICK" withParameters:analytics timed:YES];
	[analytics release];
	
  if (_FBSession.isConnected) {
	  [self performSelector:@selector(dialogDidSucceed:) withObject:nil];
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
    CCFBStreamDialog* streamDialog = [[[CCFBStreamDialog alloc] init] autorelease];
    streamDialog.delegate = self;
	  
	  // Fill out the email body text
	  NSString *emailBody =details.title;
	  
	  NSDictionary *offer = [details.offers objectAtIndex:cardIndex];
	  NSLog(@"%@ %@" , [offer objectForKey:@"bank"], [offer objectForKey:@"offer"]);
	  NSString *offerString = [NSString stringWithFormat:@"%@ Offer:%@", [offer objectForKey:@"bank"], [offer objectForKey:@"offer"]];
	  emailBody = [NSString stringWithFormat:@"%@ \n\n%@",emailBody,offerString];
	  
	if(isAmexBank)  
		streamDialog.message = emailBody;
	else
		streamDialog.message = @"";
	

    streamDialog.userMessagePrompt = @"";
    streamDialog.attachment = @"{\"name\":\"ILoveDeals\", \"href\":\"http://www.singtel.com/ilovedeals\",\"description\":\"Search for 'ILoveDeals' on Apple appstore , Blackberry AppWorld , Android Market or Nokia Store \",\"media\":[{\"type\":\"image\",\"src\":\"http://174.143.170.165/singtel/images/icon.png\", \"href\":\"http://www.singtel.com/ilovedeals\"}]}";
    // replace this with a friend's UID
    // dialog.targetId = @"999999";
    [streamDialog show];
  }
}
*/
/////////////////////////////////////////////////////////////////////////////////////////////

- (void)loadView {
  [super loadView];
  
  self.view.backgroundColor = [UIColor clearColor];
  self.navigationController.navigationBar.backgroundColor = [UIColor clearColor];
  self.tableView.frame = CGRectZero;
  
  // back button
  UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 65, 39)];
  [backButton setImage:[UIImage imageNamed:@"button-back.png"] forState:UIControlStateNormal];
  [backButton addTarget:self action:@selector(backButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
  UIBarButtonItem *barDoneButton = [[UIBarButtonItem alloc] initWithCustomView:backButton];
  [backButton release];
  self.navigationItem.leftBarButtonItem = barDoneButton;
  [barDoneButton release];
  
  hud = [[MBProgressHUD alloc] initWithView:self.view];
  [self.view addSubview:hud];
  hud.labelText = @"Loading Data...";
  [hud show:YES];
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  NSLog(@"details apppear");
  // hide tabbar;
  [self.tabBarController makeTabBarHidden:YES];
	cardIndex = 0;
	UIWebView* banner = (UIWebView*)[self.navigationController.view viewWithTag:9];
	banner.hidden = YES;
}

- (void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
	[self.tabBarController makeTabBarHidden:YES];
	
	UIWebView* banner = (UIWebView*)[self.navigationController.view viewWithTag:9];
	banner.hidden = YES;
}

- (void)didLoadModel:(BOOL)firstTime {
  [super didLoadModel:firstTime];
  
  [hud hide:YES];
  
  details = (DetailsObject*)((DetailsModel*)_model).data;
  
  // Flurry analytics
  NSMutableDictionary* analytics = [[NSMutableDictionary alloc] init];
  [analytics setObject:details.title forKey:@"MERCHANT_NAME"];
  [analytics setObject:[NSString stringWithFormat:@"%d", details.rid] forKey:@"MERCHANT_ID"];
  [FlurryAPI logEvent:@"VIEW_MERCHANT" withParameters:analytics];
  [analytics release];
  
  NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
  NSMutableArray *savedIDs = [defaults objectForKey:@"favoriteSavedIDs"];
  
  if (savedIDs == nil) {
    [defaults setObject:[NSMutableArray array] forKey:@"favoriteSavedIDs"];
    [defaults setObject:[NSMutableArray array] forKey:@"favorite"];
  }
  
  if ([savedIDs containsObject:[NSNumber numberWithInt:details.rid]]) {
    isFavorite = YES;
  }
  
  // favorite button
  UIButton *favoriteButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 42, 30)];
  if (isFavorite) {
    [favoriteButton setImage:[UIImage imageNamed:@"button-favourites-remove.png"] forState:UIControlStateNormal];
    [favoriteButton addTarget:self action:@selector(addToFavorite:) forControlEvents:UIControlEventTouchUpInside];
  } else {
    [favoriteButton setImage:[UIImage imageNamed:@"button-favourites-add.png"] forState:UIControlStateNormal];
    [favoriteButton addTarget:self action:@selector(addToFavorite:) forControlEvents:UIControlEventTouchUpInside];
  }
  UIBarButtonItem *barfavoriteButton = [[UIBarButtonItem alloc] initWithCustomView:favoriteButton];
  [favoriteButton release];
  self.navigationItem.rightBarButtonItem = barfavoriteButton;
  [barfavoriteButton release];
  
  restaurantBox = [[UIScrollView alloc] initWithFrame:CGRectMake(5, 0, 310, 120)];
  restaurantBox.tag = 201;
  restaurantBox.backgroundColor = [UIColor whiteColor];
  restaurantBox.layer.cornerRadius = 6;
  restaurantBox.layer.masksToBounds = YES;
  restaurantBox.scrollEnabled = YES;
  {
	  
	  CGFloat titlelableHeight = 20;  
	if (details.title.length > 20)
		titlelableHeight = 45;
	  
	  CGFloat boxHeight = 5;  
		
    // title
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, boxHeight, 220, titlelableHeight)];
    //titleLabel.backgroundColor = [UIColor grayColor];
    titleLabel.font = [UIFont boldSystemFontOfSize:17];
    titleLabel.textColor = [UIColor grayColor];
    [titleLabel setLineBreakMode:UILineBreakModeWordWrap];
    titleLabel.minimumFontSize = 10.0f;
    [titleLabel setAdjustsFontSizeToFitWidth:YES]; 
    [titleLabel setNumberOfLines:2]; 
    titleLabel.text = details.title; // @"Aans Korea Restaurant";
    [restaurantBox addSubview:titleLabel];
	boxHeight = boxHeight + titleLabel.frame.size.height;
    TT_RELEASE_SAFELY(titleLabel);
    
	  
    // cusine type
    UILabel *categoryLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, boxHeight, 220, 15)];
    categoryLabel.font = [UIFont italicSystemFontOfSize:12];
    categoryLabel.textColor = [UIColor grayColor];
    categoryLabel.text = details.type; // @"Korean";
    [restaurantBox addSubview:categoryLabel];
    boxHeight = boxHeight + categoryLabel.frame.size.height;
    TT_RELEASE_SAFELY(categoryLabel);
   
	  
    // rating
    CGRect ratingFrame = CGRectMake(225, 10, 70, 20);
    ratingView = [[RatingView alloc] init];
    [ratingView setImagesDeselected:@"s0.png" partlySelected:@"s1.png" fullSelected:@"s2.png" andDelegate:nil];
    [ratingView displayRating:details.rating];
    [ratingView setFrame:ratingFrame];
    [restaurantBox addSubview:ratingView];
    
    UIButton *ratingButton = [[UIButton alloc] initWithFrame:CGRectMake(210, 5, 90, 40)];
    [ratingButton addTarget:self action:@selector(ratingIt:) forControlEvents:UIControlEventTouchUpInside];
    [restaurantBox addSubview:ratingButton];
    TT_RELEASE_SAFELY(ratingButton);
    
    reviewCount = [[UILabel alloc] initWithFrame:CGRectMake(225, 25, 70, 15)];
    reviewCount.text = [NSString stringWithFormat:@"Reviews: %i", details.review];
    reviewCount.textColor = [UIColor redColor];
    reviewCount.font = [UIFont systemFontOfSize:12];
    reviewCount.textAlignment = UITextAlignmentCenter;
      reviewCount.backgroundColor = [UIColor clearColor];
    [restaurantBox addSubview:reviewCount];
    //TT_RELEASE_SAFELY(reviewCount);
    
    
    // photo
    photoView = [[TTImageView alloc] initWithFrame:CGRectMake(10, boxHeight, 100, 75)];
    photoView.autoresizesToImage = YES;
    photoView.urlPath = details.img;
    [restaurantBox addSubview:photoView];
    
    // info
    NSString *infoText = @"<div class=\"offer\">%@ Offer:</div><div class=\"highlight\">%@</div>";
    NSDictionary *offer = [details.offers objectAtIndex:0];
    tnc = [[NSString alloc] initWithString:[offer objectForKey:@"tnc"]];
    NSString *offerString = [NSString stringWithFormat:infoText, [offer objectForKey:@"bank"], [offer objectForKey:@"offer"]];
    restaurantInfo = [[TTStyledTextLabel alloc] initWithFrame:CGRectMake(115, boxHeight, 185, 60)];
    restaurantInfo.font = [UIFont systemFontOfSize:14];
    restaurantInfo.text = [TTStyledText textFromXHTML:offerString lineBreaks:YES URLs:YES];
    [restaurantInfo sizeToFit];
    [restaurantBox addSubview:restaurantInfo];
    
    // t&c
    UIButton* tcButton = [UIButton buttonWithType:UIButtonTypeInfoDark];
    [tcButton setFrame:CGRectMake(280, boxHeight, 20, 20)];
    [tcButton addTarget:self action:@selector(showTC:) forControlEvents:UIControlEventTouchUpInside];
    [restaurantBox addSubview:tcButton];
  }
  
  [restaurantBox setContentSize:CGSizeMake(280, 200)];
  [self.view addSubview:restaurantBox];
  
  {
    UIView *cardTableBg = [[UIView alloc] initWithFrame:CGRectMake(5, 125, 310, 75)];
    cardTableBg.layer.cornerRadius = 6;
    cardTableBg.layer.masksToBounds = YES;
    cardTableBg.backgroundColor = [UIColor whiteColor];
    {
      UIImageView *leftArrow = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 15, 75)];
      leftArrow.image = [UIImage imageNamed:@"scroll_left1.png"];
      leftArrow.autoresizingMask = NO;
      [cardTableBg addSubview:leftArrow];
      TT_RELEASE_SAFELY(leftArrow);
      
      UIImageView *rightArrow = [[UIImageView alloc] initWithFrame:CGRectMake(295, 0, 15, 75)];
      rightArrow.image = [UIImage imageNamed:@"scroll_right1.png"];
      rightArrow.autoresizingMask = NO;
      [cardTableBg addSubview:rightArrow];
      TT_RELEASE_SAFELY(rightArrow);
      
      [self.view addSubview:cardTableBg];
      TT_RELEASE_SAFELY(cardTableBg);
    }
    
    cardTable = [[HTableView alloc] initWithFrame:CGRectMake(20, 133, 280, 60) style:UITableViewStylePlain];
    cardTable.dataSource = [[CardOfferDataSource alloc] initWithOffers:details.offers];
    cardTable.rowHeight = 95;
    cardTable.delegate = [[TTTableViewPlainDelegate alloc] initWithController:self];
    cardTable.tag = 22;
    [self.view addSubview:cardTable];
    
    NSIndexPath* indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    HTableItem* item = [cardTable.dataSource tableView:(UITableView *)cardTable objectForRowAtIndexPath:(NSIndexPath*)indexPath];
    [self updateInfoView:item.userInfo];
  }
  
  
  UIScrollView *descriptionBox = [[UIScrollView alloc] initWithFrame:CGRectMake(5, 175 + 30, 310, 205)];
  descriptionBox.backgroundColor = [UIColor whiteColor];
  descriptionBox.layer.cornerRadius = 6;
  descriptionBox.layer.masksToBounds = YES;
  descriptionBox.scrollEnabled = YES;
  descriptionBox.tag = 200;
  
	CGFloat heightVal = 3;
	
  {
    // address
    UILabel *address = [[UILabel alloc] initWithFrame:CGRectMake(5, heightVal, 300, 35)];
    address.font = [UIFont systemFontOfSize:14];
	NSString *add = details.address;
	add = [add stringByReplacingOccurrencesOfString:@"\n" withString:@" "];
	address.text = add; //@"#03-02, Wisma Atria, Orchard Road, (S)303909";
    [address setAdjustsFontSizeToFitWidth:YES];
	[address setLineBreakMode:UILineBreakModeWordWrap];
	[address setNumberOfLines:2]; 
	  
    [address setMinimumFontSize:12];
    [descriptionBox addSubview:address];
	heightVal = heightVal + address.frame.size.height + 2.0;
    TT_RELEASE_SAFELY(address);
	  
	  
	 
    
    UILabel *telphone = [[UILabel alloc] initWithFrame:CGRectMake(5, heightVal, 300, 20)];
	  
    telphone.font = [UIFont systemFontOfSize:14];
    telphone.text = details.phone; //@"#03-02, Wisma Atria, Orchard Road, (S)303909";
    [descriptionBox addSubview:telphone];
    TT_RELEASE_SAFELY(telphone);
	  
	  heightVal += 20;
  }
  {
    // icon buttons
    UIButton *phoneButton = [[UIButton alloc] initWithFrame:CGRectMake(5, heightVal, 65, 65)];
    [phoneButton setImage:[UIImage imageNamed:@"phone-icon2.png"] forState:UIControlStateNormal];
    [phoneButton addTarget:self action:@selector(callButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [descriptionBox addSubview:phoneButton];
    TT_RELEASE_SAFELY(phoneButton);
    
    UIButton *mapButton = [[UIButton alloc] initWithFrame:CGRectMake(75, heightVal, 65, 65)];
    [mapButton setImage:[UIImage imageNamed:@"map-icon2.png"] forState:UIControlStateNormal];
    [mapButton addTarget:self action:@selector(mapButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [descriptionBox addSubview:mapButton];
    TT_RELEASE_SAFELY(mapButton);
        
    //_FBSession = [[FBSession sessionForApplication:k_FB_API_KEY secret:k_FB_API_SECRECT delegate:self] retain];
    
    UIButton *facebookButton = [[UIButton alloc] initWithFrame:CGRectMake(145, heightVal, 65, 65)];
    [facebookButton setImage:[UIImage imageNamed:@"facebook-icon2.png"] forState:UIControlStateNormal];
    [facebookButton addTarget:self action:@selector(shareFacebook:) forControlEvents:UIControlEventTouchUpInside];
    [descriptionBox addSubview:facebookButton];
    TT_RELEASE_SAFELY(facebookButton);
	  
	UIButton *emailButton = [[UIButton alloc] initWithFrame:CGRectMake(215, heightVal, 65, 65)];
	[emailButton setImage:[UIImage imageNamed:@"email_btn.png"] forState:UIControlStateNormal];
	[emailButton addTarget:self action:@selector(mailClicked:) forControlEvents:UIControlEventTouchUpInside];
	[descriptionBox addSubview:emailButton];
	TT_RELEASE_SAFELY(emailButton);  
  }
  {
    if ([details.branches count]) {
      UIButton *branchesButton = [[UIButton alloc] initWithFrame:CGRectMake(5, 105, 75, 20)];
      [branchesButton setImage:[UIImage imageNamed:@"branches-icon.png"] forState:UIControlStateNormal];
      [branchesButton addTarget:self action:@selector(showBranches:) forControlEvents:UIControlEventTouchUpInside];

      NSUInteger i, count = [details.branches count];
      for (i = 0; i < count; i++) {
        NSString* branch = [details.branches objectAtIndex:i];
        
        UILabel *address = [[UILabel alloc] initWithFrame:CGRectMake(5, 125+20*i, 300, 20)];
        address.font = [UIFont systemFontOfSize:14];
        address.text = branch; //@"#03-02, Wisma Atria, Orchard Road, (S)303909";
        address.tag = i;
        [address setAdjustsFontSizeToFitWidth:YES];
        [address setMinimumFontSize:10];
        [descriptionBox addSubview:address];
        TT_RELEASE_SAFELY(address);
      }
      branchesButton.tag = 20*i+20;
      [descriptionBox addSubview:branchesButton];
      TT_RELEASE_SAFELY(branchesButton);
    }
  }
  {
    UILabel *descTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 128, 310, 25)];
    descTitle.backgroundColor = [UIColor colorWithRed:0.75 green:0.75 blue:0.75 alpha:1];
    descTitle.text = @" Description";
    descTitle.tag = 2001;
    [descriptionBox addSubview:descTitle];
    TT_RELEASE_SAFELY(descTitle);
        
    NSString *descText = details.descriptionString; //@"Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do\
    eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud\
    exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.";
	  NSLog(@"desc :%@",descText);
    TTStyledTextLabel *descView = [[TTStyledTextLabel alloc] initWithFrame:CGRectMake(0, 150, 310, 45)];
    descView.font = [UIFont systemFontOfSize:14];
    descView.text = [TTStyledText textFromXHTML:descText lineBreaks:YES URLs:YES];
    descView.contentInset = UIEdgeInsetsMake(10, 10, 10, 10);
    descView.tag = 2002;
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

#pragma mark -
#pragma mark TTTableViewController
- (void)didSelectObject:(id)object atIndexPath:(NSIndexPath *)indexPath {
  if ([object isKindOfClass:[HTableItem class]]) {
    HTableItem *item = (HTableItem *)object;
    //item.selected = !item.selected;
    [cardTable reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationNone];
    [cardTable selectRowAtIndexPath:indexPath];
    [self updateInfoView:item.userInfo];
  } else {
    [super didSelectObject:object atIndexPath:indexPath];
  }
}

- (void)touchesEnded: (NSSet *)touches withEvent: (UIEvent *)event {
  for (UIView* view in self.view.subviews) {
    if ([view isKindOfClass:[UITextField class]])
      [view resignFirstResponder];
  }
}

- (IBAction)shareFacebook:(id)sender
{
    // Create the item to share (in this example, a url)
    NSURL *url = [NSURL URLWithString:@"http://www.singtel.com/ilovedeals"];
    SHKItem *item = [SHKItem URL:url title:@"ILoveDeals"];
    
    NSDictionary *offer = [details.offers objectAtIndex:cardIndex];
    NSString *offerString = [offer objectForKey:@"offer"];
    NSMutableString* shareMessage = [NSMutableString stringWithFormat:@"Check out this great deal at %@", details.title];
    
    if (isAmexBank) {
        [shareMessage appendFormat:@"\n\nAMEX offer:\n\n%@", offerString];
    }
    [item setText:shareMessage];

    
    // Share the item
    [SHKFacebook shareItem:item];
}

@end
