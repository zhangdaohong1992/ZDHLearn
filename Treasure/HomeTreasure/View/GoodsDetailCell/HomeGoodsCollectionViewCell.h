//
//  HomeGoodsCollectionViewCell.h
//  Treasure
//
//  Created by 苹果 on 15/10/21.
//  Copyright © 2015年 YDS. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HomeGoodsModel;

@interface HomeGoodsCollectionViewCell : UICollectionViewCell

@property (strong, nonatomic) IBOutlet UIImageView *goodsImageView;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *progressLabel;
@property (strong, nonatomic) IBOutlet UIButton *shoppingButton;

@property (strong, nonatomic) IBOutlet UIProgressView *progress;
@property (strong, nonatomic) HomeGoodsModel * model;

@end
