//
//  ShareTableViewCell.h
//  Treasure
//
//  Created by 苹果 on 15/10/27.
//  Copyright © 2015年 YDS. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ShareGoodsModel;

@interface ShareTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *iconImageView;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *titleLable;
@property (strong, nonatomic) IBOutlet UILabel *commentLabel;

@property (strong, nonatomic) IBOutlet UIImageView *firstImageView;
@property (strong, nonatomic) IBOutlet UIImageView *secondImageView;
@property (strong, nonatomic) IBOutlet UIImageView *thirdImageView;

@property (nonatomic, strong) ShareGoodsModel * model;

@end
