//
//  XRPersonSettingViewController.m
//  Treasure
//
//  Created by 荣 on 15/11/5.
//  Copyright © 2015年 YDS. All rights reserved.
//

#import "XRPersonSettingViewController.h"
#import "RootVCHandle.h"
#import "WebViewController.h"
#import "BackGrayView.h"

typedef enum : NSUInteger {
    setFeedBack = 0,
    setQuestion,
    setServiceDelegate,
    setNewHand,
    setAbout,
} setEnum;

@interface XRPersonSettingViewController ()

@property (nonatomic, assign) NSInteger selectIndex;
@property (nonatomic, strong) NSDictionary * dic;
@property (nonatomic, strong) BackGrayView * grayView;

@end

@implementation XRPersonSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.contentInset = UIEdgeInsetsMake(-36, 0, 0, 0);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0 ){
        if (indexPath.row == 0) {
            self.selectIndex = setFeedBack;
            [self performSegueWithIdentifier:@"settingDetail" sender:self];
        }else if (indexPath.row == 1){
            self.selectIndex = setQuestion;
            [self performSegueWithIdentifier:@"settingDetail" sender:self];
        }else if(indexPath.row == 2){
            [self.network postWithParameter:@{} method:queryServiceInfo isHud:YES];
        }else if (indexPath.row == 3){
            self.selectIndex = setServiceDelegate;
            [self performSegueWithIdentifier:@"settingDetail" sender:self];
        }else if (indexPath.row == 4){
            self.selectIndex = setNewHand;
            [self performSegueWithIdentifier:@"settingDetail" sender:self];
        }else if (indexPath.row == 5) {
            self.selectIndex = setAbout;
            [self performSegueWithIdentifier:@"settingDetail" sender:self];
        }
    }else if (indexPath.section == 1) {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:COOKIE];
        BOOL result = [RootVCHandle deleteCacheImage];
        NSLog(result ? @"删除头像成功" : @"删除头像失败");
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"nickName"];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:USER_ID];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"address"];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"area"];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"receiveName"];
        [ResponseModel showInfoWithString:@"退出登录成功!"];
        [self login];
    }
}

- (void)complainButtonMethod
{
    self.grayView = [[BackGrayView alloc] initWithFrame:CGRectMake(0, 0, VIEW_WIDTH, VIEW_HEIGHT + 64)];
    [[[UIApplication sharedApplication].delegate window] addSubview:_grayView];
    [_grayView.phoneButton setTitle:self.dic[@"serviceTel"] forState:UIControlStateNormal];
    [_grayView.qqButton setTitle:self.dic[@"serviceQQ"] forState:UIControlStateNormal];
    [_grayView.phoneButton addTarget:self action:@selector(callExpressMethod:) forControlEvents:UIControlEventTouchUpInside];
    // 未完待续
    [_grayView.qqButton addTarget:self action:@selector(callQQMethod) forControlEvents:UIControlEventTouchUpInside];
}

- (void)callQQMethod
{
    UIWebView * webView = [[UIWebView alloc] initWithFrame:CGRectZero];
    NSString * str = [NSString stringWithFormat:@"http://wpa.qq.com/msgrd?v=3&uin=%@&site=qq&menu=yes", self.dic[@"serviceQQ"]];
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
    [self.view addSubview:webView];
}

- (void)callExpressMethod:(UIButton *)btn
{
    NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",self.dic[@"serviceTel"]];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"settingDetail"]) {
        WebViewController * webVC = [segue destinationViewController];
        if (self.selectIndex == setFeedBack) {
            webVC.url = feedback;
            
            webVC.title = @"反馈与建议";
        }else if (self.selectIndex == setQuestion){
            webVC.url = question;
            webVC.title = @"常见问题";
        }else if(self.selectIndex == setServiceDelegate){
            webVC.url = serviceAgreement;
            webVC.title = @"服务协议";
        }else if(self.selectIndex == setNewHand){
            webVC.url = userGuide;
            webVC.title = @"新手指南";
        }else if(self.selectIndex == setAbout){
            webVC.url = aboutUs;
            webVC.title = @"关于";
        }

    }
}

#pragma mark - BaseNetWorkModelDelegate
- (void)successfulWithDic:(NSDictionary *)dic method:(NSString *)method
{
    if ([self isPostSuccessedWithDic:dic]) {
        self.dic = dic[DIC_DATA];
        [self complainButtonMethod];
    }
}

@end
