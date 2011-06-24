//
//  ListTableDelegate.m
//  SingtelDining
//
//  Created by Alex Yao on 6/24/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ListTableDelegate.h"
#import "CustomTableItem.h"
#import "ListObject.h"
#import "ListDataModel.h"
#import <QuartzCore/QuartzCore.h>


@implementation ListTableDelegate

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    id object = [self.controller.dataSource tableView:tableView objectForRowAtIndexPath:indexPath];
    if ([object isKindOfClass:[CustomTableItem class]]) {
        ListObject *post = [[(ListDataModel*)self.controller.dataSource.model posts] objectAtIndex:indexPath.row];
        if (cell.backgroundView == nil) {
            UIView *backgroundView = [[UIView alloc] initWithFrame:cell.bounds];
            
            CAGradientLayer *gradient = [CAGradientLayer layer];
            gradient.frame = backgroundView.bounds;
            gradient.colors = [NSArray arrayWithObjects:(id)[[UIColor lightGrayColor] CGColor], (id)[[UIColor whiteColor] CGColor], (id)[[UIColor lightGrayColor] CGColor], nil];
            gradient.locations = [NSArray arrayWithObjects:[NSNumber numberWithFloat:0.0f], [NSNumber numberWithFloat:0.5f], [NSNumber numberWithFloat:0.99f], nil];
            gradient.startPoint = CGPointMake(0, 0);
            gradient.endPoint = CGPointMake(1, 1);
            
            [backgroundView.layer insertSublayer:gradient atIndex:0];
            cell.backgroundView = backgroundView;
            [backgroundView release];
        }
        CAGradientLayer *gradient = (CAGradientLayer*)[[cell.backgroundView.layer sublayers] objectAtIndex:0];
        if (post.premiumDeal>0) {
            gradient.hidden = NO;
        } else {
            gradient.hidden = YES;
        }
    }
}

@end
