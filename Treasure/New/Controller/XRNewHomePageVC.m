//
//  XRNewHomePageVC.m
//  Treasure
//
//  Created by 荣 on 15/10/26.
//  Copyright © 2015年 YDS. All rights reserved.
//

#import "XRNewHomePageVC.h"
#import "XRIssueCellModel.h"
#import "XRNewCell.h"
#import <MJExtension/MJExtension.h>
#import <MJRefresh/MJRefresh.h>


static  NSString  *newCellIdentifier = @"newCell";

@interface XRNewHomePageVC ()<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,strong)NSMutableArray *modelArr;/** cell的模型数组 */
@property(nonatomic,weak)UITableView *tableView;
@property(nonatomic,assign)NSInteger pageCount;
@end

@implementation XRNewHomePageVC

- (void)viewDidLoad  {
    [super viewDidLoad];
    //设置tableView
    [self setUpTableView];
    
}

-(void)setUpTableView
{
    UITableView *tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    [self.view addSubview:tableView];
    tableView.contentInset = UIEdgeInsetsMake(64, 0, 0, 0);
    tableView.dataSource = self;
    tableView.delegate = self;
    
    self.tableView  = tableView;
    
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    // 告诉tableView所有cell的估算高度
    self.tableView.estimatedRowHeight = 100;
    
    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshTableView)];
    self.tableView.footer = [MJRefreshFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMore)];
    [self refreshTableView];
}
#pragma mark - 获取数据
-(void)refreshTableView
{
    _pageCount = 0;
    //移除数组内模型
    [self.modelArr removeAllObjects];
    NSDictionary *para = @{@"page":@(_pageCount)};
    [self.network postWithParameter:para method:getNewTerms];
}
-(void)loadMore
{
    _pageCount++;
    NSDictionary *para = @{@"page":@(_pageCount)};
    [self.network postWithParameter:para method:getNewTerms];
}
#pragma mark - UITableViewDataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.modelArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    XRIssueCellModel *model = self.modelArr[indexPath.row];
    XRNewCell *cell = [tableView dequeueReusableCellWithIdentifier:newCellIdentifier];
            if (!cell) {
                cell = [[NSBundle mainBundle]loadNibNamed:NSStringFromClass([XRNewCell class]) owner:self options:nil].lastObject;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            cell.model = model;
            return cell;
 
}

#pragma mark - UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

}

#pragma mark - BaseNetworkDelegate
-(void)successfulWithDic:(NSDictionary *)dic method:(NSString *)method
{
    if ([method isEqualToString:getNewTerms]) {
        if ([self isPostSuccessedWithDic:dic]) {
            NSDictionary *listDic = dic[DIC_DATA][@"list"];
            //字典数组转模型数组
            NSMutableArray *responseDataArr = [XRIssueCellModel objectArrayWithKeyValuesArray:listDic];
            //添加到模型数组中
            [self.modelArr addObjectsFromArray:responseDataArr];
            [self endRefreshing];
            [self.tableView reloadData];
            
        }
    }
}
- (void)endRefreshing
{
    [self.tableView.header endRefreshing];
    [self.tableView.footer endRefreshing];
}
#pragma mark - lazyLoad
-(NSMutableArray *)modelArr
{
    if (!_modelArr) {
        _modelArr = [NSMutableArray array];
    }
    return _modelArr;
}
@end
