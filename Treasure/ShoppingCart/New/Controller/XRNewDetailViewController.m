//
//  XRNewDetailViewController.m
//  Treasure
//
//  Created by 荣 on 15/11/2.
//  Copyright © 2015年 YDS. All rights reserved.
//

#import "XRNewDetailViewController.h"
#import "MJRefresh.h"
#import "GoodsDetailHeaderView.h"
#import "GoodsInfoModel.h"
#import "GoodsWinnerModel.h"
#import "WebViewController.h"
#import "HadPublicViewController.h"
#import "ShareTableViewController.h"
#import "GoodsBottomView.h"
#import "GoodDetailViewController.h"
#import "HomeGoodsModel.h"
#import "MZTimerLabel.h"
#import "XRNewHomePageVC.h"

@interface XRNewDetailViewController ()<MZTimerLabelDelegate>

@property (nonatomic, strong) HomeGoodsModel * goodsModel;
@property (nonatomic, strong) GoodsInfoModel * tempInfoModel;
@property (nonatomic, strong) GoodsBottomView * bottomView;
@property (nonatomic, assign) BOOL isCalculateDetail;

@end

@implementation XRNewDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    [self setupBottom];
    [self setupHeadView];
    [self.navigationItem setTitle:@"商品详情"];
    [self.headerView.detailButton addTarget:self action:@selector(calculateDetailMethod) forControlEvents:UIControlEventTouchUpInside];
    [self.headerView.calculateDetailButton addTarget:self action:@selector(calculateDetailMethod) forControlEvents:UIControlEventTouchUpInside];
   
}
-(void)viewWillAppear:(BOOL)animated
{
   [super viewWillAppear:animated];
   [self.window addSubview:self.bottomView];
//一进来就更新物品信息
   [self.network postWithParameter:@{@"itemTermId" : self.itemTermId} method:getItemInfo isHud:YES];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear: animated];
    [self.bottomView removeFromSuperview];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    self.homeVC.isTabBarSelected = NO;
}

-(void)setupHeadView
{
    [self hideWhichByState:_state];
    self.headerView.timeLabel.delegate  = self;
}

- (void)loadMore
{
    self.pageCount++;
    [self.network postWithParameter:@{@"itemTermId" : self.itemTermId, @"page" : @(self.pageCount)} method:getJoinRecoeds];
}

-(void)setupBottom
{
    if(self.isNewest){
    self.bottomView = [GoodsBottomView instanceCenterViewWithType:@"buyNow"];
    }
    else{
        self.bottomView = [GoodsBottomView instanceCenterViewWithType:@"goto"];
    }
    self.bottomView.frame = CGRectMake(0, VIEW_HEIGHT - 49, VIEW_WIDTH, 49);
    self.window = [UIApplication sharedApplication].keyWindow;
    UIButton *btn = [self.bottomView gotoBuyButton];
    [btn addTarget:self action:@selector(gotoBuy) forControlEvents:UIControlEventTouchUpInside];
}

- (void)calculateDetailMethod
{
    self.isCalculateDetail = YES;
    [self performSegueWithIdentifier:@"goodsDetail" sender:self];
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (!self.goodsModel) {
        return;
    }
    if (indexPath.section == 0) {
        NSString * segue = @"";
        if (indexPath.row == 0) {
            segue = @"goodsDetail";
        }else if (indexPath.row == 1){
            segue = @"hadPublic";
        }else{
            segue = @"shareList";
        }
        [self performSegueWithIdentifier:segue sender:self];
    }
}

#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"goodsDetail"]) {
        WebViewController * webVC = [segue destinationViewController];
        if (!self.isCalculateDetail) {
            webVC.bodyString = [NSString stringWithFormat:@"itemId=%@", @(self.goodsModel.itemId)];
            webVC.title = @"图文详情";
            webVC.url = getItemDescribution;
        }else{
            webVC.title = @"计算详情";
            self.isCalculateDetail = NO;
            webVC.bodyString = [NSString stringWithFormat:@"itemTermId=%@", self.goodsModel.itemTermID];
            webVC.url = queryCalculating;
        }
    }else if ([segue.identifier isEqualToString:@"hadPublic"]){
        HadPublicViewController * hadPublicVC = [segue destinationViewController];
        hadPublicVC.itemID = [NSString stringWithFormat:@"%@", @(self.goodsModel.itemId)];
        NSLog(@"model = %@", hadPublicVC.itemID);
    }else if ([segue.identifier isEqualToString:@"shareList"]){
        ShareTableViewController * shareVC = [segue destinationViewController];
        shareVC.itemID = [NSString stringWithFormat:@"%@", @(self.goodsModel.itemId)];
        NSLog(@"_____%@", shareVC.itemID);
        shareVC.type = 1;
    }
}

