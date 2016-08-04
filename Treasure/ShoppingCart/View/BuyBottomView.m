//
//  BuyBottomView.m
//  Treasure
//
//  Created by 苹果 on 15/11/3.
//  Copyright © 2015年 YDS. All rights reserved.
//

#import "BuyBottomView.h"

@implementation BuyBottomView

+ (id)initViewWithFrame:(CGRect)frame
{
    BuyBottomView * buyView = [[[NSBundle mainBundle] loadNibNamed:@"BuyBottomView" owner:nil options:nil] firstObject];
    buyView.buyButton.layer.cornerRadius = 5;
    buyView.buyButton.layer.masksToBounds = YES;
    buyView.deleteButton.layer.masksToBounds = YES;
    buyView.deleteButton.layer.cornerRadius = 5;
    buyView.deleteButton.layer.borderColor = MAIN_NAV_COLOR.CGColor;
    buyView.deleteButton.layer.borderWidth = 1.;
    buyView.frame = frame;
    return buyView;
}

- (void)setIsDelete:(BOOL)isDelete
{
    self.deleteBackView.hidden = !isDelete;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
