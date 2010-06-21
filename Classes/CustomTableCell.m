//
//  CustomTableCell.m
//  SingtelDining
//
//  Created by System Administrator on 21/06/10.
//  Copyright 2010 Cellcity Pte Ltd. All rights reserved.
//

#import "CustomTableCell.h"
#import "CustomTableItem.h"
#import "CellCustomStyleSheet1.h"


static CGFloat kHPadding = 10;
static CGFloat kVPadding = 15;
static CGFloat kImageWidth = 40;
static CGFloat kImageHeight = 40;


@implementation CustomTableCell

+ (CGFloat)tableView:(UITableView*)tableView rowHeightForItem:(id)item {
	CustomTableItem* captionedItem = item;
	
	//CGFloat maxWidth = tableView.width - kHPadding*2;
	
	CGSize textSize = [captionedItem.text sizeWithFont:TTSTYLEVAR(myHeadingFont)
                      constrainedToSize:CGSizeMake(211, CGFLOAT_MAX)
                      lineBreakMode:UILineBreakModeWordWrap];
	CGSize subtextSize = [captionedItem.caption sizeWithFont:TTSTYLEVAR(mySubtextFont)
                         constrainedToSize:CGSizeMake(211, CGFLOAT_MAX) lineBreakMode:UILineBreakModeWordWrap];
	
	return 100/*kVPadding*2 + textSize.height + subtextSize.height + kImageHeight + kVPadding*/;
}


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString*)identifier {
	if (self = [super initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:identifier]) {
		_item = nil;
		
		_imageView1 = [[TTImageView alloc] initWithFrame:CGRectZero];
		[self.contentView addSubview:_imageView1];
      
		_imageView2 = [[TTImageView alloc] initWithFrame:CGRectZero];
		[self.contentView addSubview:_imageView2];
      
      
		
	}
	return self;
}

- (void)dealloc {
	TT_RELEASE_SAFELY(_imageView1);
	TT_RELEASE_SAFELY(_imageView2);
	[super dealloc];
}

// UIView

- (void)layoutSubviews {
	[super layoutSubviews];
   
	[self.detailTextLabel sizeToFit];
	//self.detailTextLabel.hei = kVPadding;
	
	//[self.textLabel setShadowColor:<#(UIColor *)#>] = self.detailTextLabel.size;
	
	_imageView1.frame = CGRectMake(0, 0, kImageWidth, kImageHeight);
	_imageView2.frame = CGRectMake(80, 0, kImageWidth, kImageHeight);
   
	
}

// TTTableViewCell

- (id)object {
	return _item;
}

- (void)setObject:(id)object {
	if (_item != object) {
		[super setObject:object];
		
		CustomTableItem* item = object;
		
		
		self.textLabel.textColor = TTSTYLEVAR(myHeadingColor);
		self.textLabel.font = TTSTYLEVAR(myHeadingFont);
		self.textLabel.textAlignment = UITextAlignmentRight;
		self.textLabel.contentMode = UIViewContentModeCenter;
		self.textLabel.lineBreakMode = UILineBreakModeWordWrap;
		self.textLabel.numberOfLines = 0;
		
		self.detailTextLabel.textColor = TTSTYLEVAR(mySubtextColor);
		self.detailTextLabel.font = TTSTYLEVAR(mySubtextFont);
		self.detailTextLabel.textAlignment = UITextAlignmentLeft;
		self.detailTextLabel.contentMode = UIViewContentModeTop;
		self.detailTextLabel.lineBreakMode = UILineBreakModeWordWrap;
		
      NSLog(@"Image1 is %@\n",item.image1);
		
		_imageView1.urlPath = item.image1;
      _imageView1.contentMode = UIViewContentModeScaleAspectFill;
		//_imageView1.style = item.imageStyle;
		
		_imageView2.urlPath = item.image2;
      _imageView2.contentMode = UIViewContentModeScaleAspectFill;
		//_imageView2.style = item.imageStyle;
		

   }
}

@end
