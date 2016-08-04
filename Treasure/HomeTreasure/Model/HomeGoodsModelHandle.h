//
//  HomeGoodsModelHandle.h
//  Treasure
//
//  Created by 苹果 on 15/10/22.
//  Copyright © 2015年 YDS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDB.h"
@class HomeGoodsModel;
@class JKDBHelper;

#define ITEM_ID     @"item_id"
#define PICTURE_URL @"picture_url"
#define TERM        @"term"
#define TITLE       @"title"
#define TOTAL_COUNT @"total_count"
#define NEED_COUNT  @"need_count"
#define JOIN_COUNT  @"join_count"
#define ITEM_TERM_ID @"item_term_id"

@interface HomeGoodsModelHandle : NSObject
@property (nonatomic, strong) HomeGoodsModel * model;
@property (nonatomic, strong) NSArray * imageIDs;
@property (nonatomic, strong) FMDatabase * db;

+ (void)animationWithLayer:(CALayer *)layer withFromPoint:(CGPoint)fromPoint byPoint:(CGPoint)byPoint toPoint:(CGPoint)toPoint;
+ (CALayer *)creatLayerWithFromPoint:(CGPoint)fromPoint;
- (NSArray *)getAdsImageArrayWithDic:(NSDictionary *)dic;

+ (BOOL)saveWithHomeGoodsModel:(HomeGoodsModel *)homeGoodsModel;
+ (NSString *)tabbarBadgeValue;

+ (BOOL)insertModel:(HomeGoodsModel *)model;
+ (NSArray *)queryData:(NSString *)querySql;
+ (BOOL)deleteData:(NSString *)deleteSql;
+ (BOOL)modifyData:(NSString *)modifySql;
+ (BOOL)updateWithModel:(HomeGoodsModel *)model;
+ (BOOL)deleteByModel:(HomeGoodsModel *)model;

+ (NSArray *)getOpeningGoodsByAllGoods:(NSArray *)array;

@end
