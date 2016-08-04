//
//  XRRewardCell.h
//  Treasure
//
//  Created by 荣 on 15/10/29.
//  Copyright © 2015年 YDS. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XRRewardModel;
@class XRRewardCell;
@protocol rewardCellDelegate <NSObject>
@optional
-(void)rewardCellBtnClick:(XRRewardCell *)cell;

@end

@interface XRRewardCell : UITableViewCell

@property(nonatomic,strong)XRRewardModel *model;

@property(nonatomic,weak)id<rewardCellDelegate>delegate;

@property (weak, nonatomic) IBOutlet UIButton *sureAddBtn;

@end

