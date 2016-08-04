//
//  XRChargeBtn.m
//  Treasure
//
//  Created by 荣 on 15/10/29.
//  Copyright © 2015年 YDS. All rights reserved.
//

#import "XRChargeBtn.h"

@implementation XRChargeBtn


-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setTitleColor:UIColorFromRGB(0x263238) forState:UIControlStateNormal];
        [self setTitleColor:UIColorFromRGB(0xff4640) forState:UIControlStateSelected];
        self.layer.cornerRadius = 2;
        self.layer.borderWidth = 1;
    }
    return self;
}
@end
