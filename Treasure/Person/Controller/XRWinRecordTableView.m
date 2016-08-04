//
//  XRWinRecordTableView.m
//  Treasure
//
//  Created by 荣 on 15/10/30.
//  Copyright © 2015年 YDS. All rights reserved.
//

#import "XRWinRecordTableView.h"
#import "XRWinRecordModel.h"
#import "XRWinRecordCell.h"
#import "RewardNumView.h"
#import "XRNewDetailViewController.h"
#import <MJRefresh/MJRefresh.h>

//#define state @"state"

@interface XRWinRecordTableView ()<winRecordDelegate>

@property(nonatomic,strong)NSMutableArray *modelArr;

@property(nonatomic,assign)int page;

@property(nonatomic,strong)NSArray *titleArr;

@property(nonatomic,weak)XRWinRecordCell *timeOutCell;/**< 时间到了的cell */

@property (nonatomic, strong) NSMutableArray * refreshCellArray;

@end

@implementation XRWinRecordTableView

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupTableView];
    _page = 1;
    //    [self.network postWithParameter:@{COOKIE:USER_COOKIE,@"page":@(_page),state:@(self.statue)} method:getDuoBaoRecords];
    [self.tableView.header beginRefreshing];
    self.refreshCellArray = [NSMutableArray array];
}

#pragma mark - UITabelView
-(void)setupTableView
{
    self.tableView.tableFooterView = [UIView new];
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 100;
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([XRWinRecordCell class]) bundle:nil] forCellReuseIdentifier:@"winRecord"];
    [self pushRefresh];
    [self pullRefresh];
}
#pragma mark - UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    self.noMoreDataLabel.hidden = self.modelArr.count ? YES : NO;
    return self.modelArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    XRWinRecordCell *cell = [tableView dequeueReusableCellWithIdentifier:@"winRecord" forIndexPath:indexPath];
    cell.delegate = self;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.model = self.modelArr[indexPath.row];
    cell.model.cellRow = indexPath.row;
    return cell;
}
#pragma mark -UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIStoryboard *sty = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    
    XRNewDetailViewController *vc = [sty instantiateViewControllerWithIdentifier:@"newDetail"];
    
    
    XRWinRecordModel *model = self.modelArr[indexPath.row];
    vc.itemId = model.itemId;
    vc.itemTermId = model.itemTermId;
    vc.state = model.state;
    
    vc.hidesBottomBarWhenPushed = YES;
    
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 上下拉刷新
-(void)pushRefresh
{
    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        _page = 1;
        [self.network postWithParameter:@{COOKIE:USER_COOKIE,@"page":@(_page),@"state":@(self.statue)} method:getDuoBaoRecords];
    }];
}
-(void)pullRefresh
{
    self.tableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        _page++;
        NSLog(@"%d",_page);
        [self.network postWithParameter:@{COOKIE:USER_COOKIE,@"page":@(_page),@"state":@(self.statue)} method:getDuoBaoRecords];
    }];
}

-(void)lookMynumInCell:(XRWinRecordCell *)cell
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    UIView *hubView = [[UIView alloc]initWithFrame:window.bounds];
    hubView.backgroundColor = [UIColor blackColor];
    hubView.alpha = 0.3;
    
    [window addSubview:hubView];
    
    RewardNumView  *numView = [[RewardNumView alloc]initWithFrame:CGRectMake((VIEW_WIDTH - 270)*0.5, 225, 270, 200)];
    NSArray *scrollArr = [cell.model.joinNum componentsSeparatedByString:@","];
    [numView scrollViewWithNumArray:scrollArr];
    [window addSubview:numView];
    __weak RewardNumView *tempView = numView;
    numView.block = ^(){
        [hubView removeFromSuperview];
        [tempView removeFromSuperview];
    };
}
#pragma mark - 倒计时到了处理

#pragma mark - XRNewCellDelgate
-(void)finshedCountDownTimer:(XRWinRecordCell *)cell
{
    //发送网络请求
    self.timeOutCell = cell;
    [self.refreshCellArray addObject:cell];
    [self.network postWithParameter:@{@"itemTermId":cell.model.itemTermId} method:@"openLucky"];
}

#pragma mark - 数据块
-(void)successfulWithDic:(NSDictionary *)dic method:(NSString *)method
{
    if ([method isEqualToString:getDuoBaoRecords]) {
        if ([self isPostSuccessedWithDic:dic]) {
            if (_page == 1) {
                [self.modelArr removeAllObjects];
                [self.tableView.footer resetNoMoreData];
            }
            if (![dic[DIC_DATA] isKindOfClass:[NSNull class]]) {
                NSArray * arr = [XRWinRecordModel objectArrayWithKeyValuesArray:dic[DIC_DATA][@"list"]];
                if (arr.count) {
                    [self.modelArr addObjectsFromArray:[XRWinRecordModel objectArrayWithKeyValuesArray:dic[DIC_DATA][@"list"]]];
                    XRWinRecordModel *model = [XRWinRecordModel objectWithKeyValues:dic[DIC_DATA]];
                    if(model){
                        self.titleArr  = @[model.allTimes,model.underwayTimes,model.hasOpenTimes];
                        [self setupBtnTitle];
                    }
                }else{
                    [self.tableView.footer noticeNoMoreData];
                }
                [self.tableView reloadData];
            }
        }
    }
    if ([method isEqualToString:@"openLucky"]) {
        if ([self isPostSuccessedWithDic:dic]) {
            XRWinRecordModel *cellModel = [XRWinRecordModel objectWithKeyValues:dic[DIC_DATA]];
            NSLog(@"%ld",(long)_timeOutCell.model.cellRow);
            cellModel.cellRow = _timeOutCell.model.cellRow;
            XRWinRecordCell * cell = self.refreshCellArray.firstObject;
            [cell tableView:self.tableView refrshModel:cellModel];
            [self.refreshCellArray removeObjectAtIndex:0];
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
-(void)setupBtnTitle
{
    // 文字数据
    NSArray *titles = @[@"全部", @"进行中", @"已揭晓"];
    
    for (int i = 0; i<self.titleButtons.count; i++) {
        UIButton *btn = self.titleButtons[i];
        if ([self.titleArr[i] intValue] >= 0) {
            [btn setTitle:[NSString stringWithFormat:@"%@(%@)",titles[i],self.titleArr[i]] forState:UIControlStateNormal];
            NSLog(@"%@(%@)",titles[i],self.titleArr[i]);
        }
    }
}

-(NSMutableArray *)modelArr
{
    if (!_modelArr) {
        _modelArr = [NSMutableArray array];
    }
    return _modelArr;
}

-(NSArray *)titleArr{
    if (!_titleArr) {
        _titleArr  = [NSArray array];
    }
    return _titleArr;
}

@end
