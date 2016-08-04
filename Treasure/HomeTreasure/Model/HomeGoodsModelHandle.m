//
//  HomeGoodsModelHandle.m
//  Treasure
//
//  Created by 苹果 on 15/10/22.
//  Copyright © 2015年 YDS. All rights reserved.
//

#import "HomeGoodsModelHandle.h"
#import "HomeGoodsModel.h"
#import "JKDBHelper.h"
#import "FMDB.h"

#import <QuartzCore/QuartzCore.h>   //动画
@implementation HomeGoodsModelHandle

- (NSArray *)getAdsImageArrayWithDic:(NSDictionary *)dic
{
    NSArray * slideShows = dic[DIC_DATA][@"slideShows"];
    NSMutableArray * imageURLs = [NSMutableArray array];
    NSMutableArray * imageIDs = [NSMutableArray array];
    for (NSDictionary * d in slideShows) {
        [imageURLs addObject:d[@"imageUrl"]];
        [imageIDs addObject:d[@"itemId"]];
    }
    self.imageIDs = imageIDs;
    return imageURLs;
}

+ (void)animationWithLayer:(CALayer *)layer withFromPoint:(CGPoint)fromPoint byPoint:(CGPoint)byPoint  toPoint:(CGPoint)toPoint
{
    CAKeyframeAnimation * animation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    CGMutablePathRef thePath = CGPathCreateMutable();
    CGPathMoveToPoint(thePath, nil, fromPoint.x, fromPoint.y);
    CGPathAddQuadCurveToPoint(thePath, nil, byPoint.x, byPoint.y, toPoint.x, toPoint.y);
    animation.path = thePath;
    animation.duration = 1;
    animation.removedOnCompletion = NO;
    animation.timingFunction =
    [CAMediaTimingFunction functionWithName: kCAMediaTimingFunctionEaseInEaseOut];
    [layer addAnimation:animation forKey:@"move"];
    
    CABasicAnimation *animation1 = [CABasicAnimation animationWithKeyPath:@"transform.scale"];//缩小
    animation1.duration = 1; // 动画持续时间
//    animation1.repeatCount = 1; // 重复次数
    animation1.autoreverses = YES; // 动画结束时执行逆动画
    animation1.fromValue = [NSNumber numberWithFloat:1.0]; // 开始时的倍率
    animation1.toValue = [NSNumber numberWithFloat:0.0]; // 结束时的倍率
    animation1.timingFunction =
    [CAMediaTimingFunction functionWithName: kCAMediaTimingFunctionEaseInEaseOut];
    [layer addAnimation:animation1 forKey:@"scale-layer"];
    
    CABasicAnimation *animation2 = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    animation2.duration = 1; // 持续时间
//    animation2.repeatCount = 1; // 重复次数
    animation2.fromValue = [NSNumber numberWithFloat:0.0]; // 起始角度
    animation2.toValue = [NSNumber numberWithFloat:3 * M_PI]; // 终止角度
    animation2.timingFunction =
    [CAMediaTimingFunction functionWithName: kCAMediaTimingFunctionEaseInEaseOut];
    [layer addAnimation:animation2 forKey:@"rotate-layer"];
    
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [layer removeFromSuperlayer];
    });
}

+ (CALayer *)creatLayerWithFromPoint:(CGPoint)fromPoint
{
    CALayer * layer = [CALayer new];
    layer.frame = CGRectMake(fromPoint.x, fromPoint.y, 20, 20);
    layer.cornerRadius = 10;
    layer.backgroundColor = [UIColor redColor].CGColor;
    return layer;
}
/**
 * 创建表
 * 如果已经创建，返回YES
 */
