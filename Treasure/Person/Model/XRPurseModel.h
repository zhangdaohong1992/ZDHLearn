//
//  XRPurseModel.h
//  Treasure
//
//  Created by 荣 on 15/10/28.
//  Copyright © 2015年 YDS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XRPurseModel : NSObject
/** 类型/标题 */
@property(nonatomic,strong)NSString *type;
/** 流水id */
@property(nonatomic,copy)NSString *ID;
/** 带加减号 */
@property(nonatomic,assign)CGFloat money;
/** */
@property(nonatomic,strong)NSString *addTime;



@end
