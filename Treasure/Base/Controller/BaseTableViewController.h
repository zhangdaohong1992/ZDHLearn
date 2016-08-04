//
//  BaseTableViewController.h
//  Treasure
//
//  Created by 苹果 on 15/10/20.
//  Copyright © 2015年 YDS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseNetworkModel.h"

// All of your controller should be subclass of ViewController or BaseTableViewController. cuz i had packaged the base method of network.And the needed method sometimes;

@interface BaseTableViewController : UITableViewController<BaseNetworkDelegate>

//the network started
@property (nonatomic, strong) BaseNetworkModel * network;
@property (nonatomic, strong) UILabel * noMoreDataLabel;

- (void)successfulWithDic:(NSDictionary *)dic method:(NSString *)method;

- (void)login;
- (BOOL)isPostSuccessedWithDic:(NSDictionary *)dic;

@end
