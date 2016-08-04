//
//  GoodsBottomView.h
//  Treasure
//
//  Created by 苹果 on 15/10/30.
//  Copyright © 2015年 YDS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GoodsBottomView : UIView
@property (strong, nonatomic) IBOutlet UIView *buyBackView;
@property (strong, nonatomic) IBOutlet UIButton *buyNowButton;
@property (strong, nonatomic) IBOutlet UIButton *addToShopCartButton;
@property (strong, nonatomic) IBOutlet UIButton *shopCartButton;

@property (strong, nonatomic) IBOutlet UIView *gotoBuyBackView;
@property (strong, nonatomic) IBOutlet UILabel *itemLabel;
@property (strong, nonatomic) IBOutlet UIButton *gotoBuyButton;

+(GoodsBottomView *)instanceCenterViewWithType:(NSString*)type;

@end
