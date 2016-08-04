//
//  GoodsInfoModel.m
//  Treasure
//
//  Created by 苹果 on 15/10/27.
//  Copyright © 2015年 YDS. All rights reserved.
//

#import "GoodsInfoModel.h"

@implementation GoodsInfoModel

+ (NSDictionary *)replacedKeyFromPropertyName
{
    return @{@"newestTerm" : @"newTerm"};
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"allcount =%@, id=%@, itemTermId=%@, newTerm=%@, restCount=%@, title=%@", self.allCount, self.itemId, self.itemTermId, self.newestTerm, self.restCount, self.title];
}

@end
