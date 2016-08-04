//
//  XRPreWinTableView.m
//  Treasure
//
//  Created by 荣 on 15/10/29.
//  Copyright © 2015年 YDS. All rights reserved.
//

#import "XRPreWinTableView.h"
#import "XRRewardCell.h"
#import "XRRewardModel.h"
#import "UIColor+XRAdditions.h"
#import "UIImage+XRImage.h"
#import "XRAddAdressViewController.h"
#import "XRSharePostViewController.h"
#import <MJRefresh/MJRefresh.h>
#import "WinDetailViewController.h"

#define  CELL_TEXT cell.sureAddBtn.titleLabel.text
@interface XRPreWinTableView ()<rewardCellDelegate>

@property(nonatomic,strong)NSMutableArray *modelArr;

@property(nonatomic,assign)int page;
@end

@implementation XRPreWinTableView

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    // 告诉tableView所有cell的估算高度
    self.tableView.estimatedRowHeight = 60;
    [self.navigationItem setTitle:@"中奖纪录"];
    [self pushRefresh];
    [self pullRefresh];
    self.tableView.tableFooterView = [UIView new];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.tableView.header beginRefreshing];
}

#pragma mark - 上下拉刷新
-(void)pushRefresh
{
    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self reloadNewModel];
    }];
    self.tableView.header.automaticallyChangeAlpha = YES;
}
-(void)pullRefresh
{
    self.tableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        _page++;
        [self.network postWithParameter:@{COOKIE:USER_COOKIE,@"page":@(_page)} method:getLuckyRecords];
    }];
}
-(void)reloadNewModel{
    [self.modelArr removeAllObjects];
    _page = 1;
    [self.network postWithParameter:@{COOKIE:USER_COOKIE,@"page":@(_page)} method:getLuckyRecords];
}
#pragma mark - UITableVieDataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
     self.noMoreDataLabel.hidden = self.modelArr.count ? YES : NO;
    return self.modelArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    XRRewardCell *cell = [tableView dequeueReusableCellWithIdentifier:@"reward"];
    if (!cell) {
        cell = [[NSBundle mainBundle]loadNibNamed:NSStringFromClass([XRRewardCell class]) owner:self options:nil][0];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.delegate = self;
    }
    cell.model = self.modelArr[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    WinDetailViewController * winDetailVC = [WinDetailViewController new];
    XRRewardModel * model = self.modelArr[indexPath.row];
    winDetailVC.model = model;
    [self.navigationController pushViewController:winDetailVC animated:YES];
}

#pragma mark - 网络数据
-(void)successfulWithDic:(NSDictionary *)dic method:(NSString *)method
{
    if ([method isEqualToString:getLuckyRecords]) {
        if ([self isPostSuccessedWithDic:dic]) {
            NSArray * arr = [XRRewardModel objectArrayWithKeyValuesArray:dic[DIC_DATA][@"list"]];
            if (arr.count) {
                [self.modelArr addObjectsFromArray:arr];
            }else{
                [self endRefreshing];
                [self.tableView.footer noticeNoMoreData];
            }
        }
        [self.tableView reloadData];
    }
    if ([method isEqualToString:confirmOrder]) {
        [ResponseModel showInfoWithString:dic[DIC_INFO]];
        if ([self isPostSuccessedWithDic:dic]) {
            [self reloadNewModel];
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

-(NSMutableArray *)modelArr
{
    if (!_modelArr) {
        _modelArr = [NSMutableArray array];
    }
    return _modelArr;
}

#pragma mark - cellBtn 点击响应
-(void)rewardCellBtnClick:(XRRewardCell *)cell
{
    if ([CELL_TEXT containsString:@"确认地址"]) {
        XRAddAdressViewController * addVC = [[XRAddAdressViewController alloc]init];
        addVC.ID = cell.model.ID;
        [self.navigationController pushViewController:addVC animated:YES];
    }
    else if([CELL_TEXT containsString:@"确认收货"]){
        [self.network postWithParameter:@{COOKIE:USER_COOKIE,@"orderId":cell.model.ID} method:confirmOrder];
    }
    else if ([CELL_TEXT containsString:@"去晒单"]){
        XRSharePostViewController *vc = [[XRSharePostViewController alloc]init];
        vc.orderId = cell.model.ID;
        [self.navigationController pushViewController:vc animated:YES];
    }
}
@end
