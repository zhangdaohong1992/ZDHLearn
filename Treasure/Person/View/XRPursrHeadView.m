//
//  XRPursrHeadView.m
//  Treasure
//
//  Created by 荣 on 15/10/27.
//  Copyright © 2015年 YDS. All rights reserved.
//

#import "XRPursrHeadView.h"
#import "UIColor+XRAdditions.h"

@implementation XRPursrHeadView

-(void)addSubviewWithBalanceCount:(NSString *)count
{
    CGFloat title2balance = 10;
    CGFloat balance2charge = 30;
    
    UILabel *titleLabel = [[UILabel alloc]init];
    [self setFont:15 title:@"余额" positionY:35.0  forLabel:titleLabel];
    
    UILabel *balanceLabel = [[UILabel alloc]init];
    [self setFont:30 title:count positionY:CGRectGetMaxY(titleLabel.frame)+title2balance forLabel:balanceLabel];
    self.balanceLabel = balanceLabel;
    
    UILabel *chargeLabel = [[UILabel alloc]init];
    [self setFont:18 title:@"充值" positionY:CGRectGetMaxY(balanceLabel.frame)+balance2charge forLabel:chargeLabel];
    
    CGRect temp = chargeLabel.frame;
    chargeLabel.frame = CGRectMake(self.center.x - 125 * 0.5, temp.origin.y, 125, 36);
    chargeLabel.layer.borderWidth = 1;
    chargeLabel.layer.cornerRadius = 4;
    chargeLabel.layer.borderColor = [UIColor whiteColor].CGColor;
    
    //添加点击手势
    chargeLabel.userInteractionEnabled = YES;
    [chargeLabel addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(pushToCharge)]];

    //添加imageView
    UIImageView *imageV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"02"]];
    imageV.frame = self.bounds;
    [self insertSubview:imageV atIndex:0];
    imageV.frame = self.frame;
    imageV.clipsToBounds = YES;
}

-(void)pushToCharge
{
    if ([self.delegate respondsToSelector:@selector(didClickChargeBtn:)]) {
        [self.delegate didClickChargeBtn:self];
    }
}

-(void)setFont:(CGFloat)font title:(NSString *)title positionY:(CGFloat )y forLabel:(UILabel *)label
{
    label.textAlignment= NSTextAlignmentCenter;
    [label setFont:[UIFont systemFontOfSize:font]];
    [label setTextColor:[UIColor colorWithHexString:@"#FFFFFF"]];
    [label setText:title];
    [label sizeToFit];
    CGRect temp = label.frame;
    label.frame = (CGRect){{self.center.x - temp.size.width * 0.5, y},temp.size};
    [self addSubview:label];
}
@end
