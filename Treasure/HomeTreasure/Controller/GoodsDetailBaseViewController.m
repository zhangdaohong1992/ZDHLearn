//
//  GoodsDetailBaseViewController.m
//  Treasure
//
//  Created by 苹果 on 15/10/27.
//  Copyright © 2015年 YDS. All rights reserved.
//

#import "GoodsDetailBaseViewController.h"
#import "CategoryTableViewCell.h"
#import "GoodsRecordTableViewCell.h"
#import "MJRefresh.h"
#import "JoinRecordModel.h"
#import "GJAutoCycleScrollView.h"
#import "GoodsDetailHeaderView.h"
#import "GoodsBottomView.h"

static NSString * categoryCellIdentifier = @"categorycell";
static NSString * goodsRecordCellIdentifier = @"goodsRecordcell";

@interface GoodsDetailBaseViewController ()<GJAutoCycleScrollViewDelegate, GJAutoCycleScrollViewDataSource>
{
    UIImage *shadeoImg;
}
@property (nonatomic, strong) NSArray * categoryTitles;
@property (nonatomic, strong) NSArray * categoryImages;

@end

@implementation GoodsDetailBaseViewController
//- (void)scrollViewDidScroll:(UIScrollView *)scrollView
//{
//    float numY = scrollView.contentOffset.y ? scrollView.contentOffset.y : 0;
//    NSLog(@"%f",numY / 100.0f);
//    
//    [[self.navigationController.navigationBar subviews] objectAtIndex:0].alpha = numY / 100.0f;
//    if (numY / 100.0 <= 1.) {
//        self.navigationController.navigationBar.shadowImage = [UIImage new];
//
//    }
//    if (numY / 100.0 > 1.) {
//        self.navigationController.navigationBar.shadowImage = shadeoImg;
//    }
//}


- (void)viewDidLoad {
    [super viewDidLoad];
    shadeoImg = self.navigationController.navigationBar.shadowImage;
    self.dataArray = [NSMutableArray array];
    self.joinRecords = [NSMutableArray array];
    
    [self registeTableViewCell];
    
    self.pageCount = 0;
    self.categoryTitles = @[@"图文详情", @"往期揭晓", @"晒单分享"];
    self.categoryImages = @[[UIImage imageNamed:@"graphic-details"], [UIImage imageNamed:@"particulars_clock"], [UIImage imageNamed:@"camera_share"]];
    
    self.tableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMore)];
    [self loadMore];
    
    self.headerView = [[[NSBundle mainBundle] loadNibNamed:@"GoodsDetailHeaderView" owner:self options:nil] firstObject];
    self.headerView.frame = CGRectMake(0, 0, VIEW_WIDTH, 340);
    self.headerView.stateLabel.layer.borderColor = UIColorFromRGB(0xFFBC00).CGColor;
    self.headerView.stateLabel.layer.borderWidth = 1.f;
    self.tableView.tableHeaderView = self.headerView;
    
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 0)];
    }
    self.window = [[[UIApplication sharedApplication] delegate] window];
    // Do any additional setup after loading the view.
}

- (void)loadMore
{

}

- (void)registeTableViewCell
{
    [self.tableView registerNib:[UINib nibWithNibName:@"CategoryTableViewCell" bundle:nil] forCellReuseIdentifier:categoryCellIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:@"GoodsRecordTableViewCell" bundle:nil] forCellReuseIdentifier:goodsRecordCellIdentifier];
}

- (GJAutoCycleScrollView *)adScrollView
{
    if (_adScrollView == nil) {
        self.adScrollView = [[GJAutoCycleScrollView alloc] initWithFrame:CGRectMake(0, 0, VIEW_WIDTH, 225)];
        self.adScrollView.delegate = self;
        self.adScrollView.dataSource = self;
    }
    return _adScrollView;
}

#pragma mark - liftcycle
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

#pragma mark - GJAutoCycleScrollViewDataSource
- (NSInteger)numberOfPagesInAutoCycleScrollView:(GJAutoCycleScrollView *)autoCycleScrollView
{
    return self.imageNames.count;
}

- (NSString *)autoCycleScrollView:(GJAutoCycleScrollView *)autoCycleScrollView imageUrlAtIndex:(NSInteger)index
{
    return self.imageNames[index];
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0){
        return 50;
    }else{
        return 70;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 10.0;
    }
    return 30;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 1) {
        UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 20)];
        label.text = @"   参与记录";
        label.font = [UIFont systemFontOfSize:14];
        return label;
    }
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if ([[[[NSUserDefaults standardUserDefaults] objectForKey:MODE] stringValue] isEqualToString:@"0"] && section == 0) {
        UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, tableView.width, 30)];
        label.text = @"   本活动及商品与苹果公司(Apple Inc.)无关";
        return label;
    }else{
        return [UIView new];
    }
}


#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0){
        return self.categoryTitles.count;
    }else{
        return self.joinRecords.count;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0){
        CategoryTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:categoryCellIdentifier forIndexPath:indexPath];
        cell.imageView.image = self.categoryImages[indexPath.row];
        cell.textLabel.text = self.categoryTitles[indexPath.row];
        return cell;
    }else{
        GoodsRecordTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:goodsRecordCellIdentifier forIndexPath:indexPath];
        JoinRecordModel * model = [JoinRecordModel objectWithKeyValues:self.joinRecords[indexPath.row]];
        cell.model = model;
        return cell;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
