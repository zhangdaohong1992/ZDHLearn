//
//  SearchDetailViewController.m
//  Treasure
//
//  Created by 苹果 on 15/11/4.
//  Copyright © 2015年 YDS. All rights reserved.
//

#import "SearchDetailViewController.h"
#import "HomeGoodsCollectionViewCell.h"
#import "HomeGoodsModel.h"
#import "MJRefresh.h"
#import "HomeGoodsModelHandle.h"
#import "GoodDetailViewController.h"
#import "UIImageView+AFNetworking.h"

static NSString * identifier = @"treasureCell";

@interface SearchDetailViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
{
    UIImageView *imgV;
}
@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) IBOutlet UICollectionViewFlowLayout *layout;
@property (nonatomic, strong) NSMutableArray * dataArray;
@property (nonatomic, assign) NSInteger pageCount;
@property (nonatomic, assign) NSInteger selectItemIndex;
@property (nonatomic, strong) HomeGoodsModelHandle * modelHandle;

@end

@implementation SearchDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    CGSize size = VIEW_WIDTH > 375. ? CGSizeMake((VIEW_WIDTH - 10) / 2, 226) : CGSizeMake((VIEW_WIDTH - 1) / 2, 226);
    self.layout.itemSize = size;
    NSLog(@"item.size = %@", NSStringFromCGSize(self.layout.itemSize));
    self.layout.minimumLineSpacing = 1;
    self.layout.minimumInteritemSpacing = 1;
    
    self.dataArray = [NSMutableArray array];
    self.modelHandle = [[HomeGoodsModelHandle alloc] init];
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"HomeGoodsCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:identifier];
    _pageCount = 0;
    self.collectionView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshMethod)];
    self.collectionView.footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMore)];
    self.collectionView.footer.automaticallyHidden = YES;
    
    self.title = self.searchTitle;
    [self.collectionView.header beginRefreshing];
    // Do any additional setup after loading the view.
}

- (void)refreshMethod
{
    _pageCount = 1;
    [self loadData];
}

- (void)loadMore
{
    _pageCount ++;
    [self loadData];
}

- (void)loadData
{
    if ([self.methodName isEqualToString:queryItem]) {
        [self.network postWithParameter:@{@"page": @(_pageCount), @"itemName": self.searchTitle} method:self.methodName];
    }else if([self.methodName isEqualToString:getItemsByCatagoryAndSort]){
        [self.network postWithParameter:@{@"page": @(_pageCount), @"categoryId" : @(self.catagoryId), @"sortId" : @(0)} method:getItemsByCatagoryAndSort];
    }
}

- (void)shoppingButtonMethod:(UIButton *)btn
{
    HomeGoodsCollectionViewCell * cell = (HomeGoodsCollectionViewCell *)[[[btn superview] superview] superview];
    NSIndexPath * path = [self.collectionView indexPathForCell:cell];
    HomeGoodsModel * model = [HomeGoodsModel objectWithKeyValues:self.dataArray[path.row]];
    if (!imgV) {
        imgV = [[UIImageView alloc]initWithFrame:cell.goodsImageView.frame];
    }else imgV.frame = cell.goodsImageView.frame;
    
    [imgV setImageWithURL:[NSURL URLWithString:model.picture] placeholderImage:[UIImage imageNamed:@"angle-mask"]];
    [self.view.layer addSublayer:imgV.layer];
    BOOL result = [HomeGoodsModelHandle saveWithHomeGoodsModel:model];
    if (result) {
        [self getBadgeValue];
    }
    UICollectionViewLayoutAttributes * theAttributes = [self.collectionView layoutAttributesForItemAtIndexPath:path];
    CGPoint fromPoint = [self.collectionView convertPoint:CGPointMake(theAttributes.center.x, theAttributes.center.y) toView:[self.collectionView superview]];
    CGPoint toPoint = CGPointMake(VIEW_WIDTH * 0.8 - VIEW_WIDTH / 20.0, VIEW_HEIGHT);
    
//    CALayer * layer = [HomeGoodsModelHandle creatLayerWithFromPoint:fromPoint];
//    [self.view.layer addSublayer:layer];
    [HomeGoodsModelHandle animationWithLayer:imgV.layer withFromPoint:fromPoint byPoint:fromPoint toPoint:toPoint];
}

- (void)getBadgeValue
{
    UITabBarItem * item = self.tabBarController.tabBar.items[3];
    item.badgeValue = [HomeGoodsModelHandle tabbarBadgeValue];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    self.noMoreDataLabel.hidden = self.dataArray.count ? YES : NO;
    return self.dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    HomeGoodsCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    HomeGoodsModel * model = [HomeGoodsModel objectWithKeyValues:self.dataArray[indexPath.row]];
    cell.model = model;
    [cell.shoppingButton addTarget:self action:@selector(shoppingButtonMethod:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}

#pragma mark - UICollectionViewDataSource
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self setHidesBottomBarWhenPushed:YES];
    self.selectItemIndex = indexPath.row;
    [self performSegueWithIdentifier:@"detail" sender:self];
}

#pragma mark - BaseNetworkDelegate
- (void)successfulWithDic:(NSDictionary *)dic method:(NSString *)method
{
    if ([method isEqualToString:queryItem] || [method isEqualToString:getItemsByCatagoryAndSort]) {
        if ([self isPostSuccessedWithDic:dic]) {
            ResponseModel * model = [ResponseModel objectWithKeyValues:dic];
            NSArray * tempArr = model.data[@"list"];
            if (tempArr.count) {
                if (_pageCount == 1) {
                    [self.dataArray removeAllObjects];
                }
                
                for (NSDictionary * d in tempArr) {
                    [self.dataArray addObject:d];
                }
            }else{
                [self.collectionView.footer noticeNoMoreData];
            }
            [self endRefreshing];
            [self.collectionView reloadData];
        }
    }
}

- (void)errorWith:(NSError *)error method:(NSString *)method
{
    [self endRefreshing];
}

- (void)endRefreshing
{
    [self.collectionView.header endRefreshing];
    [self.collectionView.footer endRefreshing];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    GoodDetailViewController * detailVC = [segue destinationViewController];
    HomeGoodsModel * model = [HomeGoodsModel objectWithKeyValues:self.dataArray[self.selectItemIndex]];
    detailVC.itemId = [NSString stringWithFormat:@"%@", model.itemTermID];
    detailVC.itemTermId = model.itemTermID;
}


@end
