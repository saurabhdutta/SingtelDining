//
//  CouponDetailsViewController.m
//  SingtelDining
//
//  Created by Alex Yao Cheng on 11/3/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "CouponDetailsViewController.h"

#import "SDBoxView.h"
#import "FlurryAPI.h"

#import "CouponObject.h"
#import "CouponDetailsModel.h"

#import "Three20UI/UIViewAdditions.h"
#import <extThree20JSON/extThree20JSON.h>


@implementation CouponDetailsViewController

- (void)dealloc {
  
  [boxView release];
  
  [super dealloc];
}

- (id)initWithNavigatorURL:(NSURL *)URL query:(NSDictionary *)query {
  
  id object = [query objectForKey:@"CouponModel"];
  if (object != nil && [object isKindOfClass:[CouponObject class]]) {
    CouponObject* theCoupon = object;
    self = [self initWithCoupon:theCoupon];
  }
  return self;
}

- (id)initWithCoupon:(CouponObject*)theCoupon {
  if (self = [super init]) {
    self.model = [[[CouponDetailsModel alloc] initWithCoupon:theCoupon] autorelease];
  }
  return self;
}

- (void)loadView {
  [super loadView];
  
  self.view.backgroundColor = [UIColor clearColor];
  self.navigationController.navigationBar.backgroundColor = [UIColor clearColor];
  
  UIButton* backButton = [UIButton buttonWithType:UIButtonTypeCustom];
  [backButton setImage:[UIImage imageNamed:@"button-back.png"] forState:UIControlStateNormal];
  [backButton setFrame:CGRectMake(0, 0, 65, 39)];
  [backButton addTarget:self action:@selector(backButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
  self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:backButton] autorelease];
    
  UILabel* titleView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 128, 19)];
  titleView.text = @"m-Coupon";
  titleView.backgroundColor = [UIColor clearColor];
  titleView.font = [UIFont boldSystemFontOfSize:18];
  titleView.textColor = RGBCOLOR(190, 0, 19);
  titleView.textAlignment = UITextAlignmentCenter;
  //UIImageView *titleView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 128, 19)];
  //titleView.image = [UIImage imageNamed:@"my-favorite.png"];
  boxView = [[SDBoxView alloc] initWithFrame:CGRectMake(5, 0, 310, kBoxNormalHeight) titleView:titleView];
  [titleView release];
  {
    
  }
  [self.view addSubview:boxView];
}

