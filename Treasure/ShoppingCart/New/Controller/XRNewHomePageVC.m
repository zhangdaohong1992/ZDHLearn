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
#import "XRNewDetailViewController.h"

static  NSString  *newCellIdentifier = @"newCell";

@interface XRNewHomePageVC ()<UITableViewDataSource,UITableViewDelegate,newCellDelegate>

@property(nonatomic,strong)NSMutableArray *modelArr;/** cell的模型数组 */

@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,assign)NSInteger pageCount;

@property(nonatomic,weak)XRNewCell *timeOutCell;/**< 时间到了的cell */
@property (nonatomic, strong) NSMutableArray * refreshCellArray;

@end

@implementation XRNewHomePageVC

- (void)viewDidLoad  {
    [super viewDidLoad];
    //设置tableView
    self.modelArr = [NSMutableArray array];
    self.refreshCellArray = [NSMutableArray array];
    [self setUpTableView];
    
}

-(void)setUpTableView
{
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, VIEW_WIDTH, VIEW_HEIGHT - 49 - 64) style:UITableViewStylePlain];
    [self.view addSubview:_tableView];
    
    _tableView.dataSource = self;
    _tableView.delegate = self;
    
    _tableView.tableFooterView = [UIView new];
    
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    // 告诉tableView所有cell的估算高度
    self.tableView.estimatedRowHeight = 100;
    
    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshTableView)];
    self.tableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.isTabBarSelected = YES;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (self.isTabBarSelected) {
        [self.tableView.header beginRefreshing];
    }
}

#pragma mark - 获取数据
-(void)refreshTableView
{
    _pageCount = 1;
    //移除数组内模型
    NSDictionary *para = @{@"page":@(_pageCount)};
    [self.network postWithParameter:para method:getNewTerms];
}
-(void)loadMoreData
{
    _pageCount++;
    NSDictionary *para = @{@"page":@(_pageCount)};
    [self.network postWithParameter:para method:getNewTerms];
}
#pragma mark - UITableViewDataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    self.noMoreDataLabel.hidden = self.modelArr.count ? YES : NO;
    return self.modelArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    XRNewCell *cell = [tableView dequeueReusableCellWithIdentifier:newCellIdentifier];
    if (!cell) {
        cell = [[NSBundle mainBundle]loadNibNamed:NSStringFromClass([XRNewCell class]) owner:self options:nil].lastObject;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.delegate = self;
    }
    XRIssueCellModel *model = self.modelArr[indexPath.row];
    cell.model = model;
    cell.model.cellRow = indexPath.row;
    return cell;
}

#pragma mark - XRNewCellDelgate
-(void)finshedCountDownTimer:(XRNewCell *)cell
{
    //发送网络请求
    self.timeOutCell = cell;
    [self.refreshCellArray addObject:cell];
    [self.network postWithParameter:@{@"itemTermId":@(cell.model.Id)} method:@"openLucky"];
}

#pragma mark - UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIStoryboard *sty = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    XRNewDetailViewController *vc = [sty instantiateViewControllerWithIdentifier:@"newDetail"];
    
    vc.homeVC = self;
    XRIssueCellModel *model = self.modelArr[indexPath.row];
    vc.itemId = [NSString stringWithFormat:@"%@",@(model.itemId)];
    vc.itemTermId = [NSString stringWithFormat:@"%@",@(model.Id)];
    vc.state = model.state;
    
    XRNewCell *tempCell = [tableView cellForRowAtIndexPath:indexPath];
    vc.downCount = tempCell.openTimeLabel.getTimeCounted;
    vc.hidesBottomBarWhenPushed = YES;
    
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - BaseNetworkDelegate
-(void)successfulWithDic:(NSDictionary *)dic method:(NSString *)method
{
    if ([method isEqualToString:getNewTerms]) {
        [self endRefreshing];
        if ([self isPostSuccessedWithDic:dic]) {
            NSLog(@"test begin");
            if (_pageCount == 1) {
                [self.modelArr removeAllObjects];
                [self.tableView.footer resetNoMoreData];
            }
            NSArray *list = dic[DIC_DATA][@"list"];
            //字典数组转模型数组
            NSMutableArray *responseDataArr = [XRIssueCellModel objectArrayWithKeyValuesArray:list];
            //添加到模型数组中
            if (responseDataArr.count) {
                NSMutableArray *willModelArr = [NSMutableArray array];
                NSMutableArray *didModelArr = [NSMutableArray array];
                for (XRIssueCellModel *model in responseDataArr) {
                    if (model.state == 1) {
                        [willModelArr addObject:model];
                    }else {
                        [didModelArr addObject:model];
                    }
                }
                
                if (willModelArr.count) {
                    [self.modelArr addObjectsFromArray:willModelArr];
                }
                if(didModelArr.count){
                    [self.modelArr addObjectsFromArray:didModelArr];
                }
            }else{
                [self.tableView.footer noticeNoMoreData];
            }
        }
        NSLog(@"test end");
        [self.tableView reloadData];
    }
    
    if ([method isEqualToString:@"openLucky"]) {
        if ([self isPostSuccessedWithDic:dic]) {
            XRIssueCellModel *cellModel = [XRIssueCellModel objectWithKeyValues:dic[DIC_DATA]];
            NSLog(@"%ld",(long)_timeOutCell.model.cellRow);
            cellModel.cellRow = _timeOutCell.model.cellRow;
            XRNewCell * cell = self.refreshCellArray.firstObject;
            [cell tableView:self.tableView refrshModel:cellModel];
            [self.refreshCellArray removeObjectAtIndex:0];
        }
    }
    
}

- (void)errorWith:(NSError *)error method:(NSString *)method
{
    [self endRefreshing];
}
- (void)endRefreshing
{
    if ([self.tableView.header isRefreshing]) {
        [self.tableView.header endRefreshing];
    }
    if ([self.tableView.footer isRefreshing]) {
        [self.tableView.footer endRefreshing];
    }
}
@end
