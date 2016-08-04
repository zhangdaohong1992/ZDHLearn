//
//  UIImage+XRImage.h
//  Treasure
//
//  Created by 荣 on 15/10/28.
//  Copyright © 2015年 YDS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (XRImage)
-(UIImage *)stretchableImageWithOnePoint;

+ (UIImage *)imageWithColor:(UIColor *)color;

+(UIImage *)imageWithOrignalImageName:(NSString *)name;

+ (UIImage *)imageWithCircleBorderW:(CGFloat)borderW circleColor:(UIColor *)circleColor imageName:(NSString *)imageName;

+ (UIImage *)imageWithCircleBorderW:(CGFloat)borderW circleColor:(UIColor *)circleColor image:(UIImage *)image;

@end
