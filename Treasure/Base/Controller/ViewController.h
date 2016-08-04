//
//  ViewController.h
//  Treasure
//
//  Created by 苹果 on 15/10/19.
//  Copyright (c) 2015年 YDS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseNetworkModel.h"


// All of your controller should be subclass of ViewController or BaseTableViewController. cuz i had packaged the base method of network.And the needed method sometimes;

@interface ViewController : UIViewController<BaseNetworkDelegate>

//the network started
@property (nonatomic, strong) BaseNetworkModel * network;
@property (nonatomic, strong) UILabel * noMoreDataLabel;

- (void)successfulWithDic:(NSDictionary *)dic method:(NSString *)method;

- (void)login;
- (BOOL)isPostSuccessedWithDic:(NSDictionary *)dic;

@end

