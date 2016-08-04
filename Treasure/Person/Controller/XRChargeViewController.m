//
//  XRChargeViewController.m
//  Treasure
//
//  Created by 荣 on 15/10/29.
//  Copyright © 2015年 YDS. All rights reserved.
//

#import "XRChargeViewController.h"
#import "XRChargeBtn.h"
#import "UIImage+XRImage.h"
#import <AlipaySDK/AlipaySDK.h>
#import "Order.h"
#import "DataSigner.h"
#import "AppDelegate.h"
#import "WXApi.h"

#define kMargin 15
#define KcellMargin 22.5
#define NUMBERS @"0123456789"


@interface XRChargeViewController ()<UITextFieldDelegate,UIActionSheetDelegate>
{
    BOOL isSelect;
    UIButton *chargeNow;
}
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (nonatomic,strong)NSMutableArray *btnArr;
@property (weak,nonatomic)UITextField *field;

@property (weak, nonatomic) IBOutlet UIView *displayView;
@property (weak, nonatomic) IBOutlet UITableView *tabViewCharge;

@end

@implementation XRChargeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:@"充值"];
    [self setupContentView];
    [self selectBtn:self.btnArr[0]];
    self.tabViewCharge.scrollEnabled = NO;
    isSelect = 0;
//    [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:MODE];
    NSLog(@"mode=== %@",[[NSUserDefaults standardUserDefaults] objectForKey:MODE]);
    self.tabViewCharge.tableFooterView = [UIView new];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(chargeSuccess) name:UIApplicationDidBecomeActiveNotification object:nil];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:UIColorFromRGB(0xff4640)] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
}

- (void)chargeSuccess
{
    AppDelegate * delgate = [[UIApplication sharedApplication] delegate];
    if (delgate.isSuccessedCharge) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidBecomeActiveNotification object:nil];
}

