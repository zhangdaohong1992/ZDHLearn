//
//  UIButton+ButtonBadgeValue.m
//  Treasure
//
//  Created by 苹果 on 15/11/5.
//  Copyright © 2015年 YDS. All rights reserved.
//

#import "UIButton+ButtonBadgeValue.h"

@implementation UIButton (ButtonBadgeValue)

- (UILabel *)badgeValueWithCount:(NSInteger)count
{
    for (UIView * v in self.subviews) {
        if ([v isKindOfClass:[UILabel class]]) {
            [v removeFromSuperview];
        }
    }
    UILabel * label = [self addLabel];
    [self addSubview:label];
    label.text = [NSString stringWithFormat:@"%@", @(count)];
    if (count == 0) {
        label.hidden = YES;
    }
    return label;
}
- (UILabel *)addLabel
{
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(self.width - 10, 0, 10, 10)];
    label.layer.cornerRadius = label.width / 2.;
    label.layer.masksToBounds = YES;
    label.backgroundColor = [UIColor redColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:8];
    label.textColor = [UIColor whiteColor];
    return label;
}
@end
