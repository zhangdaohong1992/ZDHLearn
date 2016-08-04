//
//  GoodsBottomView.m
//  Treasure
//
//  Created by 苹果 on 15/10/30.
//  Copyright © 2015年 YDS. All rights reserved.
//

#import "GoodsBottomView.h"

@implementation GoodsBottomView

+(GoodsBottomView *)instanceCenterViewWithType:(NSString*)type
{
    GoodsBottomView * goodsButtonView = [[[NSBundle mainBundle] loadNibNamed:@"GoodsBottomView" owner:nil options:nil] firstObject];
    if ([type isEqualToString:@"goto"]) {
        goodsButtonView.gotoBuyBackView.hidden = NO;
    }else{
        goodsButtonView.buyBackView.hidden = NO;
    }
    goodsButtonView.buyNowButton.layer.cornerRadius = goodsButtonView.gotoBuyBackView.layer.cornerRadius = goodsButtonView.addToShopCartButton.layer.cornerRadius = 5.;
    goodsButtonView.buyNowButton.layer.masksToBounds = goodsButtonView.gotoBuyBackView.layer.masksToBounds = goodsButtonView.addToShopCartButton.layer.masksToBounds = YES;
    goodsButtonView.addToShopCartButton.layer.borderColor = MAIN_NAV_COLOR.CGColor;
    goodsButtonView.addToShopCartButton.layer.borderWidth = 1.;
    goodsButtonView.gotoBuyButton.layer.cornerRadius = 5.;
    goodsButtonView.gotoBuyButton.layer.masksToBounds = YES;
    return goodsButtonView;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
