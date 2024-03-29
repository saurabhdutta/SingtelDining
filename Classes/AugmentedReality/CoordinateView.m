//
//  CoordinateView.m
//  iPhoneAugmentedRealityLib
//
//  Created by Niels W Hansen on 12/19/09.
//  Copyright 2009 Agilite Software. All rights reserved.
//

#import "CoordinateView.h"
#import "ARCoordinate.h"

#define BOX_WIDTH 180
#define BOX_HEIGHT 60

@implementation CoordinateView
@synthesize _owner, _callback;

- (id)initForCoordinate:(ARCoordinate *)coordinate owner:(id) o callback:(SEL) cb{   
	/*CGRect theFrame = CGRectMake(0, 0, BOX_WIDTH, BOX_HEIGHT);
	
	if (self = [super initWithFrame:theFrame]) {
      
		UILabel *titleLabel	= [[UILabel alloc] initWithFrame:CGRectMake(0, 0, BOX_WIDTH, 20.0)];
		
		[titleLabel setBackgroundColor: [UIColor colorWithWhite:.3 alpha:.8]];
		[titleLabel setTextColor:		[UIColor whiteColor]];
		[titleLabel setTextAlignment:	UITextAlignmentCenter];
		[titleLabel setText:			[coordinate title]];
		[titleLabel sizeToFit];
		[titleLabel setFrame:	CGRectMake(BOX_WIDTH / 2.0 - [titleLabel bounds].size.width / 2.0 - 4.0, 0, [titleLabel bounds].size.width + 8.0, [titleLabel bounds].size.height + 8.0)];
		
		UIImageView *pointView	= [[UIImageView alloc] initWithFrame:CGRectZero];
		[pointView setImage:	[UIImage imageNamed:@"location.png"]];
		[pointView setFrame:	CGRectMake((int)(BOX_WIDTH / 2.0 - [pointView image].size.width / 2.0), (int)(BOX_HEIGHT / 2.0 - [pointView image].size.height / 2.0), [pointView image].size.width, [pointView image].size.height)];
		
		[self addSubview:titleLabel];
		[self addSubview:pointView];
		[self setBackgroundColor:[UIColor clearColor]];
		[titleLabel release];
		[pointView release];
	}
	
   return self;*/
   
   self._owner = o;
   self._callback = cb;
   
   CGRect theFrame = CGRectMake(0, 0, BOX_WIDTH, BOX_HEIGHT);
	UIView *tempView = [[UIView alloc] initWithFrame:theFrame];
	
	tempView.backgroundColor = [UIColor colorWithRed:106/255.0 green:179/255.0 blue:178/255.0 alpha:0];
   
   UIImageView *bgView = [[UIImageView alloc] initWithFrame:CGRectZero];
	bgView.image = [UIImage imageNamed:@"ar_bg.png"];
	bgView.frame = CGRectMake(0, 0, bgView.image.size.width, bgView.image.size.height);
   [tempView addSubview:bgView];
   
   float yOffset = 4;
   CGSize titleSize1 = [coordinate.title sizeWithFont:[UIFont boldSystemFontOfSize: 12.0] constrainedToSize:CGSizeMake(180, 40) lineBreakMode:UILineBreakModeWordWrap];
   UILabel * titleLabel = [[[UILabel alloc] initWithFrame:CGRectMake(50, 5, 180 ,18)] autorelease];
   [titleLabel setFont:[UIFont fontWithName:@"Helvetica" size:12.0]];
   //titleLabel.numberOfLines = 2;
   titleLabel.textColor = [UIColor blueColor];
   titleLabel.textAlignment = UITextAlignmentLeft;
   titleLabel.backgroundColor = [UIColor clearColor];
   
   [titleLabel setText:coordinate.title];
   [tempView addSubview:titleLabel];
  
   yOffset = yOffset + titleSize1.height;
   
   NSString * distance;
   
   /*if([coordinate.subtitle floatValue] < 1000 )
   {
      
      distance = [NSString stringWithFormat:@"%d \n m", [coordinate.subtitle intValue] ];
   }
   
   else 
   {
      distance = [NSString stringWithFormat:@"%d \n km" , ([coordinate.subtitle doubleValue]/1000) ];
   }*/
   
   distance = coordinate.subtitle;
   
   
   
   
   CGSize titleSize = [distance sizeWithFont:[UIFont boldSystemFontOfSize: 15.0] constrainedToSize:CGSizeMake(40, 60) lineBreakMode:UILineBreakModeWordWrap];
   UILabel * label = [[[UILabel alloc] initWithFrame:CGRectMake(13, 8, 40 ,40)] autorelease];
   [label setFont:[UIFont fontWithName:@"Helvetica" size:15.0]];
   label.textColor = [UIColor blackColor];
   label.numberOfLines = 2;
   label.textAlignment = UITextAlignmentLeft;
   label.backgroundColor = [UIColor clearColor];
   
   
   
   if( [coordinate.subtitle isEqualToString:@"" ] ) 
      
      distance = @"";
      
   
   
   [label setText:distance];
   [tempView addSubview:label];
   
   
   CGSize titleSize2 = [coordinate.subtitle2 sizeWithFont:[UIFont boldSystemFontOfSize: 12.0] constrainedToSize:CGSizeMake(180, 40) lineBreakMode:UILineBreakModeWordWrap];
   UILabel * label2 = [[[UILabel alloc] initWithFrame:CGRectMake(50, 30, 180 ,18)] autorelease];
   [label2 setFont:[UIFont fontWithName:@"Helvetica" size:12.0]];
   label2.backgroundColor = [UIColor clearColor];
   label2.textAlignment = UITextAlignmentLeft;
   label2.textColor = [UIColor blackColor];
   //label.numberOfLines = 2;
   [label2 setText:coordinate.subtitle2];
   
   //UILabel * label = [[[UILabel alloc] initWithFrame:CGRectMake(26, 2, 134 ,20)] autorelease];
   //[label setText:coordinate.title];
   
   [tempView addSubview:label2];
   
   UIButton * btn = [UIButton buttonWithType: UIButtonTypeCustom];
   btn.frame = CGRectMake(0, 0, 180 ,60);
   btn.tag = coordinate.index;
   [btn addTarget:self action:@selector(onARIconClicked:) forControlEvents:UIControlEventTouchUpInside];
   [btn setTitleColor: [UIColor whiteColor] forState: UIControlStateNormal];
   [btn setContentHorizontalAlignment: UIControlContentHorizontalAlignmentLeft];
   
   [tempView addSubview: btn];
   
   /*UIButton * btnDist = [UIButton buttonWithType: UIButtonTypeCustom];
   btnDist.frame = CGRectMake(26, 20, 134 ,18);
   btnDist.tag = coordinate.index;
   [btnDist addTarget:self action:@selector(onARIconClicked:) forControlEvents:UIControlEventTouchUpInside];
   [btnDist setTitleColor: [UIColor whiteColor] forState: UIControlStateNormal];
   [btnDist setFont: [UIFont boldSystemFontOfSize: 10.0]];
   [btnDist setContentHorizontalAlignment: UIControlContentHorizontalAlignmentLeft];
   
   if( [coordinate.subtitle isEqualToString:@"" ] ) [btnDist setTitle:@"" forState: UIControlStateNormal];
   else [btnDist setTitle:[NSString stringWithFormat:@"Distance: %@ ml",coordinate.subtitle] forState: UIControlStateNormal];
    */
   
   //[tempView addSubview: btnDist];
	[bgView release];
	
	return [tempView autorelease];   
}

- (IBAction) onARIconClicked: (id) sender{
   NSLog(@"About to call callback....\n");
   if( self._owner != nil && self._callback != nil ){      
      NSLog(@"Calling callback\n");
    	[self._owner performSelector:self._callback withObject:[NSString stringWithFormat:@"%d", [sender tag]]];  
   }
}

- (void)drawRect:(CGRect)rect {
   // Drawing code
}

- (void)dealloc {
   [super dealloc];
}


@end