#pragma mark - bottomView-Click
-(void)gotoBuy
{
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    GoodDetailViewController *vc = [sb instantiateViewControllerWithIdentifier:@"goodDetail"];
    vc.itemId = self.tempInfoModel.itemTermId;
    vc.itemTermId = self.tempInfoModel.itemTermId;
    NSLog(@"__________________%@, ", self.goodsModel);
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - MZTimeLabelDelegate
-(void)timerLabel:(MZTimerLabel *)timerLabel finshedCountDownTimerWithTime:(NSTimeInterval)countTime
{
    self.headerView.timeLabel.text = @"正在计算中";
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
         [self.network postWithParameter:@{@"itemTermId":_itemTermId} method:@"openLucky"];
    });
}

#pragma mark - BaseNetworkDelegate
- (void)successfulWithDic:(NSDictionary *)dic method:(NSString *)method
{
    if ([method isEqualToString:getJoinRecoeds]) {
        if ([self isPostSuccessedWithDic:dic]) {
            ResponseModel * model = [ResponseModel objectWithKeyValues:dic];
            NSArray * arr = model.data[@"list"];
            if (arr.count) {
                for (NSDictionary * dic in arr) {
                    [self.joinRecords addObject:dic];
                }
            }else{
                [self.tableView.footer noticeNoMoreData];
            }
            [self.tableView.footer endRefreshing];
            [self.tableView reloadData];
        }
    }
    if ([method isEqualToString:getItemInfo]) {
        if ([self isPostSuccessedWithDic:dic]) {
            
            //当获奖了就请求这个
            GoodsWinnerModel * winnerModel = [GoodsWinnerModel objectWithKeyValues:dic[DIC_DATA][@"luckyInfo"]];
            self.headerView.winnerModel = winnerModel;
            
            //商品信息详情
            _tempInfoModel = [GoodsInfoModel objectWithKeyValues:dic[DIC_DATA][@"item"]];
            if ([self.tempInfoModel.itemState isEqualToString:@"2"]) {
                self.bottomView.hidden = YES;
            }else{
                self.bottomView.hidden = NO;
            }
            self.imageNames = [_tempInfoModel.picUrls componentsSeparatedByString:@","];
            [self.headerView addSubview:self.adScrollView];
            self.headerView.model = _tempInfoModel;
            self.bottomView.itemLabel.text = [NSString stringWithFormat:@"第%@期商品正在火热进行中",_tempInfoModel.newestTerm];

            //根据状态显示相应的模块
            [self hideWhichByState:[_tempInfoModel.state intValue]];
            //倒计时
            if ([_tempInfoModel.state intValue] == 1) {
                [self.headerView.timeLabel reset];
                [self.headerView.timeLabel setCountDownTime:[_tempInfoModel.timeToOpen doubleValue]/1000];
            }
            //商品信息
            _goodsModel = [HomeGoodsModel objectWithKeyValues:dic[DIC_DATA][@"item"]];
            NSLog(@"__________________%@_____________", self.goodsModel);
        }
    }
    if ([method isEqualToString:@"openLucky"]) {
        if ([self isPostSuccessedWithDic:dic]) {
            [self hideWhichByState:2];
            GoodsWinnerModel * winnerModel = [GoodsWinnerModel objectWithKeyValues:dic[DIC_DATA]];
            dispatch_async(dispatch_get_main_queue(), ^{
                self.headerView.winnerModel = winnerModel;
            });
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

-(void)hideWhichByState:(int )state
{
    
    if (state == 0) {
        self.headerView.progressBackView.hidden = NO;
        self.headerView.timeBackView.hidden = YES;
        self.headerView.winnerBackVIew.hidden = YES;
        return;
    }
    if (state == 1) {
        self.headerView.progressBackView.hidden = YES;
        [self.headerView.timeBackView setBackgroundColor:UIColorFromRGB(0xFF4640)];
        self.headerView.timeBackView.hidden = NO;
        self.headerView.winnerBackVIew.hidden = YES;
    }
    else if (state == 2){
        self.tableView.tableHeaderView = [[UIView alloc]init];
        self.headerView.height = CGRectGetMaxY(self.headerView.winnerBackVIew.frame) + 25;
        self.tableView.tableHeaderView = self.headerView;
        self.headerView.progressBackView.hidden = YES;
        self.headerView.timeBackView.hidden = YES;
        self.headerView.winnerBackVIew.hidden = NO;
    }
}


@end
