//
//  XRPurseCell.m
//  Treasure
//
//  Created by 荣 on 15/10/27.
//  Copyright © 2015年 YDS. All rights reserved.
//

#import "XRPurseCell.h"
#import "UIColor+XRAdditions.h"
#import "XRPurseModel.h"

@interface XRPurseCell()
@property (weak, nonatomic) IBOutlet UILabel *itemLabel;
@property (weak, nonatomic) IBOutlet UILabel *joinCount;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *timeLabelLeftLC;
@end

@implementation XRPurseCell

-(void)setModel:(XRPurseModel *)model
{
    _model = model;
    _itemLabel.text = model.type;
    _joinCount.text = [NSString stringWithFormat:@"参与%.0f人次",fabs(model.money)];
    _timeLabel.text = [ResponseModel getTImeBytimestampString:model.addTime];
    if (model.money > 0) {
         _moneyLabel.text = [NSString stringWithFormat:@"+%.0f",model.money];
        [_moneyLabel setTextColor:UIColorFromRGB(0xff9500)];
        _joinCount.hidden = YES;
        _timeLabelLeftLC.constant = 10;
    }
    else{
         _moneyLabel.text = [NSString stringWithFormat:@"%.0f",model.money];
        [_moneyLabel setTextColor:UIColorFromRGB(0x163238)];
        _joinCount.hidden = NO;
        _timeLabelLeftLC.constant = 100;
    }
}
@end
