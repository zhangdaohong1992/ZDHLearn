//
//  PayViewController.m
//  Treasure
//
//  Created by 苹果 on 15/11/4.
//  Copyright © 2015年 YDS. All rights reserved.
//

#import "PayViewController.h"
#import "ShoppingTableViewController.h"
#import <AlipaySDK/AlipaySDK.h>
#import "Order.h"
#import "DataSigner.h"
#import "PaySuccessViewController.h"
#import "PaySuccessModel.h"
#import "AppDelegate.h"
#import "WXApi.h"
@interface PayViewController ()<UITableViewDelegate,UITableViewDataSource>
{    BOOL isSelect;
}
@property (nonatomic, assign) NSInteger money;
@property (nonatomic, assign) NSInteger chargeCount;
@property (weak, nonatomic) IBOutlet UITableView *chargeTabview;

@end

@implementation PayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.network postWithParameter:@{@"cookie" : USER_COOKIE} method:queryMoney isHud:YES];
    
    self.needCountLabel.text = [NSString stringWithFormat:@"￥%@", @(self.payCount)];
    self.sureButton.layer.masksToBounds = YES;
    self.sureButton.layer.cornerRadius = 5.;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(chargeSuccess) name:UIApplicationDidBecomeActiveNotification object:nil];
    self.chargeTabview.delegate = self;
    self.chargeTabview.dataSource = self;
    self.chargeTabview.scrollEnabled = NO;
    self.chargeTabview.backgroundColor = self.view.backgroundColor;
    self.chargeTabview.tableFooterView = [UIView new];
    
    // Do any additional setup after loading the view.
}

- (void)chargeSuccess
{
    AppDelegate * delgate = [[UIApplication sharedApplication] delegate];
    if (delgate.isSuccessedCharge) {
        [self sureOrder];
    }
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidBecomeActiveNotification object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)sureButtonMethod:(id)sender
{
// /*
  if (self.chargeCount > 0) {
        BOOL res = [[[[NSUserDefaults standardUserDefaults] objectForKey:MODE] stringValue] isEqualToString:@"0"];
        if (res) {//显示网页支付
            [self.network postWithParameter:@{COOKIE : USER_COOKIE,@"itemTermIds" : _itemString, @"joinCounts" : _joinCountString} method:aliReq];
            return;
        }
      if (!isSelect) {
          
           [self charge];
      }else{
          if([WXApi isWXAppInstalled]){// 判断 用户是否安装微信
          
              [self weiXinCharge];
          }else [ResponseModel showInfoWithString:@"未安装微信!"];return;
      }
      
    }else{
        [self sureOrder];
    }
 // */
    
    
}


- (void)sureOrder
{
    if (self.joinCountString.length && self.itemString.length) {
        [self.network postWithParameter:@{@"itemTermIds" : _itemString, @"joinCounts" : _joinCountString, @"cookie" : USER_COOKIE} method:payItemTerms isHud:YES];
    }
}

//alipay payment
- (void)charge
{
    NSString *partner = @"2088811474067233";
    NSString *seller = @"youdian2016@163.com";
    NSString *private = @"MIICdgIBADANBgkqhkiG9w0BAQEFAASCAmAwggJcAgEAAoGBAOKQJX8Jtk4edsFCWCrzUkS0UOGgk4N6IdbaR8M4ZCWyJYEad/dTf+nFZtsxXZZCpKYQUbBuHoSbI3OI9voJTSA5vVMMP6qXaqtteAnUuTUO+KXxjdbzUKQOmAx1TU/1s7eptrFtrvIFW5RscFFKfaHdsoSPMknKoxwJrI65iWlJAgMBAAECgYB+FapIYKdMIjgEpV9bx73o7lB0wGBXswhSAXgedKuHLvUgPBK3WYi+GFV9dqOWk8/9eud7QE1LjurTyU1pKPP6BxbnsPvTFQMMfeesVXB1NazeEXq286+jgOyi0IhDx9/tGrFsfgIp746u/IIhLJI9MiNblSddIA3tevMUKh6oAQJBAPMapI0ugy1rVQtYTP5c8+t4kgeu8LiuSSVerZVqpVwCZioofvxpLVTNV4LgOXVyka0dOn0mhf/m+dRD0cjT6OECQQDulOBqtw559TgqnawfxkCIup5ly0yM6GIYORBH28kXHJdVc4e+Cuu0JSFgCYLsqNb+4ljHZfx0PQVzynMs4oVpAkBDs1i+BIT9ghWF+ko+0A4Rtlscjqh1FfxCzvISWUfBrt1awjpS+stoAWNsjBsUTRqqligysCbDFETgyx5CClmhAkAAkWInXuAt8iN8Fnv+Z15n9OnDnERGYZc6L4iWYzOLVooVrfy4uxXsi9oUfHFPVueMG8XSU6/SJwMIT4cOqEthAkEA599ZgCX6HxVQWs0dsk14g4q0I4zQncFdfxh/RXiro9OqF7FIyhtnMNEltPRRIUmofTB0pzWL85qiqKxZk2NxXQ==";
    NSString * privateKey = [private stringByReplacingOccurrencesOfString:@" " withString:@""];
    Order * order = [[Order alloc] init];
    order.partner = partner;
    order.seller = seller;
    order.productName = @"充值";
    order.tradeNO = [self getTradeNumber];
    NSLog(@"tradeNumber = %@", order.tradeNO);
    order.amount = [NSString stringWithFormat:@"%.2f", (CGFloat)self.chargeCount];
//    order.amount = @"0.01";
    order.notifyURL = [NSString stringWithFormat:@"%@%@", BASE_URL, alipay];
    
    order.service = @"mobile.securitypay.pay";
    order.paymentType = @"1";
    order.inputCharset = @"utf-8";
    order.itBPay = @"30m";
    order.showUrl = @"m.alipay.com";
    NSString *appScheme = @"treasure";
    NSString * orderDes = [order description];
    NSLog(@"order = %@", orderDes);
    id<DataSigner> signer = CreateRSADataSigner(privateKey);
    NSString *signedString = [signer signString:orderDes];
    //将签名成功字符串格式化为订单字符串,请严格按照该格式
    NSString *orderString = nil;
    if (signedString != nil) {
        orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",
                       orderDes, signedString, @"RSA"];
        [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
            NSLog(@"reslut = %@",resultDic);
            //H5 Callback
            if ([[resultDic objectForKey:@"resultStatus"] integerValue] == 9000) {
                [ResponseModel showInfoWithString:@"付款成功!"];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self sureOrder];
                });
            }
            if ([[resultDic objectForKey:@"resultStatus"] integerValue] == 6001) {
                [ResponseModel showInfoWithString:@"付款已取消!"];
//                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                    [self.shopVc deleteAllInSql];
//                });
            }
            if ([[resultDic objectForKey:@"resultStatus"] integerValue] == 4000) {
                [ResponseModel showInfoWithString:@"支付失败!"];
            }
        }];
    }
}

