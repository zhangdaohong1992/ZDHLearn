//
//  UIImage+XRImage.m
//  Treasure
//
//  Created by 荣 on 15/10/28.
//  Copyright © 2015年 YDS. All rights reserved.
//

#import "UIImage+XRImage.h"

@implementation UIImage (XRImage)
+(UIImage *)imageWithOrignalImageName:(NSString *)name
{
    UIImage *image = [UIImage imageNamed:name];
    return [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
}

-(UIImage *)stretchableImageWithOnePoint
{
    return  [self stretchableImageWithLeftCapWidth:self.size.width * 0.5 topCapHeight:self.size.height * 0.5];
}

+ (UIImage *)imageWithColor:(UIColor *)color
{
    // 描述矩形
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    
    // 开启位图上下文
    UIGraphicsBeginImageContext(rect.size);
    // 获取位图上下文
    CGContextRef context = UIGraphicsGetCurrentContext();
    // 使用color演示填充上下文
    CGContextSetFillColorWithColor(context, [color CGColor]);
    // 渲染上下文
    CGContextFillRect(context, rect);
    // 从上下文中获取图片
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    // 结束上下文
    UIGraphicsEndImageContext();
    
    return theImage;
}
+ (UIImage *)imageWithCircleBorderW:(CGFloat)borderW circleColor:(UIColor *)circleColor imageName:(NSString *)imageName
{
    return [self imageWithCircleBorderW:borderW circleColor:circleColor image:[UIImage imageNamed:imageName]];
}

+ (UIImage *)imageWithCircleBorderW:(CGFloat)borderW circleColor:(UIColor *)circleColor image:(UIImage *)image
{
    
    // 圆环宽度
    CGFloat borderWH = borderW;
    
    // 加载图片
    
    CGFloat ctxWH = image.size.width + 2 * borderWH;
    
    CGRect ctxRect = CGRectMake(0, 0, ctxWH, ctxWH);
    
    // 1.开启位图上下文
    UIGraphicsBeginImageContextWithOptions(ctxRect.size, NO, 0);
    
    // 2.画大圆
    UIBezierPath *bigCirclePath = [UIBezierPath bezierPathWithOvalInRect:ctxRect];
    
    // 设置圆环的颜色
    [circleColor set];
    
    [bigCirclePath fill];
    
    // 3.设置裁剪区域
    CGRect clipRect = CGRectMake(borderWH, borderWH, image.size.width, image.size.height);
    UIBezierPath *clipPath = [UIBezierPath bezierPathWithOvalInRect:clipRect];
    [clipPath addClip];
    
    //4.画图片
    [image drawAtPoint:CGPointMake(borderWH, borderWH)];
    
    // 5.从上下文中获取图片
    image = UIGraphicsGetImageFromCurrentImageContext();
    
    // 6.关闭上下文
    UIGraphicsEndImageContext();
    
    return image;
}

@end
