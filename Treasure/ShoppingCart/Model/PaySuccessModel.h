//
//  PaySuccessModel.h
//  Treasure
//
//  Created by 荣 on 15/11/7.
//  Copyright © 2015年 YDS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PaySuccessModel : NSObject
//itemTermId = 137;
//joinCount = 12;
//numberRecords = "10000008,10000004,10000003,10000011,10000010,10000012,10000002,10000009,10000001,10000007,10000005,10000006";
//title = "\U4e1c\U5317\U91ce\U751f\U84dd\U8393\U679c\U5e72100g";
@property(nonatomic,strong)NSString *itemTermId;
@property(nonatomic,strong)NSString *joinCount;
@property(nonatomic,strong)NSString *numberRecords;
@property(nonatomic,strong)NSString *title;


@end
