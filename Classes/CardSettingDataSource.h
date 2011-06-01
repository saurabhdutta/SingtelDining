//
//  CardSettingDataSource.h
//  SingtelDining
//
//  Created by Alex Yao Cheng on 7/5/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#define kImageChecked @"bundle://checked.png"
#define kImageUnchecked @"bundle://unchecked.png"

#import <Foundation/Foundation.h>


@interface CardSettingDataSource : TTSectionedDataSource {
	NSDictionary* _cardPlist;
}

- (NSArray*)getCardArrayByBankName:(NSString*)bankName;
- (NSString*)getCardNameByBankName:(NSString*)bankName andCardIndex:(NSInteger)cardIndex;
- (NSString*)getCardIdByBankName:(NSString*)bankName andCardIndex:(NSInteger)cardIndex;

@end
