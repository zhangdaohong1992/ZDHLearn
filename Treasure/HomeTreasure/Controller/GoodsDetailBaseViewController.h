//
//  GoodsDetailBaseViewController.h
//  Treasure
//
//  Created by 苹果 on 15/10/27.
//  Copyright © 2015年 YDS. All rights reserved.
//

#import "BaseTableViewController.h"
#import "GJAutoCycleScrollView.h"
@class GoodsDetailHeaderView;

@interface GoodsDetailBaseViewController : BaseTableViewController
@property (nonatomic, assign) NSInteger pageCount;
@property (nonatomic, strong) NSArray * imageNames;
@property (nonatomic, strong) NSMutableArray * joinRecords;
@property (nonatomic, strong) NSMutableArray * dataArray;
@property (nonatomic, strong) GoodsDetailHeaderView * headerView;
@property (nonatomic, strong) GJAutoCycleScrollView *adScrollView;
@property (nonatomic, strong) UIWindow * window;

- (void)loadMore;

@end
