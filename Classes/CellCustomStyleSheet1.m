//
//  CellCustomStyleSheet1.m
//  SingtelDining
//
//  Created by System Administrator on 21/06/10.
//  Copyright 2010 Cellcity Pte Ltd. All rights reserved.
//

#import "CellCustomStyleSheet1.h"





///////////////////////////////////////////////////////////////////////////////////////////////////

@implementation CellCustomStyleSheet1


///////////////////////////////////////////////////////////////////////////////////////////////////
// styles

///////////////////////////////////////////////////////////////////////////////////////////////////
// public colors

- (UIColor*)myHeadingColor {
	return RGBCOLOR(80, 110, 140);
}

- (UIColor*)mySubtextColor {
	return [UIColor grayColor];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
// public fonts

- (UIFont*)myHeadingFont {
	return [UIFont boldSystemFontOfSize:16];
}

- (UIFont*)mySubtextFont {
	return [UIFont systemFontOfSize:13];
}


@end