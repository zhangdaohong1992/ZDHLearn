//
//  XRPersonalViewController.m
//  Treasure
//
//  Created by 荣 on 15/10/26.
//  Copyright © 2015年 YDS. All rights reserved.
//

#import "XRPersonalViewController.h"
#import "XRPurseTableView.h"
#import "XRWinRecordViewController.h"
#import "XRPreWinTableView.h"
#import "PersonShareViewController.h"
#import "XRPersonDataTableView.h"
#import "XRUserInfo.h"
#import "RootVCHandle.h"
#import "UIImage+XRImage.h"
#import <AFNetworking/UIImageView+AFNetworking.h>
#import "WebViewController.h"

static NSString *push2Message = @"personMes";
static NSString *push2Setting = @"setting";
static NSString *push2MyShare = @"myshare";
static NSString *push2WebView = @"personaldelegate";
typedef enum
{
    kGold,/** 我的钱包 */
    kRecord,/** 夺宝记录 */
    kWinning,/** 中奖纪录 */
    kshare,/** 我的分享 */
    kpersonaldelegate
}selectRow;
@interface XRPersonalViewController ()
@property (weak, nonatomic) IBOutlet UILabel *nickNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
@property (weak, nonatomic) IBOutlet UIImageView *headImageV;
@property (strong,nonatomic) XRUserInfo *userInfoModel;
@property (strong, nonatomic) IBOutlet UITableViewCell *delegateCell;

@end

@implementation XRPersonalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _headImageV.layer.cornerRadius = _headImageV.width * 0.5;
    [self setupGesture];
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    [_nickNameLabel addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(push2PersonMessage)]];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav-5"] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    UIButton *settingBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 22, 22)];
    [settingBtn setImage:[UIImage imageNamed:@"setting"] forState:UIControlStateNormal];
    [settingBtn addTarget:self action:@selector(push2Setting) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc]initWithCustomView:settingBtn]];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];

    UIImage *selfPhoto = [RootVCHandle getCacheImage];
    self.headImageV.image = selfPhoto ? : [UIImage imageNamed:@"head"];
    
    if (USER_COOKIE){
        NSDictionary *cookiePara = @{COOKIE:USER_COOKIE};
        [self.network postWithParameter:cookiePara method:queryMoney];
        _nickNameLabel.userInteractionEnabled = NO;
        [self.network postWithParameter:cookiePara method:getUserInfo];
        BOOL res = [[[[NSUserDefaults standardUserDefaults] objectForKey:MODE] stringValue] isEqualToString:@"0"];
        self.delegateCell.hidden = res;
    }else{
        _nickNameLabel.text = @"立即登录";
        _moneyLabel.text = @"￥--";
        _nickNameLabel.userInteractionEnabled = YES;
    }
    if (USER_NICKNAME) {
        _nickNameLabel.text = USER_NICKNAME;
    }
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:UIColorFromRGB(0xff4640)] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
}

-(void)setupGesture
{
    UITapGestureRecognizer *tapImage = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(push2PersonMessage)];
    [_headImageV addGestureRecognizer:tapImage];
}

-(void)push2PersonMessage
{
    if (!USER_COOKIE) {
        [self login];
        return;
    }
    [self performSegueWithIdentifier:push2Message sender:nil];
}

-(void)push2Setting
{
    if (!USER_COOKIE) {
        [self login];
        return;
    }
    [self performSegueWithIdentifier:push2Setting sender:nil];
}

#pragma mark - UITabelViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!USER_COOKIE){
        [self login];
        return;
    }
    if (!USER_ID) {
        return;
    }
    if (indexPath.row == kGold) {
        XRPurseTableView *purse = [[XRPurseTableView alloc]init];
        purse.balanceCount = _moneyLabel.text;
        [self hideBottomBarWhenPushViewController:purse];
    }
    if (indexPath.row == kRecord) {
        [self hideBottomBarWhenPushViewController:[[XRWinRecordViewController alloc]init]];
    }
    if (indexPath.row == kWinning) {
         [self hideBottomBarWhenPushViewController:[[XRPreWinTableView alloc]init]];
    }
    if (indexPath.row == kshare) {
        [self performSegueWithIdentifier:push2MyShare sender:self];
    }
    if (indexPath.row == kpersonaldelegate) {
        [self performSegueWithIdentifier:push2WebView sender:self];
    }
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:push2Message]) {
        XRPersonDataTableView *vc = segue.destinationViewController;
        vc.userInfo = self.userInfoModel;
    }
    if ([segue.identifier isEqualToString:push2MyShare]) {
        PersonShareViewController * shareVC = [segue destinationViewController];
        shareVC.hidesBottomBarWhenPushed = YES;
        shareVC.type = 2;
        shareVC.userID = USER_ID;
    }
    if ([segue.identifier isEqualToString:push2WebView]) {
        WebViewController * webVC = [segue destinationViewController];
        webVC.url = loginInvite;
        webVC.bodyString = [NSString stringWithFormat:@"%@=%@", COOKIE, USER_COOKIE];
    }
}
-(void)hideBottomBarWhenPushViewController:(UIViewController *)vc
{
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark - 网络请求
-(void)successfulWithDic:(NSDictionary *)dic method:(NSString *)method
{
//获取金额
    if ([method isEqualToString:queryMoney]) {
        if ([self isPostSuccessedWithDic:dic]) {
            _moneyLabel.text = [NSString stringWithFormat:@"￥%@",dic[DIC_DATA][@"money"]];
        }
    }
//获取用户信息
    if ([method isEqualToString:getUserInfo]) {
        if ([self isPostSuccessedWithDic:dic]) {
            XRUserInfo *userInfo = [XRUserInfo objectWithKeyValues:dic[DIC_DATA][@"userInfo"]];
            self.userInfoModel = userInfo;
            _nickNameLabel.text = userInfo.nickName;
            __weak XRPersonalViewController * wself = self;
            [self.headImageV setImageWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:userInfo.headImgUrl]] placeholderImage:[UIImage imageNamed:@"head"] success:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nonnull response, UIImage * _Nonnull image) {
                [RootVCHandle saveIconImage:image];
                wself.headImageV.image = image;
            } failure:nil];
            [[NSUserDefaults standardUserDefaults] setObject:userInfo.Id forKey:@"userId"];
            [[NSUserDefaults standardUserDefaults] setObject:userInfo.nickName forKey:@"nickName"];
            [[NSUserDefaults standardUserDefaults] setObject:userInfo.phone forKey:USER_PHONE];
        }
    }
    
}

@end
