//
//  RootVCHandle.m
//  ServiceToHome
//
//  Created by Taidy on 15/8/17.
//  Copyright (c) 2015年 YDS. All rights reserved.
//

#import "RootVCHandle.h"

@implementation RootVCHandle

+ (void)saveIconImage:(UIImage *)image
{
    BOOL success;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    NSString * imageFilePath = [self getImageFilePath];
    success = [fileManager fileExistsAtPath:imageFilePath];
    if(success) {
        [fileManager removeItemAtPath:imageFilePath error:&error];
    }
    [UIImageJPEGRepresentation(image, 0.5f) writeToFile:imageFilePath atomically:YES];//写入
}

+ (NSString *)getImageFilePath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *imageFilePath = [documentsDirectory stringByAppendingPathComponent:[[NSUserDefaults standardUserDefaults] objectForKey:USER_PHONE] ];
    return imageFilePath;
}

+ (UIImage *)getCacheImage
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *imageFilePath = [documentsDirectory stringByAppendingPathComponent:[[NSUserDefaults standardUserDefaults] objectForKey:USER_PHONE]];
    NSLog(@"imageFile->>%@",imageFilePath);
    UIImage *selfPhoto = [UIImage imageWithContentsOfFile:imageFilePath];
    return selfPhoto;
}

+ (BOOL)deleteCacheImage
{
    NSString * imageFilePath = [self getImageFilePath];
    NSFileManager * mg = [[NSFileManager alloc] init];
    return [mg removeItemAtPath:imageFilePath error:nil];
}

@end
