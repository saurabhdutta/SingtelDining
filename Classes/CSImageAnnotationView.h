//
//  CSImageAnnotationView.h
//  DBSIndulge
//
//  Created by System Administrator on 28/11/2009.
//  Copyright 2009 Cellcity Pte Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface CSImageAnnotationView : MKAnnotationView
{
	UIImageView* _imageView;
}

@property (nonatomic, retain) UIImageView* imageView;
@end
