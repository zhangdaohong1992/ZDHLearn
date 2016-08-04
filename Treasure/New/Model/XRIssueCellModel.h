//
//  XRIssueCellModel.h
//  Treasure
//
//  Created by 荣 on 15/10/26.
//  Copyright © 2015年 YDS. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface XRIssueCellModel : NSObject
/** 图片地址*/
@property(nonatomic,copy)NSString *itemPicture;
/** 期数标题 */
@property(nonatomic,copy)NSString *itemTitle;
/** 参与人数 */
@property(nonatomic,assign)int joinCount;
/** 幸运昵称 */
@property(nonatomic,strong)NSString *luckyNickName;

//@property(nonatomic,strong)NSString *luckyNum;
/** 开奖时间 */
@property(nonatomic,assign)double openTime;
/** 价格 */
@property(nonatomic,assign)int price;
/** 状态 */
@property(nonatomic,assign)int state;
/** 期数 */
@property(nonatomic,assign)int term;
/** 开奖倒计时 */
@property(nonatomic,assign)double timeToOpen;
/** 用户头像 */
@property(nonatomic,strong)NSString *userHeadImgUrl;
/** 用户iD */
@property(nonatomic,assign)int userId;

@end
