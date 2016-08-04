//
//  HomeGoodsCollectionViewCell.m
//  Treasure
//
//  Created by 苹果 on 15/10/21.
//  Copyright © 2015年 YDS. All rights reserved.
//

#import "HomeGoodsCollectionViewCell.h"
#import "HomeGoodsModel.h"
#import "UIImageView+AFNetworking.h"

@implementation HomeGoodsCollectionViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setModel:(HomeGoodsModel *)model
{
    [self.goodsImageView setImageWithURL:[NSURL URLWithString:model.picture] placeholderImage:[UIImage imageNamed:@"angle-mask"]];
    self.titleLabel.text = model.title;
    NSInteger finishCount = [model.allCount integerValue] - [model.restCount integerValue];
    CGFloat rate = finishCount * 1.0 / [model.allCount integerValue] * 100.0;
    self.progressLabel.text = [NSString stringWithFormat:@"%.2f%%", rate];
    self.progress.progress = finishCount * 1.0 / [model.allCount integerValue];
    NSLog(@"%f", self.progress.progress);
    self.progress.transform = CGAffineTransformMakeScale(1.0f,3.0f);
    self.progress.layer.cornerRadius = 3.;
    self.progress.layer.masksToBounds = YES;
}

@end