- (void)weiXinCharge
{
    //    NSMutableString * signParams = [dataDic objectForKey:@"timestamp"];
    PayReq* req             = [[PayReq alloc] init];
    req.openID              = @"wxd678efh567hg6787";
    req.partnerId           = @"1900000109";
    req.prepayId            = @"WX1217752501201407033233368018";
    req.nonceStr            = @"5K8264ILTKCH16CQ2502SI8ZNMTM67VS";
    NSTimeInterval time = [[NSDate date] timeIntervalSince1970];
    
    long long int date = (long long int)time;
    
    NSString * timeStr = [NSString stringWithFormat:@"%lld",date];
    req.timeStamp      = [timeStr intValue];
    req.package             = @"Sign=WXPay";//[dataDic objectForKey:@"package"];
    req.sign                = @"C380BEC2BFD727A4B6845133519F3AD6";
    
    [WXApi sendReq:req];
    
}


- (NSString *)getTradeNumber
{
    UInt64 recordTime = [[NSDate date] timeIntervalSince1970] * 1000;
    NSLog(@"reco %llu", recordTime);
    return [NSString stringWithFormat:@"%@-%@", [NSNumber numberWithLongLong:recordTime], USER_COOKIE];
}

- (void)successfulWithDic:(NSDictionary *)dic method:(NSString *)method
{
    if ([method isEqualToString:payItemTerms]) {
        [ResponseModel showInfoWithString:dic[DIC_INFO]];
        if ([self isPostSuccessedWithDic:dic]) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.shopVc deleteAllInSql];
                PaySuccessViewController *payVC = [[PaySuccessViewController alloc]init];
                payVC.modelArr = [PaySuccessModel objectArrayWithKeyValuesArray:dic[DIC_DATA][@"list"]];
                [self.navigationController pushViewController:payVC animated:YES];
            });
        }
    }
    if ([method isEqualToString:queryMoney]) {
        if ([self isPostSuccessedWithDic:dic]) {
            self.money = [dic[DIC_DATA][@"money"] integerValue];
            if (self.payCount <= self.money) {
                self.otherPayBackView.hidden = YES;
                self.alipayBackView.hidden = YES;
                self.chargeTabview.hidden = YES;
                
                
                self.sureButtonTop.constant = 160;
            }else{
                self.chargeCount = self.payCount - self.money;
                self.alipayNeedCountLabel.text = [NSString stringWithFormat:@"￥%@", @(self.chargeCount)];
            }
            self.restCountLabel.text = [NSString stringWithFormat:@"￥%@", @(self.money)];
        }
    }
    if ([method isEqualToString:aliReq]) {
        if ([self isPostSuccessedWithDic:dic]) {
            [self.navigationController popToRootViewControllerAnimated:YES];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:dic[DIC_DATA][@"alipay_url"]]];
        }
    }

}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
     BOOL res = [[[[NSUserDefaults standardUserDefaults] objectForKey:MODE] stringValue] isEqualToString:@"0"];
    return res ? 1 : 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc]init];
    if (IS_IOS_8) {
        cell.preservesSuperviewLayoutMargins = NO;
        cell.layoutMargins = UIEdgeInsetsZero;
        cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    }

    cell.imageView.image = [UIImage imageNamed:@"zhifubao"];
    if (indexPath.row == 0) {
        cell.textLabel.text = @"支付宝";
    }else cell.textLabel.text = @"微信支付";
    
    UIImageView *imgV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 15, 20, 20)];
    imgV.image = [UIImage imageNamed:@"no-selected"];
    if (indexPath.row == isSelect) {
        
        imgV.image = [UIImage imageNamed:@"indent_select"];
    }
    cell.accessoryView = imgV;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    isSelect = indexPath.row;
    [tableView reloadData];
    
}
@end