- (void)didLoadModel:(BOOL)firstTime {
  [super didLoadModel:firstTime];
  
  CouponObject* coupon = ((CouponDetailsModel*)self.model).coupon;
  if (firstTime) {
    
    CGFloat previousY;
    
    UILabel* offerShortLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 50, 280, 20)];
    [offerShortLabel setText:coupon.offerShort];
    [offerShortLabel setFont:[UIFont boldSystemFontOfSize:18]];
    //[offerShortLabel setTextAlignment:UITextAlignmentCenter];
    [boxView addSubview:offerShortLabel];
    TT_RELEASE_SAFELY(offerShortLabel);
    
    TTImageView* photoView = [[TTImageView alloc] initWithFrame:CGRectMake(15, 80, 100, 130)];
    photoView.autoresizesToImage = YES;
    [photoView setDefaultImage:[UIImage imageNamed:@"default_coupon.png"]];
    photoView.urlPath = coupon.photoUrl;
    [boxView addSubview:photoView];
    TT_RELEASE_SAFELY(photoView);
    
    UILabel* restaurantLabel = [[UILabel alloc] initWithFrame:CGRectMake(120, 80, 150, 20)];
    [restaurantLabel setText:coupon.restaurantName];
    [boxView addSubview:restaurantLabel];
    TT_RELEASE_SAFELY(restaurantLabel);
    
    TTStyledTextLabel* addressLabel = [[TTStyledTextLabel alloc] initWithFrame:CGRectMake(120, 110, 150, 20)];
    [addressLabel setHtml:coupon.address];
    [addressLabel sizeToFit];
    [boxView addSubview:addressLabel];
    previousY = addressLabel.bottom;
    TT_RELEASE_SAFELY(addressLabel);
    
    UIButton* callButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [callButton setImage:[UIImage imageNamed:@"calltobook_btn.png"] forState:UIControlStateNormal];
    [callButton setFrame:CGRectMake(120, previousY + 10, 65, 57)];
    [callButton addTarget:self action:@selector(callButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [boxView addSubview:callButton];
    
    UILabel* callLabel = [[UILabel alloc] initWithFrame:CGRectMake(callButton.right + 5, callButton.centerY - 10, 100, 20)];
    [callLabel setText:@"Call to book!"];
    [callLabel setFont:[UIFont boldSystemFontOfSize:16]];
    [boxView addSubview:callLabel];
    TT_RELEASE_SAFELY(callLabel);
    
    UILabel* tncLabel = [[UILabel alloc] initWithFrame:CGRectMake(120, callButton.bottom + 10, 150, 20)];
    [tncLabel setText:@"Terms & Conditions apply."];
    [tncLabel setFont:[UIFont systemFontOfSize:12]];
    [boxView addSubview:tncLabel];
    
    UIButton* tncButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [tncButton setImage:[UIImage imageNamed:@"info_btn.png"] forState:UIControlStateNormal];
    [tncButton setFrame:CGRectMake(0, 0, 30, 33)];
    [tncButton setCenter:CGPointMake(tncLabel.right + 10, tncLabel.centerY)];
    [tncButton addTarget:self action:@selector(tncButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [boxView addSubview:tncButton];
    TT_RELEASE_SAFELY(tncLabel);
    
    UIView* borderView = [[UIView alloc] initWithFrame:CGRectMake(5, 40, 300, tncButton.bottom - 40 + 10)];
    borderView.backgroundColor = [UIColor clearColor];
    borderView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    borderView.layer.borderWidth = 1;
    borderView.layer.cornerRadius = 8;
    [boxView addSubview:borderView];
    //[boxView insertSubview:borderView atIndex:0];
    [boxView sendSubviewToBack:borderView];
    previousY = borderView.bottom;
    TT_RELEASE_SAFELY(borderView);
    
    UILabel* redeemLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, previousY + 20, 120, 50)];
    [redeemLabel setText:@"Your Remaining\nRedemption"];
    [redeemLabel setFont:[UIFont boldSystemFontOfSize:15]];
    [redeemLabel setLineBreakMode:UILineBreakModeWordWrap];
    [redeemLabel setNumberOfLines:2];
    [redeemLabel setTextAlignment:UITextAlignmentRight];
    [boxView addSubview:redeemLabel];
    
    UILabel* redeemCount = [[UILabel alloc] initWithFrame:CGRectMake(redeemLabel.right, redeemLabel.top, 50, redeemLabel.height)];
    [redeemCount setText:[NSString stringWithFormat:@"%d", coupon.redemptionCount]];
    [redeemCount setFont:[UIFont boldSystemFontOfSize:48]];
    [redeemCount setTextAlignment:UITextAlignmentCenter];
    [redeemCount setTextColor:[UIColor grayColor]];
    [boxView addSubview:redeemCount];
    
    UIButton* redeemButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [redeemButton setImage:[UIImage imageNamed:@"redeem_btn.png"] forState:UIControlStateNormal];
    [redeemButton setFrame:CGRectMake(0, 0, 126, 72)];
    [redeemButton setCenter:CGPointMake(redeemCount.right + 126/2, redeemCount.centerY)];
    [redeemButton addTarget:self action:@selector(redeemButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [boxView addSubview:redeemButton];
    TT_RELEASE_SAFELY(redeemCount);
    TT_RELEASE_SAFELY(redeemLabel);
    
  }
}

- (IBAction)backButtonClicked:(id)sender {
  [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)callButtonClicked:(id)sender {
  CouponObject* coupon = ((CouponDetailsModel*)self.model).coupon;
  if (TTIsPhoneSupported()) {
    NSString* tel = [NSString stringWithFormat:@"tel://%@", coupon.officePhone];
    TTDPRINT(@"tel: %@", tel);
    TTOpenURL(tel);
  } else {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Phone call is not available on your device." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
    [alert release];
  }
}

- (IBAction)tncButtonClicked:(id)sender {
  CouponObject* coupon = ((CouponDetailsModel*)self.model).coupon;
  
  UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"" message:coupon.tnc delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil];
  [alert show];
  [alert release];
}

- (IBAction)redeemButtonClicked:(id)sender {
  UIAlertView* av = [[UIAlertView alloc] initWithTitle:@"ILoveDeals" 
                                               message:@"You are about to redeem this m-Coupon. Are you at the store now?" 
                                              delegate:self 
                                     cancelButtonTitle:@"NO" 
                                     otherButtonTitles:@"YES", nil];
  [av show];
  [av release];
}

- (void)redeemCouponWithDeviceID:(NSString*)deviceID andCouponID:(NSInteger)couponID {
  NSString* url = [URL_COUPON_REDEEM stringByAppendingFormat:@"?deviceID=%@&couponID=%d", deviceID, couponID];
  TTDPRINT(@"redeem url: %@", url);
  
  TTURLRequest* redeemRequest = [TTURLRequest requestWithURL:url delegate:self];
  redeemRequest.cachePolicy = TTURLRequestCachePolicyNoCache;
  redeemRequest.response = [[[TTURLJSONResponse alloc] init] autorelease];
  [redeemRequest send];
}

- (void)showRedeemResultWithSerialNumber:(NSString*)SN andDateTime:(NSString*)dateTime {
  UIView* resultView = [[UIView alloc] initWithFrame:CGRectMake(0, 480, 320, 320)];
  resultView.alpha = 0.5;
  
  UILabel* SNLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 200, 320, 30)];
  SNLabel.text = SN;
  SNLabel.font = [UIFont boldSystemFontOfSize:18];
  SNLabel.textAlignment = UITextAlignmentCenter;
  [resultView addSubview:SNLabel];
  [SNLabel release];
  
  UILabel* dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 240, 320, 70)];
  dateLabel.text = dateTime;
  dateLabel.numberOfLines = 0;
  dateLabel.lineBreakMode = UILineBreakModeWordWrap;
  [resultView addSubview:dateLabel];
  [dateLabel release];
  
  [UIView beginAnimations:@"redeem" context:nil];
  [UIView setAnimationDuration:0.5f];
  resultView.frame = CGRectOffset(resultView.frame, 0, -480);
  [UIView commitAnimations];
}

