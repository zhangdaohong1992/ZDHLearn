//
//  GoodsDetailHeaderView.m
//  Treasure
//
//  Created by 苹果 on 15/10/23.
//  Copyright © 2015年 YDS. All rights reserved.
//

#import "GoodsDetailHeaderView.h"
#import "GoodsInfoModel.h"
#import "GoodsWinnerModel.h"
#import "MZTimerLabel.h"
#import <AFNetworking/UIImageView+AFNetworking.h>
@implementation GoodsDetailHeaderView

-(void)awakeFromNib{
    self.progressView.transform = CGAffineTransformMakeScale(1.0f,3.0f);
    self.progressView.layer.masksToBounds = self.iconImageView.layer.masksToBounds = self.detailButton.layer.masksToBounds = self.calculateDetailButton.layer.masksToBounds = YES;
    self.progressView.layer.cornerRadius = 3.;
    self.iconImageView.layer.cornerRadius = self.iconImageView.height / 2.;
    self.detailButton.layer.borderColor = self.calculateDetailButton.layer.borderColor = [UIColor whiteColor].CGColor;
    self.detailButton.layer.borderWidth = self.calculateDetailButton.layer.borderWidth = 1.;
}

- (void)setModel:(GoodsInfoModel *)model
{
    NSString * str = [NSString stringWithFormat:@"[第%@期]%@", model.term, model.title];
    NSMutableAttributedString * string = [[NSMutableAttributedString alloc] initWithString:str];
    NSMutableParagraphStyle * style = [[NSMutableParagraphStyle alloc] init];
    style.firstLineHeadIndent = 55;
    style.lineSpacing = 10;
    [string addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, str.length)];
    [self.titleLabel setAttributedText:string];
    
    if ([model.state isEqualToString:@"0"] || [model.state isEqualToString:@"1"]) {
        if ([model.state isEqualToString:@"0"]) {
            self.progressBackView.hidden = NO;
            NSInteger finishCount = [model.allCount integerValue] - [model.restCount integerValue];
            CGFloat rate = finishCount * 1.0 / [model.allCount integerValue];
            self.progressView.progress = rate;
            self.totalLabel.text = model.allCount;
            self.needLabel.text = model.restCount;
            self.progressView.transform = CGAffineTransformMakeScale(1.0f,3.0f);
            self.progressView.layer.cornerRadius = 3.;
            self.progressView.layer.masksToBounds = YES;

        }else{
            self.progressBackView.hidden = YES;
            self.timeLabel.timerType = MZTimerLabelTypeTimer;
            self.timeLabel.timeFormat = @"揭晓倒计时 mm:ss:SS";
            [self.timeLabel setCountDownTime:[model.timeToOpen doubleValue] / 1000.];
            [self.timeLabel start];
        }
        self.stateLabel.text = @"进行中";
    }else{
        self.stateLabel.text = @"已揭晓";
    }
}

-(void)setWinnerModel:(GoodsWinnerModel *)winnerModel
{
    _winnerModel = winnerModel;
    [self.iconImageView setImageWithURL:[NSURL URLWithString:winnerModel.userHeadImgUrl] placeholderImage:[UIImage imageNamed:@"head_gray"]];
    _winnerNamelabel.text = winnerModel.luckyNickName;
    _winnerIDLabel.text = winnerModel.userId;
    _winnerCountLabel.text = winnerModel.joinCount;
    _publicTimeLabel.text = winnerModel.openTime;
    _winnerNumberLabel.text = [NSString stringWithFormat:@"  幸运号码:%@",winnerModel.luckyNum];
}




@end
