//
//  XRRewardCell.m
//  Treasure
//
//  Created by 荣 on 15/10/29.
//  Copyright © 2015年 YDS. All rights reserved.
//

#import "XRRewardCell.h"
#import "XRRewardModel.h"
#import <AFNetworking/UIImageView+AFNetworking.h>
@interface XRRewardCell ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UILabel *needCount;
@property (weak, nonatomic) IBOutlet UILabel *timeJoin;
@property (weak, nonatomic) IBOutlet UILabel *luckyNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *openTimeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *headImage;
@property (weak, nonatomic) IBOutlet UIImageView *stateImageV;


@end

@implementation XRRewardCell

-(void)awakeFromNib
{
    [_sureAddBtn addTarget:self action:@selector(sureBtnClick:) forControlEvents:UIControlEventTouchUpInside];
}
-(void)setModel:(XRRewardModel *)model
{
    _model = model;
    _titleLabel.text = [NSString stringWithFormat:@"[第%@期] %@", model.term, model.itemTitle];
    _needCount.text = [NSString stringWithFormat:@"总需要:%d",model.allCount];
    _timeJoin.text = [NSString stringWithFormat:@"%d",model.joinCount];
    _luckyNumLabel.text = model.luckyNum;
    _openTimeLabel.text = model.openTime;
    [_headImage setImageWithURL:[NSURL URLWithString:model.picture] placeholderImage:[UIImage imageNamed:@"head_gray"]];

    switch (model.state) {
        case 0:
            [_sureAddBtn setTitle:@"   确认地址   " forState:UIControlStateNormal];
            [_stateImageV setImage:[UIImage imageNamed:@"step1"]];
            break;
        case 1:
            [_sureAddBtn setTitle:@"   等待发货   " forState:UIControlStateNormal];
            [_stateImageV setImage:[UIImage imageNamed:@"step2"]];
            break;
        case 2:
            [_sureAddBtn setTitle:@"   确认收货   " forState:UIControlStateNormal];
            [_stateImageV setImage:[UIImage imageNamed:@"step2"]];
            break;
        case 3:
            [_sureAddBtn setTitle:@"   未发货,请联系客服   " forState:UIControlStateNormal];
            [_stateImageV setImage:[UIImage imageNamed:@"finish"]];
            break;
        case 4:
            [_sureAddBtn setTitle:@"   去晒单   " forState:UIControlStateNormal];
            [_stateImageV setImage:[UIImage imageNamed:@"finish"]];
            break;
        case 5:
            [_sureAddBtn setTitle:@"   已晒单   " forState:UIControlStateNormal];
            [_stateImageV setImage:[UIImage imageNamed:@"finish"]];
            break;
        default:
            break;
    }
}
-(void)sureBtnClick:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(rewardCellBtnClick:)]) {
        [self.delegate rewardCellBtnClick:self];
    }
}
@end
