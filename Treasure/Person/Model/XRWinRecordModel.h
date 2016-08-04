//
//  XRWinRecordModel.h
//  Treasure
//
//  Created by 荣 on 15/10/29.
//  Copyright © 2015年 YDS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XRWinRecordModel : NSObject

@property(nonatomic,strong)NSString *itemTitle; /**< 商品标题 */

@property(nonatomic,strong)NSString *itemId;  /**< 商品Id */

@property(nonatomic,strong)NSString *term; /**< 期数 */

@property(nonatomic,strong)NSString *itemTermId;

@property(nonatomic,assign)double  timeToOpen;

@property(nonatomic,assign)int state; /**< 状态 */

@property(nonatomic,assign)int ID; /**< 状态 */

@property(nonatomic,assign)int allCount; /**< 需要总人数 */

@property(nonatomic,assign)int restCount;/**<还需多少人次够揭晓  */

@property(nonatomic,copy)NSString *joinNum;/**<参与号码  */

@property(nonatomic,assign)int joinCount; /**< 本次参与人数 */

@property(nonatomic,strong)NSString *luckyNickName;/**< 获奖者昵称 */

@property(nonatomic,strong)NSString *luckyNum;/**< 幸运号码 */

@property(nonatomic,assign)int luckyManJoinCount;/**< 中奖人次参与 */

@property(nonatomic,strong)NSString * openTime; /**< 揭晓时间 */

@property(nonatomic,strong)NSString *picture; /**< 头像图片 */

@property(nonatomic,copy)NSString *allTimes;/**< 全部次数 */

@property(nonatomic,copy)NSString *underwayTimes;/** 进行中次数*/

@property(nonatomic,copy)NSString *hasOpenTimes;/** 已揭晓次数 */

@property(nonatomic,assign)NSInteger cellRow;


@end
