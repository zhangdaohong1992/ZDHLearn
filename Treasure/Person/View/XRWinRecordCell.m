//
//  XRWinRecordCell.m
//  Treasure
//
//  Created by 荣 on 15/10/28.
//  Copyright © 2015年 YDS. All rights reserved.
//

#import "XRWinRecordCell.h"
#import "XRWinRecordModel.h"
#import  "MZTimerLabel.h"
#import <AFNetworking/UIImageView+AFNetworking.h>
@interface XRWinRecordCell ()<MZTimerLabelDelegate>
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;/**<标题 */
@property (weak, nonatomic) IBOutlet UILabel *needCount;/**<总需要人数 */
@property (weak, nonatomic) IBOutlet UILabel *leftCount;/**<剩余人数 */
@property (weak, nonatomic) IBOutlet UILabel *termJoin;/**<本期参与人次 */
@property (weak, nonatomic) IBOutlet UILabel *timeJoin;/**<本次参与人次 */
@property (weak, nonatomic) IBOutlet UILabel *winLabel;/**<获得者昵称 */
@property (weak, nonatomic) IBOutlet UILabel *luckyNumLabel;/**<幸运号码 */
@property (weak, nonatomic) IBOutlet UILabel *openTimeLabel;/**<揭晓时间 */
@property (weak, nonatomic) IBOutlet UIProgressView *progress;/**<进度条 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *winerViewCons;/**<获得者view的高度 */
@property (weak, nonatomic) IBOutlet UIView *winView;
@property (weak, nonatomic) IBOutlet UIImageView *headImageV;
@property (weak, nonatomic) IBOutlet UILabel *leftLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *needLabelCons;/**<总需要人次label与标题的距离 */
@property (weak, nonatomic) IBOutlet UIButton *lookForNum; /**< 查看我的号码 */
@property (weak, nonatomic) IBOutlet MZTimerLabel *timeLabel; /**< 倒计时Label */
@property (weak, nonatomic) IBOutlet UIView *progressView;
@property (weak, nonatomic) IBOutlet UIView *timeView;


@end


@implementation XRWinRecordCell
-(void)awakeFromNib
{
    [super awakeFromNib];
    self.progress.transform = CGAffineTransformMakeScale(1.0f,3.0f);
    self.progress.layer.cornerRadius = 3.;
    self.progress.layer.masksToBounds = YES;
}
- (IBAction)clickLookNum:(id)sender {
    if ([self.delegate respondsToSelector:@selector(lookMynumInCell:)]) {
        [self.delegate lookMynumInCell:self];
    }
}


-(void)setModel:(XRWinRecordModel *)model
{
    _model = model;
    _titleLabel.text = [NSString stringWithFormat:@"[第%@期] %@", model.term, model.itemTitle];
    _needCount.text = [NSString stringWithFormat:@"总需要:%d",model.allCount];
    _leftCount.text = [NSString stringWithFormat:@"%d",model.restCount];
    _termJoin.text = [NSString stringWithFormat:@"本期参与:%d人次",model.joinCount];
    _timeJoin.text = [NSString stringWithFormat:@"%d",model.luckyManJoinCount];
    
    _winLabel.text = model.luckyNickName;
    _luckyNumLabel.text = model.luckyNum;
    _openTimeLabel.text = model.openTime;
    [_headImageV setImageWithURL:[NSURL URLWithString:model.picture] placeholderImage:[UIImage imageNamed:@"head_gray"]];
    //设置倒计时时间
    [self setUpTimeLabelWithCountModel:model];
    if (model.state == 0) {
        self.winerViewCons.constant = 0;
        self.needLabelCons.constant = 20;
        self.progressView.hidden = NO;
        self.winView.hidden = YES;
        self.timeView.hidden = YES;
        self.needCount.hidden = NO;
        self.progress.progress = 1.0 - model.restCount * 1.0 /model.allCount;
    }
    else if (model.state == 1) {
        self.winerViewCons.constant = 0;
        self.needLabelCons.constant = 20;
        //显示timeLabel
        self.progressView.hidden = YES;
        self.timeView.hidden = NO;
        self.winView.hidden = YES;
        self.needCount.hidden = YES;
    }
    else
    {
        self.winerViewCons.constant = 115;
        self.needLabelCons.constant = 15;
        self.progressView.hidden = YES;
        self.winView.hidden = NO;
        self.timeView.hidden = YES;
        self.needCount.hidden = NO;
    }
}

-(void)setUpTimeLabelWithCountModel:(XRWinRecordModel *)model
{
    if (model.state == 1) {
        self.timeLabel.timerType = MZTimerLabelTypeTimer;
        self.timeLabel.delegate = self;
        self.timeLabel.timeFormat = @"mm:ss:SS";
        double t = model.timeToOpen / 1000.;
        NSString *time = [NSString stringWithFormat:@"%f",t];
        NSLog(@"%@",time);
        [self.timeLabel reset];
        [self.timeLabel setCountDownTime:[time doubleValue]];
        [self.timeLabel start];
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

-(void)tableView:(UITableView *)tableView refrshModel:(XRWinRecordModel *)model
{
    self.model.openTime = model.openTime;
    self.model.luckyNickName = model.luckyNickName;
    self.model.luckyNum = model.luckyNum;
    self.model.luckyManJoinCount = model.joinCount;
    
//    self.model.userId = model.userId;
    self.model.joinCount = model.joinCount;
    self.model.state = 2;
    NSIndexPath *index = [NSIndexPath indexPathForRow:self.model.cellRow inSection:0];
    [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:index] withRowAnimation:UITableViewRowAnimationLeft];
}

@end
