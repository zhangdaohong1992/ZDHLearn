//
//  ShopingCartTableViewCell.h
//  Treasure
//
//  Created by 苹果 on 15/10/30.
//  Copyright © 2015年 YDS. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PAStepper;
@class HomeGoodsModel;
@class ShopingCartTableViewCell;
typedef void (^changeSelect)(ShopingCartTableViewCell *);
typedef void (^stepBlock)(int );
typedef void (^allBuy)(ShopingCartTableViewCell *);
@interface ShopingCartTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *iconImageView;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *totalCountLabel;
@property (strong, nonatomic) IBOutlet UILabel *needLabel;
@property (strong, nonatomic) IBOutlet UILabel *wordLabel;
@property (strong, nonatomic) IBOutlet PAStepper *stepperView;
@property (strong, nonatomic) IBOutlet UIButton *allInButton;
@property (weak, nonatomic) IBOutlet UIButton *checkBtn;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *allInButtonWidth;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *allInButtonX;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *stepViewWidth;

@property (strong, nonatomic) HomeGoodsModel * model;

@property(nonatomic,strong)changeSelect selectState;

@property(nonatomic,strong)stepBlock stepChange;

@property(nonatomic,strong)allBuy allInBuy;


- (IBAction)checkBtnClick:(id)sender;
@end
