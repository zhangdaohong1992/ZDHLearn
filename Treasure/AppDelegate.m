//
//  AppDelegate.m
//  Treasure
//
//  Created by 苹果 on 15/10/19.
//  Copyright (c) 2015年 YDS. All rights reserved.
//

#import "AppDelegate.h"
#import <AlipaySDK/AlipaySDK.h>
#import "APService.h"
#import "MobClick.h"
#import "AFNetworking.h"
#import "UMSocial.h"
#import "UMSocialWechatHandler.h"
#import "UMSocialQQHandler.h"
#import <JSPatch/JSPatch.h>
#import "WXApi.h"
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [application setStatusBarStyle:UIStatusBarStyleLightContent];
    
    [[UINavigationBar appearance] setBarTintColor:MAIN_NAV_COLOR];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName : MAIN_NAV_COLOR} forState:UIControlStateSelected];
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60) forBarMetrics:UIBarMetricsDefault];
    [self reach];
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        //可以添加自定义categories
        [APService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |
                                                       UIUserNotificationTypeSound |
                                                       UIUserNotificationTypeAlert)
                                           categories:nil];
    } else {
        //categories 必须为nil
        [APService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                       UIRemoteNotificationTypeSound |
                                                       UIRemoteNotificationTypeAlert)
                                           categories:nil];
    }
    
    [JSPatch startWithAppKey:@"cdd56b951180dd44"];
    [JSPatch sync];
    
    // Required
    [APService setupWithOption:launchOptions];
    [MobClick startWithAppkey:UMENG_APPKEY reportPolicy:BATCH channelId:@""];
    [UMSocialData setAppKey:UMENG_APPKEY];
    [UMSocialWechatHandler setWXAppId:@"wxb20b24b0e486e5e6" appSecret:@"8ea0fbbec8554937ccccbd562ea8807c" url:@"http://sber.io"];
    [UMSocialQQHandler setQQWithAppId:@"1105032388" appKey:@"5Imks30bLVdsi5Ot" url:@"http://sber.io"];
    // Override point for customization after application launch.
    
    
    //向微信注册wxd930ea5d5a258f4f
    [WXApi registerApp:@"com.haotai.thumbTreasures" withDescription:@"手指夺宝微信支付"];

    
    
    return YES;
}
//payment
-(void) onResp:(BaseResp*)resp
{
    NSString *strMsg = [NSString stringWithFormat:@"errcode:%d", resp.errCode];
    NSString *strTitle = nil;
    
    //    if([resp isKindOfClass:[SendMessageToWXResp class]])
    //    {
    //        strTitle = [NSString stringWithFormat:@"发送媒体消息结果"];
    //    }
    if([resp isKindOfClass:[PayResp class]]){
        //支付返回结果，实际支付结果需要去微信服务器端查询
        strTitle = [NSString stringWithFormat:@"支付结果"];
        
        switch (resp.errCode) {
            case WXSuccess:
                strMsg = @"YES";
                NSLog(@"微信支付成功－PaySuccess，retcode = %d", resp.errCode);
                break;
                
            default:
                strMsg = @"NO";
                NSLog(@"微信支付错误，retcode = %d, retstr = %@", resp.errCode,resp.errStr);
                break;
        }
        //        [self creatWeixinRsultViewWith:strMsg];
        //        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle message:strMsg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        //        [alert show];
    }
    
}

- (void)reach
{
    /**
     AFNetworkReachabilityStatusUnknown          = -1,  // 未知
     AFNetworkReachabilityStatusNotReachable     = 0,   // 无连接
     AFNetworkReachabilityStatusReachableViaWWAN = 1,   // 3G 花钱
     AFNetworkReachabilityStatusReachableViaWiFi = 2,   // 局域网络,不花钱
     */
    // 如果要检测网络状态的变化,必须用检测管理器的单例的startMonitoring
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    // 检测网络连接的单例,网络变化时的回调方法
    _isreach = NO;
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        if (status == AFNetworkReachabilityStatusNotReachable || status == AFNetworkReachabilityStatusUnknown) {
            [ResponseModel showInfoWithString:@"您的网络似乎有点问题"];
            _isreach = YES;
        }else{
            if (_isreach) {
                [ResponseModel showInfoWithString:@"已经连上网络"];
            }
        }
    }];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    [application setApplicationIconBadgeNumber:0];
    [application cancelAllLocalNotifications];
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
    // Required
    [APService registerDeviceToken:deviceToken];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    
    // Required
    [APService handleRemoteNotification:userInfo];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    
    
    // IOS 7 Support Required
    [APService handleRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    if ([url.host isEqualToString:@"safepay"]) {
        [[AlipaySDK defaultService]
         processOrderWithPaymentResult:url
         standbyCallback:^(NSDictionary *resultDic) {
             NSLog(@"resultdic = %@", resultDic);
             self.isSuccessedCharge = NO;
             if ([[resultDic objectForKey:@"resultStatus"] integerValue] == 9000) {
                 self.isSuccessedCharge = YES;
                 [ResponseModel showInfoWithString:@"付款成功!"];
             }
             if ([[resultDic objectForKey:@"resultStatus"] integerValue] == 6001) {
                 [ResponseModel showInfoWithString:@"付款已取消!"];
             }
             if ([[resultDic objectForKey:@"resultStatus"] integerValue] == 4000) {
                 [ResponseModel showInfoWithString:@"支付失败!"];
             }
         }];
    }
    return  YES;
}

@end
