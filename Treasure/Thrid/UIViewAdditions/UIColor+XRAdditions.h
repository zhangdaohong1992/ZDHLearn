//
//  UIColor+XRAdditions.h
//  Treasure
//
//  Created by 荣 on 15/10/27.
//  Copyright © 2015年 YDS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (XRAdditions)

+ (UIColor *)colorWithHexString:(NSString *)color;

+ (UIColor *)colorWithHexString:(NSString *)color alpha:(CGFloat)alpha;

@end
