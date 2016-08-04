//
//  BaseNetworkModel.m
//  Treasure
//
//  Created by 苹果 on 15/10/20.
//  Copyright © 2015年 YDS. All rights reserved.
//

#import "BaseNetworkModel.h"
#import "AFNetworking.h"
#import "MyMD5.h"
#import "AppDelegate.h"
static BaseNetworkModel * baseNetwork = nil;


@implementation BaseNetworkModel

+ (id)shareBaseNetwork
{
    baseNetwork = [[BaseNetworkModel alloc] initWithBaseURL];
    return baseNetwork;
}

- (id)initWithBaseURL
{
    self = [super init];
    if (self) {
        
        self.manager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:BASE_URL]];
        self.manager.requestSerializer.timeoutInterval = 20;
    }
    return self;
}

- (void)postWithParameter:(NSDictionary *)parameter method:(NSString *)method isHud:(BOOL)isHud
{
    if (isHud) {
        [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
        [SVProgressHUD setBackgroundColor:[UIColor colorWithWhite:0.1 alpha:0.8]];
        [SVProgressHUD setForegroundColor:[UIColor whiteColor]];
        [SVProgressHUD show];
    }
    NSDictionary * tempDic = [BaseNetworkModel getSafeDicWithDic:parameter method:method];
    
    [self.manager POST:method parameters:tempDic success:^(NSURLSessionDataTask *task, id responseObject) {
        if (isHud) {
            [SVProgressHUD dismiss];
        }
        if ([self.delegate respondsToSelector:@selector(successfulWithValue:method:)]) {
            [self.delegate successfulWithValue:responseObject method:method];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"error = %@", error);
        //should show detail error message by error code.
        AppDelegate *delegates = [[UIApplication sharedApplication] delegate];
        
        if (!delegates.isreach) {
            [ResponseModel showInfoWithString:@"服务器也去夺宝了,请稍等"];
        }else  [ResponseModel showInfoWithString:@"您的网络似乎出了点问题,请检查网络!"];
        if ([self.delegate respondsToSelector:@selector(errorWith:method:)]) {
            [self.delegate errorWith:error method:method];
        }
    }];
}

- (void)postWithParameter:(NSDictionary *)parameter method:(NSString *)method
{
    [self postWithParameter:parameter method:method isHud:NO];
}

- (void)getWithMethod:(NSString *)method isHud:(BOOL)isHud
{
    if (isHud) {
        [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
        [SVProgressHUD show];
    }
    
    AppDelegate *delegates = [[UIApplication sharedApplication] delegate];
    
    [self.manager GET:method parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, id responseObject) {
        if (isHud) {
            [SVProgressHUD dismiss];
        }
        if ([self.delegate respondsToSelector:@selector(successfulWithValue:method:)]) {
            [self.delegate successfulWithValue:responseObject method:method];
        }
        
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        
        if (!delegates.isreach) {
            [ResponseModel showInfoWithString:@"服务器也去夺宝了,请稍等"];
        }else  [ResponseModel showInfoWithString:@"您的网络似乎出了点问题,请检查网络!"];
        
        
        if ([self.delegate respondsToSelector:@selector(errorWith:method:)]) {
            [self.delegate errorWith:error method:method];
        }
    }];
}

- (void)getWithMethod:(NSString *)method
{
    [self getWithMethod:method isHud:NO];
}

//safe method
+ (NSDictionary *)getSafeDicWithDic:(NSDictionary *)parameter method:(NSString *)method
{
    NSArray * arr = [[[parameter keyEnumerator] allObjects] sortedArrayUsingSelector:@selector(compare:)];
    NSMutableString * string = [NSMutableString string];
    for (NSString * key in arr) {
        [string appendString:[NSString stringWithFormat:@"%@=%@", key, parameter[key]]];
        [string appendString:@"&"];
    }
    [string appendString:@"/"];
    [string appendString:PATH];
    [string appendString:method];
    NSLog(@"string is:%@", string);
    NSString * signResult = [MyMD5 md5ByParaWithString:string];
    NSMutableDictionary * tempDic = [NSMutableDictionary dictionaryWithDictionary:parameter];
    [tempDic setObject:signResult forKey:@"sign"];
    NSLog(@"final dic is:%@", tempDic);
    return tempDic;
}
@end
