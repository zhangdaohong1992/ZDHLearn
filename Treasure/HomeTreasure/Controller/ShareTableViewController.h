//
//  ShareTableViewController.h
//  Treasure
//
//  Created by 苹果 on 15/10/29.
//  Copyright © 2015年 YDS. All rights reserved.
//

#import "BaseTableViewController.h"

@interface ShareTableViewController : BaseTableViewController

@property (nonatomic, strong) NSString * itemID;
@property (nonatomic, strong) NSString * userID;
@property (nonatomic, assign) NSInteger type;//0 : 全部 1：商品往期晒单 2：个人晒单
@property (nonatomic, assign) BOOL isTabBarSelected;//防止每次进入刷新

@property (nonatomic, strong) NSString * relatedId;//如果type为1,表示的是商品id，如果type为2，表示用户id

@end
