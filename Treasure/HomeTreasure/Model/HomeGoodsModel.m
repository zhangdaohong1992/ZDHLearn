//
//  HomeGoodsModel.m
//  Treasure
//
//  Created by 苹果 on 15/10/21.
//  Copyright © 2015年 YDS. All rights reserved.
//

#import "HomeGoodsModel.h"

@implementation HomeGoodsModel

+ (NSDictionary *)replacedKeyFromPropertyName
{
    return @{@"itemTermID":@"id"};
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"itemid=%d, itemtermID=%@,item=%@, title=%@, allcount=%@, restcount = %@, joinCount = %ld", self.itemId, self.itemTermID, self.term, self.title, self.allCount, self.restCount, (long)self.joinCount];
}

@end
