//
//  GoodsRecordTableViewCell.m
//  Treasure
//
//  Created by 苹果 on 15/10/22.
//  Copyright © 2015年 YDS. All rights reserved.
//

#import "GoodsRecordTableViewCell.h"
#import "JoinRecordModel.h"
#import "UIImageView+AFNetworking.h"

@implementation GoodsRecordTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(JoinRecordModel *)model
{
    [self.IconImageView setImageWithURL:[NSURL URLWithString:model.userHeadImgUrl] placeholderImage:[UIImage imageNamed:@"trophy_r"]];
    self.nameLabel.text = model.nickName;
    self.IPLabel.text = [NSString stringWithFormat:@"(IP:%@)", model.ip];
    NSString * str = [NSString stringWithFormat:@"本次参与%@人次", model.joinCount];
    NSMutableAttributedString * string = [[NSMutableAttributedString alloc] initWithString:str];
    [string addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0xFF9500) range:NSMakeRange(4, model.joinCount.length)];
    [self.countLabel setAttributedText:string];
    self.timeLabel.text = model.joinTime;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    for (UIView *subview in self.contentView.superview.subviews) {
        if ([NSStringFromClass(subview.class) hasSuffix:@"SeparatorView"]) {
            subview.hidden = NO;
        }
    }
}
@end
