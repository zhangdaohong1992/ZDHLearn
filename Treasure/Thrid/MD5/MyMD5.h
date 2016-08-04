//
//  MD5.h
//  TestPhone
//
//  Created by Taidy on 14/12/3.
//  Copyright (c) 2014年 YDS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyMD5 : NSObject

void caculateSecretKey(unsigned char *output,unsigned char *phone,unsigned int phoneLen,unsigned char *password,unsigned int passwordLen);

+ (NSString *)md5ByphoneNumber:(NSString *)phone code:(NSString *)code;
+ (NSString *)md5ByParaWithString:(NSString *)para;

@end
