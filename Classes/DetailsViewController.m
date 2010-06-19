//
//  DetailsViewController.m
//  SingtelDining
//
//  Created by Alex Yao on 6/18/10.
//  Copyright 2010 CellCity. All rights reserved.
//

#import "DetailsViewController.h"


@implementation DetailsViewController

- (IBAction)selectCard:(id)sender {
  UIButton *theButton = (UIButton *)sender;
  theButton.selected = YES;
  NSLog(@"button %i clicked", [theButton tag]);
}

- (void)loadView {
  [super loadView];
  self.view.backgroundColor = [UIColor clearColor];
  self.navigationController.navigationBar.backgroundColor = [UIColor clearColor];
  
  UIScrollView *restaurantBox = [[UIScrollView alloc] initWithFrame:CGRectMake(5, 0, 310, 140)];
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
    
    // rate 
    
    // photo
    UIImageView *photoView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 40, 90, 70)];
    photoView.image = [UIImage imageNamed:@"rastauran-photo.png"];
    [restaurantBox addSubview:photoView];
    TT_RELEASE_SAFELY(photoView);
    
    // info
    NSString *infoText = @"<div class=\"offer\">Citibank Offer:</div><div class=\"highlight\">1 for 1 Lunch promo</div><div class=\"grey\">Valid till 30 jun 2010</div>";
    TTStyledTextLabel *restaurantInfo = [[TTStyledTextLabel alloc] initWithFrame:CGRectMake(125, 40, 185, 60)];
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
  
  UIScrollView *cardBox = [[UIScrollView alloc] initWithFrame:CGRectMake(5, 145, 310, 45)];
  cardBox.backgroundColor = [UIColor whiteColor];
  cardBox.layer.cornerRadius = 6;
  cardBox.layer.masksToBounds = YES;
  cardBox.scrollEnabled = YES;
  {
    UIImage *buttonImage = [UIImage imageNamed:@"uob-card.png"];
    for (int i=0; i<10; i++) {
      UIButton *cardButton = [[UIButton alloc] init];
      [cardButton setImage:buttonImage forState:UIControlStateNormal];
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
  
  UIScrollView *descriptionBox = [[UIScrollView alloc] initWithFrame:CGRectMake(5, 195, 310, 165)];
  descriptionBox.backgroundColor = [UIColor whiteColor];
  descriptionBox.layer.cornerRadius = 6;
  descriptionBox.layer.masksToBounds = YES;
  descriptionBox.scrollEnabled = YES;
  [self.view addSubview:descriptionBox];
}

@end
