//
//  HadPublicTableViewCell.m
//  Treasure
//
//  Created by 苹果 on 15/10/27.
//  Copyright © 2015年 YDS. All rights reserved.
//

#import "HadPublicTableViewCell.h"
#import "HadPublicModel.h"
#import "UIImageView+AFNetworking.h"

@implementation HadPublicTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setModel:(HadPublicModel *)model
{
    self.titleLabel.text = [NSString stringWithFormat:@"[第%@期]揭晓时间: %@", model.term,model.openTime];
    [self.iconImageView setImageWithURL:[NSURL URLWithString:model.userHeadImgUrl] placeholderImage:[UIImage imageNamed:@"head_gray"]];
    self.winnerNameLabel.text = model.luckyNickName;
    self.idLabel.text = model.userId;
    self.luckNumberLabel.text = model.luckyNum;
    self.joinCountLabel.text = model.joinCount;
    _iconImageView.layer.cornerRadius = _iconImageView.width * 0.5;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
