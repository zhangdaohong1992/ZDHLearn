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
@property (weak, nonatomic) IBOutlet UILabel *nickLabel;
@property (weak, nonatomic) IBOutlet UILabel *joinLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *dic2bottom;
@property (weak, nonatomic) IBOutlet UIView *winnerView;
@property (weak, nonatomic) IBOutlet UIView *timeView;
@property (weak, nonatomic) IBOutlet UIImageView *nowImageV;
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
    _model = model;
    
    NSLog(@"modelState == %d",model.state);

    [self.headImageV setImageWithURL:[NSURL URLWithString:model.itemPicture] placeholderImage:[UIImage imageNamed:@"head_gray"]];
    
    self.itemTitle.text = [NSString stringWithFormat:@"[第%@期] %@", @(model.term), model.itemTitle];
    
    self.priceLabel.text = [NSString stringWithFormat:@"价值:￥%d",model.price];
    
    [self setUpTimeLabelWithCountModel:model];
    
    self.nickLabel.text  = model.luckyNickName;
    
    self.joinLabel.text = [NSString stringWithFormat:@"%d",model.joinCount];
    
    self.timeLabel.text = model.openTime;
    
    if (model.state == 1 | model.state == -1) {
        self.winnerView.hidden = YES;
        _nowImageV.hidden = NO;
        self.dic2bottom.constant = _timeView.height - _winnerView.height + 10;
    }
    else
    {
        self.winnerView.hidden = NO;
        _nowImageV.hidden = YES;
        self.dic2bottom.constant = 10;
    }
    
}
-(void)setUpTimeLabelWithCountModel:(XRIssueCellModel *)model
{
    if (model.state == 1) {
        self.openTimeLabel.timerType = MZTimerLabelTypeTimer;
        self.openTimeLabel.delegate = self;
        self.openTimeLabel.timeFormat = @"mm:ss:SS";
        double t = model.timeToOpen / 1000.;
        NSLog(@"t ==================== %f", t);
        [self.openTimeLabel reset];
        [self.openTimeLabel setCountDownTime:t];
        [self.openTimeLabel start];
    }else if(model.state == -1){
        self.openTimeLabel.text = @"正在计算...";
    }
}

-(void)timerLabel:(MZTimerLabel *)timerLabel finshedCountDownTimerWithTime:(NSTimeInterval)countTime
{
    self.openTimeLabel.text = @"正在计算...";
    if(self.model.state == 1){
    if ([self.delegate respondsToSelector:@selector(finshedCountDownTimer:)]) {
        [self.delegate finshedCountDownTimer:self];
         self.model.state = -1;
    }
    }
}

-(void)tableView:(UITableView *)tableView refrshModel:(XRIssueCellModel *)model
{
    self.model.openTime = model.openTime;
    self.model.luckyNickName = model.luckyNickName;
    self.model.userId = model.userId;
    self.model.joinCount = model.joinCount;
    self.model.state = 2;
    NSIndexPath *index = [NSIndexPath indexPathForRow:self.model.cellRow inSection:0];
    [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:index] withRowAnimation:UITableViewRowAnimationNone];
}
@end
