//
//  XRRewardModel.h
//  Treasure
//
//  Created by 荣 on 15/10/29.
//  Copyright © 2015年 YDS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XRRewardModel : NSObject

@property(nonatomic,strong)NSString *itemTitle; /**< 商品标题 */

@property(nonatomic,strong)NSString *itemId;  /**< 商品Id */

@property(nonatomic,strong)NSString *term; /**< 期数 */

@property(nonatomic,assign)int state; /**< 状态 */

@property(nonatomic,strong)NSString *ID; /**< 订单ID */

@property(nonatomic,assign)int allCount; /**< 需要总人数 */

@property(nonatomic,assign)int joinCount; /**< 本次参与人数 */

@property(nonatomic,strong)NSString * openTime; /**< 揭晓时间 */

@property(nonatomic,strong)NSString *picture; /**< 头像图片 */

@property(nonatomic,strong)NSString *luckyNum;

@end
