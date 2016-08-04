//
//  GoodsDetailHeaderView.h
//  Treasure
//
//  Created by 苹果 on 15/10/23.
//  Copyright © 2015年 YDS. All rights reserved.
//

#import <UIKit/UIKit.h>
@class GoodsInfoModel;
@class GoodsWinnerModel;
@class MZTimerLabel;
@interface GoodsDetailHeaderView : UIView
@property (strong, nonatomic) IBOutlet UIImageView *bigImageView;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *stateLabel;

@property (strong, nonatomic) IBOutlet UIProgressView *progressView;
@property (strong, nonatomic) IBOutlet UILabel *totalLabel;
@property (strong, nonatomic) IBOutlet UILabel *needLabel;
@property (strong, nonatomic) IBOutlet UIView *progressBackView;

@property (strong, nonatomic) IBOutlet MZTimerLabel *timeLabel;
@property (strong, nonatomic) IBOutlet UIView *timeBackView;
@property (strong, nonatomic) IBOutlet UIButton *detailButton;

@property (strong, nonatomic) IBOutlet UIImageView *iconImageView;
@property (strong, nonatomic) IBOutlet UILabel *winnerNamelabel;
@property (strong, nonatomic) IBOutlet UILabel *winnerIDLabel;
@property (strong, nonatomic) IBOutlet UILabel *winnerCountLabel;
@property (strong, nonatomic) IBOutlet UILabel *publicTimeLabel;
@property (strong, nonatomic) IBOutlet UILabel *winnerNumberLabel;
@property (strong, nonatomic) IBOutlet UIView *winnerBackVIew;
@property (strong, nonatomic) IBOutlet UIButton *calculateDetailButton;

@property (strong, nonatomic) GoodsInfoModel * model;
@property (strong, nonatomic) GoodsWinnerModel * winnerModel;

@end