#pragma mark -
#pragma mark TTStateAwareViewController 
- (NSString*)titleForLoading { 
  return @"Loading Data..."; 
}


- (UIImage*)imageForEmpty 
{ 
  return nil; 
} 

- (NSString*)titleForEmpty { 
  return @"No data found."; 
}

- (NSString*)subtitleForEmpty 
{ 
  return nil; 
} 

- (UIImage*)imageForError:(NSError*)error 
{ 
  return nil; 
} 

- (NSString*)titleForError:(NSError*)error 
{ 
  return nil; 
} 

- (NSString*)subtitleForError:(NSError*)error { 
  return @"Sorry, there was an error loading the Data"; 
}

#pragma mark -
#pragma mark UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
  if (buttonIndex == 1) {
    NSString* deviceID = [UIDevice currentDevice].uniqueIdentifier;
    CouponObject* coupon = ((CouponDetailsModel*)self.model).coupon;
    
    [self redeemCouponWithDeviceID:deviceID andCouponID:coupon.couponID];
  }
}

#pragma mark -
#pragma mark redeemRequest 
- (void)requestDidFinishLoad:(TTURLRequest*)redeemRequest {
  NSLog(@"redeemRequest requestDidFinishLoad");
  
  TTURLJSONResponse* response = redeemRequest.response;
  TTDASSERT([response.rootObject isKindOfClass:[NSDictionary class]]);
  
  id root = response.rootObject;
  
  NSString* rootString = root;
  TTDPRINT(@"invalid JSON.rootObject: %@", rootString);
  
  if (root && [root isKindOfClass:[NSDictionary class]]) {
    NSDictionary* feed = root;
    //NSLog(@"feed: %@",feed);
    TTDASSERT([[feed objectForKey:@"serialNumber"] isKindOfClass:[NSString class]]);
    TTDASSERT([[feed objectForKey:@"dateTime"] isKindOfClass:[NSString class]]);
    
    NSString* serialNumber = [feed objectForKey:@"serialNumber"];
    NSString* dateTime = [feed objectForKey:@"dateTime"];
    
    if (TTIsStringWithAnyText(serialNumber) && TTIsStringWithAnyText(dateTime)) {
      [self showRedeemResultWithSerialNumber:serialNumber andDateTime:dateTime];
    }
  } else {
    NSString* rootString = root;
    TTDPRINT(@"invalid JSON.rootObject: %@", rootString);
  }

}

@end
