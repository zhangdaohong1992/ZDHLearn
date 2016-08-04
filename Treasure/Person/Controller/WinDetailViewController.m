//
//  WinDetailViewController.m
//  Treasure
//
//  Created by 苹果 on 16/2/25.
//  Copyright © 2016年 YDS. All rights reserved.
//

#import "WinDetailViewController.h"
#import "XRRewardModel.h"
#import "UIImageView+AFNetworking.h"
#import "WinDetailModel.h"
#import "XRAddAdressViewController.h"

#define PlaceholderText @"暂无"

@interface WinDetailViewController ()
@property (strong, nonatomic) IBOutlet UIImageView *goodsIconImageView;
@property (strong, nonatomic) IBOutlet UILabel *goodsTitleLabel;
@property (strong, nonatomic) IBOutlet UILabel *luckyNumLabel;
@property (strong, nonatomic) IBOutlet UILabel *joinTimesLabel;
@property (strong, nonatomic) IBOutlet UILabel *timeLabel;
@property (strong, nonatomic) IBOutlet UILabel *expressCompanyLabel;
@property (strong, nonatomic) IBOutlet UILabel *expressNumberLabel;
@property (strong, nonatomic) IBOutlet UILabel *phoneLabel;
@property (strong, nonatomic) IBOutlet UILabel *addressLabel;
@property (strong, nonatomic) IBOutlet UIButton *addressButton;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;

@end

@implementation WinDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"中奖详情";
    
    [self setupHeaderView];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.network postWithParameter:@{COOKIE : USER_COOKIE, @"orderId":self.model.ID} method:getOrderInfo isHud:YES];
}

- (void)setupHeaderView
{
    [self.goodsIconImageView setImageWithURL:[NSURL URLWithString:self.model.picture] placeholderImage:[UIImage imageNamed:@"head_gray"]];
    self.goodsTitleLabel.text = [NSString stringWithFormat:@"[第%@期]%@", self.model.term, self.model.itemTitle];
    self.luckyNumLabel.text = self.model.luckyNum;
    self.joinTimesLabel.text = [NSString stringWithFormat:@"%@", @(self.model.joinCount)];
    self.timeLabel.text = self.model.openTime;
}

- (IBAction)addressButtonMethod:(id)sender {
    XRAddAdressViewController * addVC = [[XRAddAdressViewController alloc]init];
    addVC.ID = self.model.ID;
    [self.navigationController pushViewController:addVC animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)successfulWithDic:(NSDictionary *)dic method:(NSString *)method
{
    if ([method isEqualToString:getOrderInfo]) {
        if ([self isPostSuccessedWithDic:dic]) {
            WinDetailModel * model = [WinDetailModel objectWithKeyValues:dic[DIC_DATA][@"userOrder"]];
            self.expressCompanyLabel.text = model.expressCompany ? : PlaceholderText;
            self.expressNumberLabel.text = model.expressNum ? : PlaceholderText;
            self.phoneLabel.text = model.phone ? : PlaceholderText;
            self.addressLabel.text = model.address ? : PlaceholderText;
            self.nameLabel.text = model.receiveName ? : PlaceholderText;
            if (model.phone.length< 1 || model.receiveName.length < 1 || model.address.length < 1) {
                self.addressButton.hidden = NO;
            }else{
                self.addressButton.hidden = YES;
            }
        }
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
