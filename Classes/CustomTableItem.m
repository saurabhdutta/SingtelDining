//
//  CellItem.m
//  SingtelDining
//
//  Created by System Administrator on 21/06/10.
//  Copyright 2010 Cellcity Pte Ltd. All rights reserved.
//

#import "CustomTableItem.h"


@implementation CustomTableItem
@synthesize image1 = _image1, image2 = _image2, imageStyle = _imageStyle;

///////////////////////////////////////////////////////////////////////////////////////////////////
// class public

+ (id)itemWithText:(NSString*)text caption:(NSString*)caption image1:(NSString*)image1 image2:(NSString*)image2 {
   CustomTableItem* item = [[[self alloc] init] autorelease];
   item.text = text;
   item.caption = caption;
   item.image1 = image1;
   item.image2 = image2;
   return item;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
// NSObject

- (id)init {
	if (self = [super init]) {
		_image1 = nil;
		_image2 = nil;
		_imageStyle = nil;
	}
	return self;
}

- (void)dealloc {
	TT_RELEASE_SAFELY(_image1);
	TT_RELEASE_SAFELY(_image2);
	TT_RELEASE_SAFELY(_imageStyle);
	[super dealloc];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
// NSCoding

- (id)initWithCoder:(NSCoder*)decoder {
	if (self = [super initWithCoder:decoder]) {
		self.image1 = [decoder decodeObjectForKey:@"image1"];
		self.image2 = [decoder decodeObjectForKey:@"image2"];
	}
	return self;
}

- (void)encodeWithCoder:(NSCoder*)encoder {
	[super encodeWithCoder:encoder];
	if (self.image1) {
		[encoder encodeObject:self.image1 forKey:@"image1"];
	}
	if (self.image2) {
		[encoder encodeObject:self.image2 forKey:@"image2"];
	}
}

@end
