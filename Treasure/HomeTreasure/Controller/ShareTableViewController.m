//
//  ShareTableViewController.m
//  Treasure
//
//  Created by 苹果 on 15/10/29.
//  Copyright © 2015年 YDS. All rights reserved.
//

#import "ShareTableViewController.h"
#import "ShareTableViewCell.h"
#import "ShareGoodsModel.h"
#import "MJRefresh.h"
#import "WebViewController.h"

static NSString * identifier = @"sharecell";

@interface ShareTableViewController ()

@property (nonatomic, strong) NSMutableArray * dataArray;
@property (nonatomic, assign) NSInteger pageCount;
@property (nonatomic, strong) ShareTableViewCell * prototyCell;
@property (nonatomic, assign) NSInteger tableViewSelectIndex;

@end

@implementation ShareTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataArray = [NSMutableArray array];
    _pageCount = 1;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"ShareTableViewCell" bundle:nil] forCellReuseIdentifier:identifier];
    self.tableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMore)];
    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshMethod)];
    self.tableView.header.automaticallyChangeAlpha = YES;
    self.tableView.tableFooterView = [UIView new];
    self.prototyCell = [self.tableView dequeueReusableCellWithIdentifier:identifier];
    // Do any additional setup after loading the view.
}

- (void)getParameters
{
    [self getRelatedId];
    [self.network postWithParameter:@{@"page": @(_pageCount), @"type" : @(self.type), @"relatedId" : self.relatedId} method:getShowOrders isHud:NO];
}

- (void)getRelatedId
{
    if (!self.type) {
        self.type = 0;
    }
    if (self.type == 1){
        self.relatedId = self.itemID;
    }else if(self.type == 2){
        self.relatedId = self.userID;
    }else{
        self.relatedId = @"";
    }
}

- (void)refreshMethod
{
    _pageCount = 1;
//    [self.dataArray removeAllObjects];
    [self getParameters];
}

- (void)loadMore
{
    _pageCount ++;
    [self.network postWithParameter:@{@"page": @(_pageCount), @"type" : @(self.type), @"relatedId" : self.relatedId} method:getShowOrders isHud:NO];
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ShareTableViewCell * cell = self.prototyCell;
    ShareGoodsModel * model = [ShareGoodsModel objectWithKeyValues:self.dataArray[indexPath.row]];
    cell.commentLabel.text = model.content;
    CGRect rect = [cell.commentLabel.text boundingRectWithSize:CGSizeMake(cell.commentLabel.width, 0) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : cell.commentLabel.font} context:nil];
//    NSLog(@"%f", rect.size.height);
    return rect.size.height + 68 + 120;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    self.tableViewSelectIndex = indexPath.row;
    [self performSegueWithIdentifier:@"shareDetail" sender:self];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    self.noMoreDataLabel.hidden = self.dataArray.count ? YES : NO;
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ShareTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    ShareGoodsModel * model = [ShareGoodsModel objectWithKeyValues:self.dataArray[indexPath.row]];
//    ShareTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
//    if (!cell) {
//        cell = [[[NSBundle mainBundle] loadNibNamed:@"ShareTableViewCell" owner:self options:nil] lastObject];
//    }else{
//        while ([cell.contentView.subviews lastObject] != nil) {
//            [cell.contentView.subviews.lastObject removeFromSuperview];
//        }
//    }
//    ShareGoodsModel * model = [ShareGoodsModel objectWithKeyValues:self.dataArray[indexPath.row]];
    cell.model = model;
    return cell;
}

- (void)successfulWithDic:(NSDictionary *)dic method:(NSString *)method
{
    if ([method isEqualToString:getShowOrders]) {
        if ([self isPostSuccessedWithDic:dic]) {
            if (self.pageCount == 1) {
                [self.dataArray removeAllObjects];
                [self.tableView.footer resetNoMoreData];
            }
            NSArray * arr = dic[DIC_DATA][@"list"];
            if (arr.count) {
                for (NSDictionary * dic in arr) {
                    [self.dataArray addObject:dic];
                }
            }else{
                [self.tableView.footer noticeNoMoreData];
            }
            [self.tableView reloadData];
        }else{
            [ResponseModel showInfoWithString:dic[DIC_INFO]];
        }
        [self endRefreshing];
    }
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

- (void)errorWith:(NSError *)error method:(NSString *)method
{
    [self endRefreshing];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    if ([segue.identifier isEqualToString:@"shareDetail"]) {
        WebViewController * webVC = [segue destinationViewController];
        ShareGoodsModel * model = [ShareGoodsModel objectWithKeyValues:self.dataArray[self.tableViewSelectIndex]];
        webVC.title = @"晒单详情";
        webVC.vc = self;
        webVC.bodyString = [NSString stringWithFormat:@"showOrderId=%@", model.shareID];
        webVC.url = getshowOrderDetail;
    }
}


@end
