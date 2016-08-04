//
//  RootVCHandle.h
//  ServiceToHome
//
//  Created by Taidy on 15/8/17.
//  Copyright (c) 2015年 YDS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RootVCHandle : NSObject

+ (void)saveIconImage:(UIImage *)image;
+ (UIImage *)getCacheImage;
+ (NSString *)getImageFilePath;
+ (BOOL)deleteCacheImage;

@end