+ (BOOL)createTable
{
    __block BOOL res;
    JKDBHelper *jkDB = [JKDBHelper shareInstance];
    if ([jkDB.db open]) {
        res = [jkDB.db executeUpdate:[NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@(%@ INTEGER PRIMARY KEY, %@ TEXT NOT NULL, %@ TEXT NOT NULL,%@ TEXT NOT NULL,%@ TEXT NOT NULL,%@ TEXT NOT NULL, %@ INTEGER NOT NULL, %@ TEXT NOT NULL);", NSStringFromClass([self class]), ITEM_ID, PICTURE_URL,TITLE, TERM, TOTAL_COUNT, NEED_COUNT, JOIN_COUNT, ITEM_TERM_ID]];
        if (res) {
            NSLog(@"success creat table");
        }else{
            NSLog(@"error when creat table");
        }
        [jkDB.db close];
    }
    return res;
}

+ (BOOL)insertModel:(HomeGoodsModel *)model
{
    [self createTable];
    if ([model.restCount integerValue] == 0) {
        return NO;
    }
    NSString *insertSql = [NSString stringWithFormat:@"INSERT INTO %@(%@, %@, %@, %@, %@, %@, %@, %@) VALUES ('%d', '%@', '%@','%@','%@','%@', '%ld', '%@');", NSStringFromClass([self class]),ITEM_ID, PICTURE_URL, TITLE, TERM, TOTAL_COUNT, NEED_COUNT, JOIN_COUNT,ITEM_TERM_ID, model.itemId, model.picture, model.title, model.term, model.allCount, model.restCount, [model.restCount integerValue] >= 10 ? 10 : [model.restCount integerValue], model.itemTermID];
    JKDBHelper *jkDB = [JKDBHelper shareInstance];
    BOOL res;
    if ([jkDB.db open]) {
        res = [jkDB.db executeUpdate:insertSql];
        NSLog(res ? @"插入成功" : @"插入失败");
        [jkDB.db close];
    }
    return res;
}

+ (BOOL)updateWithModel:(HomeGoodsModel *)model
{
    NSString * updatesql = [NSString stringWithFormat:@"UPDATE %@ SET %@ = %ld, %@ = %@, %@ = %@ , %@ = %@, %@ = %@, %@ = '%@' WHERE %@ = %d;", NSStringFromClass([self class]),JOIN_COUNT, (long)model.joinCount, ITEM_TERM_ID, model.itemTermID, TOTAL_COUNT, model.allCount, TERM, model.term, NEED_COUNT, model.restCount, TITLE, model.title, ITEM_ID, model.itemId];
    NSLog(@"updatesql = %@", updatesql);
    JKDBHelper *jkDB = [JKDBHelper shareInstance];
    BOOL res;
    if ([jkDB.db open]) {
        res = [jkDB.db executeUpdate:updatesql];
        NSLog(res ? @"更新成功" : @"更新失败");
        [jkDB.db close];
    }
    return res;
}

+ (NSArray *)queryData:(NSString *)querySql
{
    [self createTable];
    if (querySql == nil || querySql.length == 0) {
        querySql = [NSString stringWithFormat:@"SELECT * FROM %@;", NSStringFromClass([self class])];
    }
    JKDBHelper *jkDB = [JKDBHelper shareInstance];
    NSMutableArray *arrM = [NSMutableArray array];
    if ([jkDB.db open]) {
        FMResultSet *set = [jkDB.db executeQuery:querySql];
        while ([set next]) {
            NSInteger itemID = [set intForColumn:ITEM_ID];
            NSString *picture = [set stringForColumn:PICTURE_URL];
            NSString *term = [set stringForColumn:TERM];
            NSString *title = [set stringForColumn:TITLE];
            NSString *allCount = [set stringForColumn:TOTAL_COUNT];
            NSString *restCount = [set stringForColumn:NEED_COUNT];
            NSInteger joinCount = [set intForColumn:JOIN_COUNT];
            NSString * itemTermID = [set stringForColumn:ITEM_TERM_ID];
            NSDictionary * dic = @{@"id": itemTermID, @"picture" : picture, @"term" : term, @"title" : title, @"allCount": allCount, @"restCount": restCount, @"joinCount" : @(joinCount), @"itemId" : @(itemID)};
            HomeGoodsModel * model = [HomeGoodsModel objectWithKeyValues:dic];
            [arrM addObject:model];
        }
        [jkDB.db close];
    }
    return arrM;
}

+ (BOOL)deleteData:(NSString *)deleteSql
{
    [self createTable];
    if (deleteSql == nil || deleteSql.length == 0) {
        deleteSql = [NSString stringWithFormat:@"DELETE FROM %@;", NSStringFromClass([self class])];
    }
    JKDBHelper *jkDB = [JKDBHelper shareInstance];
    BOOL res;
    if ([jkDB.db open]) {
        res = [jkDB.db executeUpdate:deleteSql];
        [jkDB.db close];
    }
    return res;
}

+ (BOOL)deleteByModel:(HomeGoodsModel *)model
{
    if (!model) {
        return NO;
    }
    BOOL res;
    JKDBHelper *jkDB = [JKDBHelper shareInstance];
    if ([jkDB.db open]) {
        res = [jkDB.db executeUpdate:[NSString stringWithFormat:@"DELETE FROM %@ WHERE %@ = %d", NSStringFromClass([HomeGoodsModelHandle class]), ITEM_ID, model.itemId]];
        NSLog(res ? @"删除成功" : @"删除失败");
        [jkDB.db close];
    }
    return res;
}

+ (BOOL)modifyData:(NSString *)modifySql
{
    [self createTable];
    if (!modifySql || modifySql.length == 0) {
        return NO;
    }
    JKDBHelper *jkDB = [JKDBHelper shareInstance];
    BOOL res;
    if ([jkDB.db open]) {
        res = [jkDB.db executeUpdate:modifySql];
        [jkDB.db close];
    }
    return res;
}

+ (BOOL)saveOrUpdateWithModel:(HomeGoodsModel *)model
{
    BOOL result = NO;
    NSLog(@"%@", [NSString stringWithFormat:@"SELECT * FROM %@ WHERE %@ = %d;", NSStringFromClass([self class]), ITEM_ID, model.itemId]);
    NSArray * arr = [[self class] queryData:[NSString stringWithFormat:@"SELECT * FROM %@ WHERE %@ = %d;", NSStringFromClass([self class]), ITEM_ID, model.itemId]];
    HomeGoodsModel * m = [arr firstObject];
    if (model.itemId == m.itemId) {
//        result = [HomeGoodsModelHandle updateWithModel:model];
    }else{
        result = [HomeGoodsModelHandle insertModel:model];
    }
    return result;
}

+ (BOOL)saveWithHomeGoodsModel:(HomeGoodsModel *)homeGoodsModel
{
    return [[self class] saveOrUpdateWithModel:homeGoodsModel];
}

+ (NSString *)tabbarBadgeValue
{
    NSArray * a = [self queryData:nil];
    NSLog(@"a.count = %@", a);
    NSString * str = [NSString stringWithFormat:@"%@", @(a.count)];
    return str;
}

+ (NSArray *)getOpeningGoodsByAllGoods:(NSArray *)array
{
//    NSMutableArray * tempArray = [NSMutableArray array];
//    for (NSDictionary * dic in array) {
//        if ([dic[@"state"] integerValue] == 1) {
//            [tempArray addObject:dic];
//        }
//    }
    if (array.count > 3) {
        return [array subarrayWithRange:NSMakeRange(0, 3)];
    }
    return array;
}

@end
