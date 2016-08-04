//
//  BackGrayView.m
//  OneExpress
//
//  Created by Taidy on 15/1/8.
//  Copyright (c) 2015年 YDS. All rights reserved.
//

#import "BackGrayView.h"

@implementation BackGrayView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
        self.backView = [[UIView alloc] initWithFrame:CGRectMake(32, VIEW_HEIGHT / 2 - 82, VIEW_WIDTH - 64, 164)];
        _backView.alpha = 0.9;
        _backView.backgroundColor = [UIColor whiteColor];
        _backView.layer.cornerRadius = 5;
        [self addSubview:_backView];
        
        self.icon = [[UIImageView alloc] initWithFrame:CGRectMake((VIEW_WIDTH - 64 - 36) / 2, 8, 36, 28)];
        _icon.layer.cornerRadius = 5;
        _icon.image = [UIImage imageNamed:@"complian_phone"];
        [_backView addSubview:_icon];
        
        self.companyLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, _icon.bottom + 10, VIEW_WIDTH - 64 - 40, 14)];
        _companyLabel.textColor = UIColorFromRGB(0x78909c);
        _companyLabel.font = [UIFont systemFontOfSize:12];
        _companyLabel.text = @"拨打电话或者QQ联系客服沟通";
        _companyLabel.textAlignment = NSTextAlignmentCenter;
        [_backView addSubview:_companyLabel];
        
        UILabel * line1 = [[UILabel alloc] initWithFrame:CGRectMake(0, _companyLabel.bottom + 15, VIEW_WIDTH - 64, 1)];
        line1.backgroundColor = UIColorFromRGB(0xF3F3F3);
        [_backView addSubview:line1];
        
        UILabel * line2 = [[UILabel alloc] initWithFrame:CGRectMake(0, line1.bottom + 40, VIEW_WIDTH - 64, 1)];
        line2.backgroundColor = UIColorFromRGB(0xF3F3F3);
        [_backView addSubview:line2];
        
        self.phoneIcon = [[UIImageView alloc] initWithFrame:CGRectMake(36, line1.bottom + 10, 20, 20)];
        _phoneIcon.image = [UIImage imageNamed:@"icon_phone-number"];
        [_backView addSubview:_phoneIcon];
        
        self.phoneButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [_phoneButton setTitle:@"phone" forState:UIControlStateNormal];
        [_phoneButton setTitleColor:UIColorFromRGB(0X263238) forState:UIControlStateNormal];
        _phoneButton.alpha = 0.9;
        _phoneButton.frame = CGRectMake(0, _phoneIcon.y, VIEW_WIDTH - 64, 20);
        [_backView addSubview:_phoneButton];
        
        self.qqIcon = [[UIImageView alloc] initWithFrame:CGRectMake(_phoneIcon.x, line2.bottom + 10, 20, 20)];
        _qqIcon.image = [UIImage imageNamed:@"qq"];
        [_backView addSubview:_qqIcon];
        
        self.qqButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [_qqButton setTitle:@"903417085" forState:UIControlStateNormal];
        [_qqButton setTitleColor:UIColorFromRGB(0X263238) forState:UIControlStateNormal];
        _qqButton.alpha = 0.9;
        _qqButton.frame = CGRectMake(0, _qqIcon.y, VIEW_WIDTH - 64, 20);
        [_backView addSubview:_qqButton];
        
    }
    return self;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch * touch = [touches  anyObject];
    CGPoint point = [touch locationInView:self.backView];
    if (point.y < 0 || point.y > self.backView.height) {
        [self removeFromSuperview];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
