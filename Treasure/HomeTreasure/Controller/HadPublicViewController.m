//
//  HadPublicViewController.m
//  Treasure
//
//  Created by 苹果 on 15/10/27.
//  Copyright © 2015年 YDS. All rights reserved.
//

#import "HadPublicViewController.h"
#import "HadPublicTableViewCell.h"
#import "MJRefresh.h"
#import "HadPublicModel.h"

@interface HadPublicViewController ()
@property (nonatomic, strong) NSMutableArray * dataArray;
@property (nonatomic, assign) NSInteger pageCount;

@end

static NSString * identifier = @"hadPublic";

@implementation HadPublicViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataArray = [NSMutableArray array];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"HadPublicTableViewCell" bundle:nil] forCellReuseIdentifier:identifier];
    self.tableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMore)];
    
    _pageCount= 1;
    NSLog(@"itemid = %@", self.itemID);
    [self.network postWithParameter:@{@"itemId" : self.itemID, @"page" : @(_pageCount)} method:getPastTerms isHud:YES];
    // Do any additional setup after loading the view.
}

- (void)loadMore
{
    _pageCount ++;
    [self.network postWithParameter:@{@"itemId" : self.itemID, @"page" : @(_pageCount)} method:getPastTerms isHud:YES];
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    self.noMoreDataLabel.hidden = self.dataArray.count ? YES : NO;
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HadPublicTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    HadPublicModel * model = [HadPublicModel objectWithKeyValues:self.dataArray[indexPath.row]];
    cell.model = model;
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma BaseNetworkDelegate
- (void)successfulWithDic:(NSDictionary *)dic method:(NSString *)method
{
    if ([method isEqualToString:getPastTerms]) {
        if ([self isPostSuccessedWithDic:dic]) {
            NSArray * arr = dic[DIC_DATA][@"list"];
            if (arr.count) {
                for (NSDictionary *d in arr) {
                    [self.dataArray addObject:d];
                }
            }else{
                [self.tableView.footer noticeNoMoreData];
            }
            [self.tableView.footer endRefreshing];
            [self.tableView reloadData];
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
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
