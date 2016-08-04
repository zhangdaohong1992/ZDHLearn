//
//  ResponseModel.h
//  Treasure
//
//  Created by 苹果 on 15/10/21.
//  Copyright © 2015年 YDS. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface ResponseModel : NSObject

@property (nonatomic, strong, readonly) NSString * errcode;
@property (nonatomic, strong, readonly) NSString * info;
@property (nonatomic, strong, readonly) NSString * method;
@property (nonatomic, strong, readonly) id data;

+ (NSString *)getTImeBytimestampString:(NSString *)timstampStr;
+ (NSString *)getTImeBytimestampString:(NSString *)timstampStr dateFormatter:(NSString *)f;
+ (void)showInfoWithString:(NSString *)info;

@end
