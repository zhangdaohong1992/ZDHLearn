//
//  XRNewDetailViewController.h
//  Treasure
//
//  Created by 荣 on 15/11/2.
//  Copyright © 2015年 YDS. All rights reserved.
//

#import "GoodsDetailBaseViewController.h"
@class XRNewHomePageVC;

@interface XRNewDetailViewController : GoodsDetailBaseViewController

@property (nonatomic, weak)   XRNewHomePageVC * homeVC;

@property (nonatomic, strong) NSString * itemId;//商品ID
@property (nonatomic, strong) NSString * itemTermId;//商品期数

@property (nonatomic,assign)BOOL isNewest;
@property (nonatomic,assign)int state;
@property (nonatomic,assign)double downCount;
@end
