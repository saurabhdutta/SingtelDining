//
//  CellItem.h
//  SingtelDining
//
//  Created by System Administrator on 21/06/10.
//  Copyright 2010 Cellcity Pte Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface CustomTableItem : TTTableCaptionItem { 
	NSString* _image1;
	NSString* _image2;
	TTStyle* _imageStyle;
}

@property(nonatomic,copy) NSString* image1;
@property(nonatomic,copy) NSString* image2;
@property(nonatomic,retain) TTStyle* imageStyle;

+ (id)itemWithText:(NSString*)text caption:(NSString*)caption image1:(NSString*)image1 image2:(NSString*)image2;



@end 
