//
//  CustomTableCell.m
//  SingtelDining
//
//  Created by Charisse Marie Napeñas on 21/06/10.
//  Copyright 2010 Cellcity Pte Ltd. All rights reserved.
//

#import "CustomTableCell.h"
#import "CustomTableItem.h"



@implementation CustomTableCell
@synthesize ratingView;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString*)identifier {
   if (self = [super initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:identifier]) {
      self.textLabel.font = TTSTYLEVAR(tableSmallFont);
      self.textLabel.textColor = TTSTYLEVAR(textColor);
      self.textLabel.highlightedTextColor = TTSTYLEVAR(highlightedTextColor);
      self.textLabel.textAlignment = UITextAlignmentLeft;
      self.textLabel.lineBreakMode = UILineBreakModeTailTruncation;
      self.textLabel.adjustsFontSizeToFitWidth = YES;
      
      self.detailTextLabel.font = TTSTYLEVAR(font);
      self.detailTextLabel.textColor = TTSTYLEVAR(tableSubTextColor);
      self.detailTextLabel.highlightedTextColor = TTSTYLEVAR(highlightedTextColor);
      self.detailTextLabel.textAlignment = UITextAlignmentLeft;
      self.detailTextLabel.contentMode = UIViewContentModeTop;
      self.detailTextLabel.lineBreakMode = UILineBreakModeTailTruncation;
      self.detailTextLabel.numberOfLines = kTableMessageTextLineCount;
   }
   
   return self;
}

#pragma mark -
#pragma mark TTTableViewCell class public


///////////////////////////////////////////////////////////////////////////////////////////////////
+ (CGFloat)tableView:(UITableView*)tableView rowHeightForObject:(id)object {
   
   
   return 100;
}


#pragma mark -
#pragma mark UIView



- (void)layoutSubviews {
   [super layoutSubviews];
   
   self.ratingView = [[[RatingView alloc] init] autorelease];
   [self.ratingView setImagesDeselected:@"s0.png" partlySelected:@"s1.png" fullSelected:@"s2.png" andDelegate:nil];
   [self.ratingView setFrame:CGRectMake(50, 15, 70, 20)];
   [self.ratingView displayRating:3.0];
   [self.contentView addSubview:ratingView];
}



#pragma mark -
#pragma mark TTTableViewCell


- (void)setObject:(id)object {
   if (_item != object) {
      [super setObject:object];
      
      CustomTableItem* item = object;
      
      if (item.text.length) {
         self.textLabel.text = item.text;
      }
      if (item.subtitle.length) {
         self.detailTextLabel.text = item.subtitle;
      }
      if (item.defaultImage) {
         self.imageView2.defaultImage = item.defaultImage;
      }
      if (item.imageURL) {
         self.imageView2.urlPath = item.imageURL;
      }
      
      

      
   }
}



@end
