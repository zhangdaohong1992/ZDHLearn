//
//  PayViewController.h
//  Treasure
//
//  Created by 苹果 on 15/11/4.
//  Copyright © 2015年 YDS. All rights reserved.
//

#import "ViewController.h"
@class ShoppingTableViewController;
@interface PayViewController : ViewController

@property (nonatomic, assign) NSInteger payCount;
@property (nonatomic, strong) NSString * itemString;
@property (nonatomic, strong) NSString * joinCountString;

@property (strong, nonatomic) IBOutlet UILabel *needCountLabel;
@property (strong, nonatomic) IBOutlet UIView *otherPayBackView;
@property (strong, nonatomic) IBOutlet UIView *alipayBackView;
@property (strong, nonatomic) IBOutlet UILabel *alipayNeedCountLabel;
@property (strong, nonatomic) IBOutlet UILabel *restCountLabel;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *sureButtonTop;
@property (strong, nonatomic) IBOutlet UIButton *sureButton;


@property (strong,nonatomic)ShoppingTableViewController *shopVc;
@property (weak, nonatomic) IBOutlet UIButton *alipayFirstBtn;//支付宝btn
@property (weak, nonatomic) IBOutlet UIButton *weiXinAlipayBtn;//微信支付


- (IBAction)sureButtonMethod:(id)sender;
//点击支付宝
- (IBAction)alipayBtnMethod:(UIButton *)sender;
//点击微信
- (IBAction)weiXinBtnMethod:(UIButton *)sender;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *selectImgVTop;


@end
