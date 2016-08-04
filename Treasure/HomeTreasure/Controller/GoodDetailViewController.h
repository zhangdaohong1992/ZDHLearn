//
//  GoodDetailViewController.h
//  Treasure
//
//  Created by 苹果 on 15/10/27.
//  Copyright © 2015年 YDS. All rights reserved.
//

#import "GoodsDetailBaseViewController.h"
@class HomeGoodsModel;

@interface GoodDetailViewController : GoodsDetailBaseViewController

@property (nonatomic, strong) NSString * itemId;
@property (nonatomic, strong) NSString * itemTermId;
@property (nonatomic, strong) NSString * adsID;

@end
