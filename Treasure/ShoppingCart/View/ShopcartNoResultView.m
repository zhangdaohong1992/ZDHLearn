//
//  ShopcartNoResultView.m
//  Treasure
//
//  Created by 苹果 on 16/2/26.
//  Copyright © 2016年 YDS. All rights reserved.
//

#import "ShopcartNoResultView.h"

@implementation ShopcartNoResultView

- (void)awakeFromNib
{
    self.height = 179;
    self.width = 150;
    self.goButton.layer.cornerRadius = 3.;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
//    NSLog(@"%@", NSStringFromCGRect(self.frame));

}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
