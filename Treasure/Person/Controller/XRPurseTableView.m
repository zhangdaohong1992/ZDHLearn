//
//  XRPurseTableView.m
//  Treasure
//
//  Created by 荣 on 15/10/27.
//  Copyright © 2015年 YDS. All rights reserved.
//

#import "XRPurseTableView.h"
#import "XRPursrHeadView.h"
#import "XRPurseCell.h"
#import "XRPurseModel.h"
#import "UIImage+XRImage.h"
#import "XRChargeViewController.h"
#import <MJRefresh/MJRefresh.h>
@interface XRPurseTableView ()<UINavigationControllerDelegate,UIGestureRecognizerDelegate,XRPurseHeadViewDelegate>

@property (nonatomic, weak) id<UIGestureRecognizerDelegate> popDelegate;

@property (nonatomic,assign)int Page;

@property (nonatomic,strong)NSMutableArray *modelArr;

@property (nonatomic,weak)XRPursrHeadView *headView;
@end

@implementation XRPurseTableView

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UILabel *label = [[UILabel alloc]init];
    label.text = @"我的钱包";
    [label setFont:[UIFont systemFontOfSize:18]];
    [label setTextColor:[UIColor whiteColor]];
    [label sizeToFit];
    [self.navigationItem setTitleView:label];
    [self setupHeadView];
    self.navigationController.delegate = self;
    _popDelegate = self.navigationController.interactivePopGestureRecognizer.delegate;
    [self setupTableView];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav-5"] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    _Page = 1;
    [self.network postWithParameter:@{COOKIE:USER_COOKIE,@"page":@(_Page)} method:getIncomeBills];
    NSDictionary *cookiePara = @{COOKIE:USER_COOKIE};
    [self.network postWithParameter:cookiePara method:queryMoney];

}

#pragma mark - 初始化界面
-(void)setupHeadView
{
    XRPursrHeadView *headView = [[XRPursrHeadView alloc]initWithFrame:CGRectMake(0, 0, self.tableView.width, 200)];
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.tableView.tableHeaderView = headView;
    [headView addSubviewWithBalanceCount:_balanceCount];
    headView.delegate = self;
    self.headView = headView;
}
-(void)setupTableView
{
    self.noMoreDataLabel.y = self.view.centerY  - self.headView.height * 0.5 + 25;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    // 告诉tableView所有cell的估算高度
    self.tableView.estimatedRowHeight = 60;
    
    //上拉加载
    self.tableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        _Page++;
        [self.network postWithParameter:@{COOKIE:USER_COOKIE,@"page":@(_Page)} method:getIncomeBills];
        [self.tableView.footer endRefreshing];
    }];
    
    self.tableView.tableFooterView = [UIView new];
    
    [self.view insertSubview:self.tableView.header belowSubview:self.headView];
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    self.noMoreDataLabel.hidden = self.modelArr.count ? YES : NO;
    return self.modelArr.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"purseCell";
    XRPurseCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[NSBundle mainBundle]loadNibNamed:NSStringFromClass([XRPurseCell class]) owner:self options:nil][0];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.model = self.modelArr[indexPath.row];
    return cell;
}
#pragma mark - 网络处理
-(void)successfulWithDic:(NSDictionary *)dic method:(NSString *)method
{
    if ([method isEqualToString:getIncomeBills]) {
        if ([self isPostSuccessedWithDic:dic]) {
            if (_Page == 1) {
                [self.modelArr removeAllObjects];
            }
            NSArray * arr = [XRPurseModel objectArrayWithKeyValuesArray:dic[DIC_DATA][@"list"]];
            if (arr.count) {
                [self.modelArr addObjectsFromArray:arr];
            }else{
                [self.tableView.footer noticeNoMoreData];
            }
            [self.tableView reloadData];
        }
    }
    if ([method isEqualToString:queryMoney]) {
        if ([self isPostSuccessedWithDic:dic]) {
            self.headView.balanceLabel.text = [NSString stringWithFormat:@"%@", dic[DIC_DATA][@"money"]];
        }
    }
    [self endRefreshing];
}

- (void)endRefreshing
{
    if ([self.tableView.footer isRefreshing]) {
        [self.tableView.footer endRefreshing];
    }
    if ([self.tableView.header isRefreshing]) {
        [self.tableView.header endRefreshing];
    }
}

-(void)didClickChargeBtn:(XRPursrHeadView *)headView
{
    [self.navigationController pushViewController:[[XRChargeViewController alloc]init] animated:YES];
}

-(NSMutableArray *)modelArr
{
    if (!_modelArr) {
        _modelArr = [NSMutableArray array];
    }
    return _modelArr;
}

@end
