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
@synthesize distancelbl;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString*)identifier {
   if (self = [super initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:identifier]) {
      _item = nil;
      
      self.textLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:15];
      self.textLabel.textColor = TTSTYLEVAR(textColor);
      self.textLabel.highlightedTextColor = TTSTYLEVAR(highlightedTextColor);
      self.textLabel.textAlignment = UITextAlignmentLeft;
      self.textLabel.lineBreakMode = UILineBreakModeTailTruncation;
      self.textLabel.adjustsFontSizeToFitWidth = YES;
      
      self.detailTextLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:11];
      self.detailTextLabel.textColor = TTSTYLEVAR(tableSubTextColor);
      self.detailTextLabel.highlightedTextColor = TTSTYLEVAR(highlightedTextColor);
      self.detailTextLabel.textAlignment = UITextAlignmentLeft;
      self.detailTextLabel.contentMode = UIViewContentModeTop;
      self.detailTextLabel.lineBreakMode = UILineBreakModeTailTruncation;
      self.detailTextLabel.numberOfLines = kTableMessageTextLineCount;
      
      distancelbl = [[[UILabel alloc] init] autorelease];
   }
   
   return self;
}


#pragma mark -
#pragma mark UIView



- (void)layoutSubviews {
   [super layoutSubviews];
   
   //NSLog(@"Laying out subviews\n");
   //self.ratingView = [[[RatingView alloc] init] autorelease];
//   [self.ratingView setImagesDeselected:@"s0.png" partlySelected:@"s1.png" fullSelected:@"s2.png" andDelegate:nil];
//   [self.ratingView setFrame:CGRectMake(220, 1, 70, 20)];
//   [self.ratingView displayRating:rating];
//   [self.contentView addSubview:ratingView];
   
   [distancelbl setFrame:CGRectMake(240, 1, 50, 20)];
   [distancelbl setBackgroundColor:[UIColor clearColor]];
   distancelbl.font = [UIFont fontWithName:@"Helvetica-Bold" size:11];
   distancelbl.text = distance;
   [self addSubview:distancelbl];

}



#pragma mark -
#pragma mark TTTableViewCell

+ (CGFloat)tableView:(UITableView*)tableView rowHeightForObject:(id)object {
   return 70;
}


- (void)setObject:(id)object {
   if (_item != object) {
      [super setObject:object];
  
      CustomTableItem* item = object;  
      distance = item.distance;

   }
}


- (id)object {
	return _item;
}




- (void) dealloc
{
   [distancelbl release];
   [super dealloc];
}


@end
