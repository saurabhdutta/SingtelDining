//
//  CouponTableItemCell.m
//  SingtelDining
//
//  Created by Alex Yao Cheng on 11/2/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "CouponTableItemCell.h"
#import "CouponTableItem.h"

// UI
#import "Three20UI/TTImageView.h"
#import "Three20UI/TTTableMessageItem.h"
#import "Three20UI/UIViewAdditions.h"
#import "Three20Style/UIFontAdditions.h"

// Style
#import "Three20Style/TTGlobalStyle.h"
#import "Three20Style/TTDefaultStyleSheet.h"

// Core
#import "Three20Core/TTCorePreprocessorMacros.h"
#import "Three20Core/NSDateAdditions.h"

static const NSInteger  kMessageTextLineCount       = 1;
static const CGFloat    kDefaultMessageImageWidth   = 50;
static const CGFloat    kDefaultMessageImageHeight  = 50;

@implementation CouponTableItemCell

- (void)setObject:(id)object {
    [super setObject:object];
    
    CouponTableItem *item = object;
    self.timestampLabel.text = item.rightLabel;
}

- (void)layoutSubviews { 
    [super layoutSubviews];
    
    CGFloat left = 0;
    if (_imageView2) {
        _imageView2.frame = CGRectMake(kTableCellSmallMargin, kTableCellSmallMargin,
                                       kDefaultMessageImageWidth, kDefaultMessageImageHeight);
        left += kTableCellSmallMargin + kDefaultMessageImageHeight + kTableCellSmallMargin;
    } else {
        left = kTableCellMargin;
    }
    
    CGFloat width = self.contentView.width - kTableCellSmallMargin*2 - kDefaultMessageImageWidth - 18;
    CGFloat top = kTableCellSmallMargin;
        
    if (_titleLabel.text.length) {
        _titleLabel.font = [UIFont boldSystemFontOfSize:13.0f];
        _titleLabel.lineBreakMode = UILineBreakModeWordWrap;
        _titleLabel.numberOfLines = 0;
        _titleLabel.minimumFontSize = 10.0f;
        _titleLabel.frame = CGRectMake(left, top, width, _titleLabel.font.ttLineHeight*2);
        top += _titleLabel.height;
    } else {
        _titleLabel.frame = CGRectZero;
    }
    
    if (self.captionLabel.text.length) {
        self.captionLabel.font = [UIFont systemFontOfSize:12.0f];
        self.captionLabel.frame = CGRectMake(left, top, width, self.captionLabel.font.ttLineHeight);
        top += self.captionLabel.height;
    } else {
        self.captionLabel.frame = CGRectZero;
    }
    
    if (self.detailTextLabel.text.length) {
        self.detailTextLabel.font = [UIFont systemFontOfSize:12.0f];
        CGFloat textHeight = self.detailTextLabel.font.ttLineHeight * kMessageTextLineCount;
        self.detailTextLabel.frame = CGRectMake(left, top, width, textHeight);
    } else {
        self.detailTextLabel.frame = CGRectZero;
    }
    
    if (_timestampLabel.text.length) {
        _timestampLabel.alpha = !self.showingDeleteConfirmation;
        [_timestampLabel sizeToFit];
        _timestampLabel.left = self.contentView.width - (_timestampLabel.width + kTableCellSmallMargin);
        _timestampLabel.top = _titleLabel.top;
        _titleLabel.width -= _timestampLabel.width + kTableCellSmallMargin*2;
    } else {
        _titleLabel.width = self.contentView.width - kTableCellSmallMargin*2;
    }
    _titleLabel.width = width;
}

@end
