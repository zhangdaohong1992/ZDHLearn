//
//  GoodDetailViewController.m
//  Treasure
//
//  Created by 苹果 on 15/10/27.
//  Copyright © 2015年 YDS. All rights reserved.
//

#import "GoodDetailViewController.h"
#import "MJRefresh.h"
#import "GoodsDetailHeaderView.h"
#import "GoodsInfoModel.h"
#import "GoodsWinnerModel.h"
#import "WebViewController.h"
#import "HadPublicViewController.h"
#import "ShareTableViewController.h"
#import "GoodsBottomView.h"
#import "HomeGoodsModelHandle.h"
#import "HomeGoodsModel.h"
#import "UIButton+ButtonBadgeValue.h"

@interface GoodDetailViewController ()

@property (nonatomic, strong) GoodsInfoModel * goodsModel;
@property (nonatomic, strong) GoodsBottomView * bottomView;
@property (nonatomic, strong) HomeGoodsModel * sqlModel;

@end

@implementation GoodDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.adsID) {
        [self.network postWithParameter:@{@"itemId" : self.adsID} method:getItemInfo isHud:YES];
    }else{
        [self.network postWithParameter:@{@"itemTermId" : self.itemId} method:getItemInfo isHud:YES];
    }
    // Do any additional setup after loading the view.
}

- (void)loadMore
{
    if (!self.itemTermId) {
        [self.tableView.footer endRefreshing];
        return;
    }
    self.pageCount++;
    [self.network postWithParameter:@{@"itemTermId" : self.itemTermId, @"page" : @(self.pageCount)} method:getJoinRecoeds];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    UITabBarItem * item = self.tabBarController.tabBar.items[3];
    item.badgeValue = [[HomeGoodsModelHandle tabbarBadgeValue] isEqualToString:@"0"] ? nil : [HomeGoodsModelHandle tabbarBadgeValue];
    [self.bottomView removeFromSuperview];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.bottomView = [GoodsBottomView instanceCenterViewWithType:@"buy"];
    [self.bottomView.buyNowButton addTarget:self action:@selector(buyNowButtonMethod) forControlEvents:UIControlEventTouchUpInside];
    [self.bottomView.addToShopCartButton addTarget:self action:@selector(addToShopCartButtonMethod) forControlEvents:UIControlEventTouchUpInside];
    [self.bottomView.shopCartButton addTarget:self action:@selector(shopCartButtonMethod) forControlEvents:UIControlEventTouchUpInside];
    self.bottomView.frame = CGRectMake(0, VIEW_HEIGHT - 49, VIEW_WIDTH, 49);
    [self.window addSubview:self.bottomView];
    [self.bottomView.shopCartButton badgeValueWithCount:[HomeGoodsModelHandle queryData:nil].count];
}

- (void)buyNowButtonMethod
{
    [self addToShopCartButtonMethod];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.6 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.tabBarController setSelectedIndex:3];
        [self.navigationController popToRootViewControllerAnimated:YES];
    });
}

- (void)addToShopCartButtonMethod
{
    CGPoint fromPoint = CGPointMake(VIEW_WIDTH / 2., VIEW_HEIGHT - 49);
    CGPoint byPoint = CGPointMake(VIEW_WIDTH - 50, VIEW_HEIGHT - 150);
    CGPoint toPoint = CGPointMake(VIEW_WIDTH - 20, VIEW_HEIGHT - 49);
    NSLog(@"from = %@ by = %@ to = %@", NSStringFromCGPoint(fromPoint), NSStringFromCGPoint(byPoint), NSStringFromCGPoint(toPoint));
    CALayer * layer = [HomeGoodsModelHandle creatLayerWithFromPoint:fromPoint];
    UIWindow * window = [[UIApplication sharedApplication].delegate window];
    [window.layer addSublayer:layer];
    [HomeGoodsModelHandle animationWithLayer:layer withFromPoint:fromPoint byPoint:byPoint toPoint:toPoint];
    NSLog(@"%@", self.sqlModel);
    [HomeGoodsModelHandle saveWithHomeGoodsModel:self.sqlModel];
    [self.bottomView.shopCartButton badgeValueWithCount:[HomeGoodsModelHandle queryData:nil].count];
}

- (void)shopCartButtonMethod
{
    [self.tabBarController setSelectedIndex:3];
    [self.navigationController popToRootViewControllerAnimated:YES];
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
            GoodsWinnerModel * winnerModel = [GoodsWinnerModel objectWithKeyValues:dic[DIC_DATA][@"luckyInfo"]];
            self.headerView.winnerModel = winnerModel;
            
            self.goodsModel = [GoodsInfoModel objectWithKeyValues:dic[DIC_DATA][@"item"]];
            
            self.sqlModel = [HomeGoodsModel objectWithKeyValues:dic[DIC_DATA][@"item"]];
            self.imageNames = [_goodsModel.picUrls componentsSeparatedByString:@","];
            [self.headerView addSubview:self.adScrollView];
            self.headerView.model = _goodsModel;
            self.itemTermId = self.goodsModel.itemTermId;
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"goodsDetail"]) {
        WebViewController * webVC = [segue destinationViewController];
        webVC.title = @"图文详情";
        webVC.bodyString = [NSString stringWithFormat:@"itemId=%@", self.goodsModel.itemId];
        webVC.url = getItemDescribution;
    }else if ([segue.identifier isEqualToString:@"hadPublic"]){
        HadPublicViewController * hadPublicVC = [segue destinationViewController];
        hadPublicVC.itemID = self.goodsModel.itemId;
        NSLog(@"model = %@", hadPublicVC.itemID);
    }else if ([segue.identifier isEqualToString:@"shareList"]){
        ShareTableViewController * shareVC = [segue destinationViewController];
        shareVC.itemID = self.goodsModel.itemId;
        NSLog(@"_____%@", shareVC.itemID);
        shareVC.type = 1;
    }
}


@end
