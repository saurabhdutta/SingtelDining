//
//  CSImageAnnotationView.m
//  DBSIndulge
//
//  Created by System Administrator on 28/11/2009.
//  Copyright 2009 Cellcity Pte Ltd. All rights reserved.
//

#import "CSImageAnnotationView.h"
#import "AddressAnnotation.h"

#define kHeight 23
#define kWidth  27
#define kBorder 0

@implementation CSImageAnnotationView
@synthesize imageView = _imageView;

- (id)initWithAnnotation:(id <MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier
{
	self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
	self.frame = CGRectMake(0, 0, kWidth, kHeight);
	//self.backgroundColor = [UIColor whiteColor];
	
	AddressAnnotation* csAnnotation = (AddressAnnotation*)annotation;
	
	UIImage* image = [UIImage imageNamed:csAnnotation.strImg];
	_imageView = [[UIImageView alloc] initWithImage:image];
   
	_imageView.frame = CGRectMake(kBorder, kBorder, kWidth - 2 * kBorder, kWidth - 2 * kBorder);
	[self addSubview:_imageView];
	
	return self;	
}

-(void) dealloc
{
	[_imageView release];
	[super dealloc];
}


@end
