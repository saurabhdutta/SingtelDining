//
//  HTableItemCell.m
//  HTable
//
//  Created by Alex Yao Cheng on 6/28/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "HTableItemCell.h"
#import "HTableItem.h"

static const CGFloat kKeySpacing = 12;
static const CGFloat kDefaultImageSize = 50;


///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
@implementation HTableItemCell

@synthesize tickView = _tickView;
@synthesize imageURL = _imageURL;
@synthesize selectedImageURL = _selectedImageURL;

///////////////////////////////////////////////////////////////////////////////////////////////////
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString*)identifier {
  if (self = [super initWithStyle:style reuseIdentifier:identifier]) {
    _tickView = [[TTImageView alloc] init];
    [self.contentView addSubview:_tickView];
  }
  
  return self;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)dealloc {
  TT_RELEASE_SAFELY(_tickView);
  TT_RELEASE_SAFELY(_imageURL);
  TT_RELEASE_SAFELY(_selectedImageURL);
  [super dealloc];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark TTTableViewCell

- (void)setSelected:(BOOL)selected animated:(BOOL)animated { }
///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setObject:(id)object {
  if (_item != object) {
    [super setObject:object];
    HTableItem *item = object;
    _tickView.style = item.imageStyle;
    _imageURL = item.imageURL;
    _selectedImageURL = item.selectedImageURL;
    if (item.selected) {
      _tickView.urlPath = item.tickURL;
      _imageView2.urlPath = _imageURL;
    } else {
      _tickView.urlPath = nil;
      _imageView2.urlPath = _selectedImageURL;
    }
  }
}


///////////////////////////////////////////////////////////////////////////////////////////////////
+ (CGFloat)tableView:(UITableView*)tableView rowHeightForObject:(id)object {
  return 150;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)layoutSubviews {
  [super layoutSubviews];
  self.textLabel.textAlignment = UITextAlignmentCenter;
  self.contentView.transform = CGAffineTransformMakeRotation(M_PI/2);
  self.accessoryType = UITableViewCellAccessoryNone;
  self.textLabel.hidden = YES;
  
  //NSLog(@"frame: %f, %f, %f, %f", self.frame.origin.x, self.frame.origin.y, self.frame.size.width, self.frame.size.height);

  //self.contentView.backgroundColor = [UIColor colorWithPatternImage:_imageView2.image];
  _imageView2.frame = CGRectMake(0, 0, self.frame.size.height, self.frame.size.width);
  self.backgroundColor = [UIColor clearColor];
  
  HTableItem *item = self.object;
  UIImage* image = item.tickURL ? [[TTURLCache sharedCache] imageForURL:item.tickURL] : nil;
  if (!image) {
    _tickView.frame = CGRectZero;
    return;
  }
  
  CGFloat imageWidth = image
  ? image.size.width
  : (item.tickURL ? kDefaultImageSize : 0);
  CGFloat imageHeight = image
  ? image.size.height
  : (item.tickURL ? kDefaultImageSize : 0);
  
  if (_tickView.urlPath) {
    CGFloat innerWidth = _imageView2.frame.size.width - (kTableCellHPadding*2 + imageWidth + kKeySpacing);
    CGFloat innerHeight = _imageView2.frame.size.height - kTableCellVPadding*2;
    self.textLabel.frame = CGRectMake(kTableCellHPadding, kTableCellVPadding, innerWidth, innerHeight);
    
    _tickView.frame = CGRectMake(_imageView2.frame.size.width - imageWidth,
                                   0, imageWidth, imageHeight);
    
  } else {
    self.textLabel.frame = CGRectInset(self.contentView.bounds, kTableCellHPadding, kTableCellVPadding);
    _tickView.frame = CGRectZero;
  }
}

@end
