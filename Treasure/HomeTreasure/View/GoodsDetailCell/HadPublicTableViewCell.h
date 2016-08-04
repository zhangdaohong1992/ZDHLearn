//
//  HadPublicTableViewCell.h
//  Treasure
//
//  Created by 苹果 on 15/10/27.
//  Copyright © 2015年 YDS. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HadPublicModel;

@interface HadPublicTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UIImageView *iconImageView;
@property (strong, nonatomic) IBOutlet UILabel *winnerNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *idLabel;
@property (strong, nonatomic) IBOutlet UILabel *luckNumberLabel;
@property (strong, nonatomic) IBOutlet UILabel *joinCountLabel;

@property (nonatomic, strong) HadPublicModel * model;

@end
