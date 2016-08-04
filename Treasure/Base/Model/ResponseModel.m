//
//  ResponseModel.m
//  Treasure
//
//  Created by 苹果 on 15/10/21.
//  Copyright © 2015年 YDS. All rights reserved.
//

#import "ResponseModel.h"
#import "SVProgressHud.h"

@implementation ResponseModel

+ (NSString *)getTImeBytimestampString:(NSString *)timstampStr
{
    return [ResponseModel getTImeBytimestampString:timstampStr dateFormatter:@"YYYY-MM-dd HH:mm:ss"];
}

+ (NSString *)getTImeBytimestampString:(NSString *)timstampStr dateFormatter:(NSString *)f
{
    NSDate * date = [NSDate dateWithTimeIntervalSince1970:[timstampStr longLongValue] / 1000];
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:f];
    NSString * str = [NSString stringWithFormat:@"%@", [formatter stringFromDate:date]];
    return str;
}

+ (void)showInfoWithString:(NSString *)info
{
    if ([SVProgressHUD isVisible]) {
        [SVProgressHUD dismiss];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [SVProgressHUD setBackgroundColor:[UIColor colorWithWhite:0.1 alpha:0.8]];
            [SVProgressHUD setForegroundColor:[UIColor whiteColor]];
            [SVProgressHUD showInfoWithStatus:info];
        });
    }else{
        [SVProgressHUD showInfoWithStatus:info];
    }
}

@end