#pragma mark - 设置view内容
-(void)setupContentView
{
    NSArray *titleArr = @[@"5元",@"10元",@"15元",@"50元",@"100元",@"其他金额"];
    CGFloat btnW = (VIEW_WIDTH - 2 * (kMargin + KcellMargin))/ 3;
    CGFloat btnH = btnW * 0.36;
    
    for (int i = 0; i<titleArr.count; i++) {
        CGFloat btnY = 10 + i/3 * (KcellMargin + btnH);
        CGFloat btnX = kMargin + i%3 * (KcellMargin + btnW);
        XRChargeBtn *btn = [[XRChargeBtn alloc]initWithFrame:CGRectMake(btnX, btnY, btnW, btnH)];
        [btn addTarget:self action:@selector(selectBtn:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag = i;
        [btn setTitle:titleArr[i] forState:UIControlStateNormal];
        if (i == 5) {
            [self otherMoneyAddField:btn];
        }
        [self.contentView addSubview:btn];
        
        [self.btnArr addObject:btn];
    }
    
    CGFloat chargeBtnW = 200;
    CGFloat chargeBtnH = 36;
    CGFloat chargeBtnX = 0.5 *(VIEW_WIDTH - chargeBtnW);
    UIButton *btn = self.btnArr.lastObject;
    CGFloat chargeBtnY = CGRectGetMaxY(btn.frame) + 280;
    chargeNow = [[UIButton alloc]initWithFrame:CGRectMake(chargeBtnX, chargeBtnY, chargeBtnW, chargeBtnH)];
    [chargeNow.titleLabel setFont:[UIFont systemFontOfSize:18]];
    [chargeNow setBackgroundColor:UIColorFromRGB(0xff9500)];
    [chargeNow setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateNormal];
    chargeNow.layer.cornerRadius = 4;
    [chargeNow setTitle:@"立即充值" forState:UIControlStateNormal];
//    [self.contentView addSubview:chargeBtn];
    [self.view addSubview:chargeNow];
    
    [chargeNow addTarget:self action:@selector(callBackChargeNowMethod) forControlEvents:UIControlEventTouchUpInside];
}
-(void)selectBtn:(XRChargeBtn *)btn
{
    for (XRChargeBtn *btn in self.btnArr) {
        btn.selected = NO;
        btn.layer.borderColor = UIColorFromRGB(0x78909c).CGColor;
    }
    btn.selected = YES;
    btn.layer.borderColor = UIColorFromRGB(0xff4640).CGColor;
    if (btn.tag == 5) {
        [btn setTitle:@"" forState:UIControlStateNormal];
        btn.layer.borderColor = UIColorFromRGB(0xff4640).CGColor;
        [_field becomeFirstResponder];
        self.field.hidden = NO;
    }
    else
    {
        UIButton *btn = self.btnArr[5];
        [btn endEditing:YES];
        [btn setTitle:@"其他金额" forState:UIControlStateNormal];
        self.field.hidden = YES;
    }
}
-(void)otherMoneyAddField:(UIButton *)btn
{
    
    UITextField *field = [[UITextField alloc]initWithFrame:btn.bounds];
    field.placeholder = @"请输入金额";
    field.font = [UIFont systemFontOfSize:13];
    self.field = field;
    field.delegate = self;
    field.keyboardType = UIKeyboardTypeDecimalPad;
    field.textAlignment = NSTextAlignmentCenter;
    [btn addSubview:field];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSCharacterSet * set = [[NSCharacterSet characterSetWithCharactersInString:NUMBERS] invertedSet];
    NSString*filtered = [[string componentsSeparatedByCharactersInSet:set] componentsJoinedByString:@""];
    BOOL basicTest = [string isEqualToString:filtered];
    if (!basicTest) {
        return NO;
    }
    return YES;
}

#pragma mark - 点击立即充值以后

-(void)callBackChargeNowMethod
{
  NSInteger  intNum = isSelect;
    for (UIButton *btn in self.btnArr) {
        if (btn.isSelected) {
            NSMutableString *strM;
            CGFloat count;
            if (btn.tag == 5) {
                if (_field.text.length) {
                    strM = [NSMutableString stringWithString:self.field.text];
                    BOOL res = [[[[NSUserDefaults standardUserDefaults] objectForKey:MODE] stringValue] isEqualToString:@"0"];
                    if (res) {
                        [self.network postWithParameter:@{COOKIE : USER_COOKIE, @"money" : strM} method:recharge];
                        return;
                    }

                    count = [strM floatValue];
                    if (intNum == 0) {
                        
                        [self chargeWithCount:count];
                    }else if(intNum == 1){
                        [self weiXinChargeWithCount:count];
                    }
                    NSLog(@"%@",self.field.text);
                }else{
                    [SVProgressHUD showErrorWithStatus:@"请输入具体金额"];
                }
            }else{
                strM = [NSMutableString stringWithString:btn.titleLabel.text];
                [strM deleteCharactersInRange:NSMakeRange(strM.length - 1, 1)];
                BOOL res = [[[[NSUserDefaults standardUserDefaults] objectForKey:MODE] stringValue] isEqualToString:@"0"];
                if (res) {
                    [self.network postWithParameter:@{COOKIE : USER_COOKIE, @"money" : strM} method:recharge];
                    return;
                }
                count = [strM floatValue];
                
                if (intNum == 0) {
                    [self chargeWithCount:count];
                }else if(intNum == 1){
                    [self weiXinChargeWithCount:count];
                }

            }
        }
    }
}

- (void)weiXinChargeWithCount:(CGFloat)count
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

- (void)chargeWithCount:(CGFloat)count
{
    NSString *partner = @"2088811474067233";
    NSString *seller = @"youdian2016@163.com";
    NSString *private = @"MIICdgIBADANBgkqhkiG9w0BAQEFAASCAmAwggJcAgEAAoGBAOKQJX8Jtk4edsFCWCrzUkS0UOGgk4N6IdbaR8M4ZCWyJYEad/dTf+nFZtsxXZZCpKYQUbBuHoSbI3OI9voJTSA5vVMMP6qXaqtteAnUuTUO+KXxjdbzUKQOmAx1TU/1s7eptrFtrvIFW5RscFFKfaHdsoSPMknKoxwJrI65iWlJAgMBAAECgYB+FapIYKdMIjgEpV9bx73o7lB0wGBXswhSAXgedKuHLvUgPBK3WYi+GFV9dqOWk8/9eud7QE1LjurTyU1pKPP6BxbnsPvTFQMMfeesVXB1NazeEXq286+jgOyi0IhDx9/tGrFsfgIp746u/IIhLJI9MiNblSddIA3tevMUKh6oAQJBAPMapI0ugy1rVQtYTP5c8+t4kgeu8LiuSSVerZVqpVwCZioofvxpLVTNV4LgOXVyka0dOn0mhf/m+dRD0cjT6OECQQDulOBqtw559TgqnawfxkCIup5ly0yM6GIYORBH28kXHJdVc4e+Cuu0JSFgCYLsqNb+4ljHZfx0PQVzynMs4oVpAkBDs1i+BIT9ghWF+ko+0A4Rtlscjqh1FfxCzvISWUfBrt1awjpS+stoAWNsjBsUTRqqligysCbDFETgyx5CClmhAkAAkWInXuAt8iN8Fnv+Z15n9OnDnERGYZc6L4iWYzOLVooVrfy4uxXsi9oUfHFPVueMG8XSU6/SJwMIT4cOqEthAkEA599ZgCX6HxVQWs0dsk14g4q0I4zQncFdfxh/RXiro9OqF7FIyhtnMNEltPRRIUmofTB0pzWL85qiqKxZk2NxXQ==";
    NSString * privateKey = [private stringByReplacingOccurrencesOfString:@" " withString:@""];
    Order * order = [[Order alloc] init];
    order.inputCharset = @"utf-8";
    order.partner = partner;
    order.seller = seller;
    order.productName = @"充值";
    order.tradeNO = [self getTradeNumber];
    NSLog(@"tradeNumber = %@", order.tradeNO);
    order.amount = [NSString stringWithFormat:@"%.2f", count];
    order.notifyURL = [NSString stringWithFormat:@"%@%@", BASE_URL, alipay];
    
    order.service = @"mobile.securitypay.pay";//mobile.securitypay.pay
    order.paymentType = @"0";
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
            if ([[resultDic objectForKey:@"resultStatus"] integerValue] == 9000) {
                [ResponseModel showInfoWithString:@"付款成功!"];
                [self.navigationController popViewControllerAnimated:YES];
            }
            if ([[resultDic objectForKey:@"resultStatus"] integerValue] == 6001) {
                [ResponseModel showInfoWithString:@"付款已取消!"];
            }
            if ([[resultDic objectForKey:@"resultStatus"] integerValue] == 4000) {
                [ResponseModel showInfoWithString:@"支付失败!"];
            }
        }];
    }
}

- (NSString *)getTradeNumber
{
    UInt64 recordTime = [[NSDate date] timeIntervalSince1970] * 1000;
    NSLog(@"reco %llu", recordTime);
    return [NSString stringWithFormat:@"%@-%@", [NSNumber numberWithLongLong:recordTime], USER_COOKIE];
}

- (void)successfulWithDic:(NSDictionary *)dic method:(NSString *)method
{
    if ([method isEqualToString:recharge]) {
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


#pragma mark - lazy
-(NSMutableArray *)btnArr
{
    if (!_btnArr) {
        _btnArr = [NSMutableArray array];
    }
    return _btnArr;
}
@end
