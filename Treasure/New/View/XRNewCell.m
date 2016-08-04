//
//  XRNewCell.m
//  Treasure
//
//  Created by 荣 on 15/10/27.
//  Copyright © 2015年 YDS. All rights reserved.
//

#import "XRNewCell.h"
#import "XRIssueCellModel.h"
#import <AFNetworking/UIImageView+AFNetworking.h>
@interface XRNewCell()<MZTimerLabelDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *headImageV;
@property (weak, nonatomic) IBOutlet UILabel *itemTitle;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet MZTimerLabel *openTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *nickLabel;
@property (weak, nonatomic) IBOutlet UILabel *joinLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *dic2bottom;
@property (weak, nonatomic) IBOutlet UIView *winnerView;
@property (weak, nonatomic) IBOutlet UIView *timeView;
@end

@implementation XRNewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setModel:(XRIssueCellModel *)model
{
    _model = self.model;
    
    [self.headImageV setImageWithURL:[NSURL URLWithString:model.itemPicture]];
    
    self.itemTitle.text = model.itemTitle;
    
    self.priceLabel.text = [NSString stringWithFormat:@"价值:￥%d",model.price];
    
    [self setUpTimeLabelWithCount:model.timeToOpen];
    
    self.nickLabel.text  = model.luckyNickName;
    
    self.joinLabel.text = [NSString stringWithFormat:@"%d",model.joinCount];
    if (model.state == 1) {
        self.winnerView.hidden = YES;
        self.dic2bottom.constant = _timeView.height - _winnerView.height + 10;
    }
    else
    {
        self.winnerView.hidden = NO;
        self.dic2bottom.constant = 10;
    }
    
}
-(void)setUpTimeLabelWithCount:(double)count
{
    self.openTimeLabel.timerType = MZTimerLabelTypeTimer;
    self.openTimeLabel.delegate = self;
    [self.openTimeLabel setCountDownTime:count];
    [self.openTimeLabel start];
}
-(void)timerLabel:(MZTimerLabel *)timerLabel finshedCountDownTimerWithTime:(NSTimeInterval)countTime
{

}
@end
