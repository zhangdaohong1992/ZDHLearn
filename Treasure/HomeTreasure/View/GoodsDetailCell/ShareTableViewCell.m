//
//  ShareTableViewCell.m
//  Treasure
//
//  Created by 苹果 on 15/10/27.
//  Copyright © 2015年 YDS. All rights reserved.
//

#import "ShareTableViewCell.h"
#import "UIImageView+AFNetworking.h"
#import "ShareGoodsModel.h"

@implementation ShareTableViewCell

- (void)awakeFromNib {
    _iconImageView.layer.cornerRadius = _iconImageView.width * 0.5;
    _iconImageView.clipsToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(ShareGoodsModel *)model
{
    [self.iconImageView setImageWithURL:[NSURL URLWithString:model.headImgUrl] placeholderImage:[UIImage imageNamed:@"head_gray"]];
    self.nameLabel.text = model.nickName;
    self.titleLable.text = [NSString stringWithFormat:@"[第%@期] %@", model.term, model.title];
    self.commentLabel.text = model.content;
    NSArray * imageViews = @[self.firstImageView, self.secondImageView, self.thirdImageView];
    NSArray * arr = [model.picUrls componentsSeparatedByString:@","];
    [self hiddenViewWithCount:arr.count];
    NSInteger count = MIN(arr.count, imageViews.count);
    NSLog(@"count = %@", @(count));
    for (int i  = 0; i < count; i++) {
        UIImageView * imageView = imageViews[i];
        imageView.hidden = NO;
        [imageView setImageWithURL:[NSURL URLWithString:arr[i]]];
    }
}

- (void)hiddenViewWithCount:(NSInteger)count
{
    switch (count) {
        case 1:
            self.secondImageView.hidden = self.thirdImageView.hidden = YES;
            break;
        case 2:
            self.thirdImageView.hidden = YES;
            break;
        case 3:
            self.firstImageView.hidden = self.secondImageView.hidden = self.thirdImageView.hidden = NO;
            break;
    }
}

- (void)prepareForReuse
{
    [super prepareForReuse];
    for (UIView * view in self.contentView.subviews) {
        if ([view isKindOfClass:[UIImageView class]]) {
            UIImageView * img = (UIImageView *)view;
            img.image = nil;
        }
    }
}

@end
