//
//  GoodsRecordTableViewCell.h
//  Treasure
//
//  Created by 苹果 on 15/10/22.
//  Copyright © 2015年 YDS. All rights reserved.
//

#import <UIKit/UIKit.h>
@class JoinRecordModel;

@interface GoodsRecordTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *IconImageView;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *IPLabel;
@property (strong, nonatomic) IBOutlet UILabel *countLabel;
@property (strong, nonatomic) IBOutlet UILabel *timeLabel;

@property (strong, nonatomic) JoinRecordModel * model;

@end
