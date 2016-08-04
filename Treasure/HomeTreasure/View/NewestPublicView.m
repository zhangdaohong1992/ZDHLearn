//
//  NewestPublicView.m
//  Treasure
//
//  Created by 苹果 on 16/4/8.
//  Copyright © 2016年 YDS. All rights reserved.
//

#import "NewestPublicView.h"
#import "MZTimerLabel.h"
#import "XRIssueCellModel.h"
#import "UIImageView+AFNetworking.h"

@implementation NewestPublicView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)setModel:(XRIssueCellModel *)model
{
    [self.imgView setImageWithURL:[NSURL URLWithString:model.itemPicture] placeholderImage:[UIImage imageNamed:@"head_gray"]];
    self.titleLabel.text = model.itemTitle;
    self.timeLabel.layer.cornerRadius = 5;
    self.timeLabel.layer.masksToBounds = YES;
    self.timeLabel.delegate = self;
    self.timeLabel.text = @"已开奖";
    if (model.timeToOpen <= 0) {
        self.timeLabel.text = @"已开奖";
    }else{
        self.timeLabel.timerType = MZTimerLabelTypeTimer;
        self.timeLabel.timeFormat = @"mm:ss:SS";
        double t = model.timeToOpen / 1000.;
        NSLog(@"t ==================== %f", t);
        [self.timeLabel setCountDownTime:t];
        [self.timeLabel start];
    }
}

#pragma mark - MZTimerLabelDelegate
-(void)timerLabel:(MZTimerLabel*)timerLabel finshedCountDownTimerWithTime:(NSTimeInterval)countTime
{
    timerLabel.text = @"已开奖";
}

@end
