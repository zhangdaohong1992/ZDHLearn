//
//  NormalCollectionReusableView.m
//  Treasure
//
//  Created by 苹果 on 16/4/5.
//  Copyright © 2016年 YDS. All rights reserved.
//

#import "NormalCollectionReusableView.h"

@implementation NormalCollectionReusableView
- (void)addNormalTitle
{
    self.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.button];
    [self addSubview:self.label];
}

- (UILabel *)label
{
    if (!_label) {
        _label = [[UILabel alloc] initWithFrame:CGRectMake(15, 5, 100, 20)];
        _label.text = @"最新揭晓";
        _label.textColor = UIColorFromRGB(0x263238);
        _label.font = [UIFont systemFontOfSize:13];
    }
    return _label;
}

- (UIButton *)button
{
    if (!_button) {
        _button = [UIButton buttonWithType:UIButtonTypeSystem];
        _button.frame = CGRectMake(self.frame.size.width - 100, 5, 100, 20);
        NSMutableAttributedString * string = [[NSMutableAttributedString alloc] initWithString:@"显示全部>>" attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:12], NSForegroundColorAttributeName : UIColorFromRGB(0x78909C)}];
        [_button setAttributedTitle:string forState:UIControlStateNormal];
        [_button addTarget:self action:@selector(tapMethod) forControlEvents:UIControlEventTouchUpInside];
    }
    return _button;
}

- (void)tapMethod
{
    self.taped();
}

- (void)handleButtonTaped:(ButtonTaped)tap
{
    self.taped = tap;
}

@end
