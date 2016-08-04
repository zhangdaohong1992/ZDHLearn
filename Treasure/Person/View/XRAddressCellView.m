//
//  XRAddressCellView.m
//  Treasure
//
//  Created by 荣 on 15/10/30.
//  Copyright © 2015年 YDS. All rights reserved.
//

#import "XRAddressCellView.h"

@implementation XRAddressCellView

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    for (UITextField *obj in self.subviews) {
        if ([obj isKindOfClass:[UITextField class]]) {
            [obj becomeFirstResponder];
        }
    }
}
@end
