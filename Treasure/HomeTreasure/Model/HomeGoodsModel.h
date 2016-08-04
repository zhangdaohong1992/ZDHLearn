//
//  HomeGoodsModel.h
//  Treasure
//
//  Created by 苹果 on 15/10/21.
//  Copyright © 2015年 YDS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HomeGoodsModel : NSObject

@property (nonatomic, assign) int itemId;
@property (nonatomic, strong) NSString * picture;
@property (nonatomic, strong) NSString * title;
@property (nonatomic, strong) NSString * term;
@property (nonatomic, strong) NSString * allCount;
@property (nonatomic, strong) NSString * restCount;
@property (nonatomic, strong) NSString * itemTermID;

@property (nonatomic, assign) NSInteger joinCount;

@property (nonatomic,assign,getter = isEditState)BOOL editState;/**< 编辑状态 */

@property (nonatomic,assign,getter = isSelected)BOOL selected;/**< 是否被选择 */

@property (nonatomic,assign,getter= isAllBuy)BOOL allBuy;/**< 是否点击了包尾按钮 */

@property (nonatomic,assign)int tempCount;
@end
