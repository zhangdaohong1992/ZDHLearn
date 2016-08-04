//
//  CategoryModel.m
//  Treasure
//
//  Created by 苹果 on 16/4/6.
//  Copyright © 2016年 YDS. All rights reserved.
//

#import "CategoryModel.h"

@implementation CategoryModel

+ (NSDictionary *)replacedKeyFromPropertyName
{
    return @{@"categoryId" : @"id"};
}

@end
