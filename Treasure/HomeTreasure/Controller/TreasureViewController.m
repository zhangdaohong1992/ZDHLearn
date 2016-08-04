//
//  TreasureViewController.m
//  Treasure
//
//  Created by 苹果 on 15/10/20.
//  Copyright © 2015年 YDS. All rights reserved.
//

#import "TreasureViewController.h"
#import "GJAutoCycleScrollView.h"
#import "SearchViewController.h"
#import "HomeTreasureHeaderView.h"
#import "HomeGoodsCollectionViewCell.h"
#import "HomeGoodsModel.h"
#import "MJRefresh.h"
#import "HomeGoodsModelHandle.h"
#import "GoodDetailViewController.h"
#import "HomeTempCollectionViewCell.h"
#import "SegmentCollectionReusableView.h"
#import "NormalCollectionReusableView.h"
#import "HMSegmentedControl.h"
#import "XRIssueCellModel.h"
#import "XLPlainFlowLayout.h"
#import "XRNewDetailViewController.h"
#import "NewestPublicView.h"
#import "UIImageView+AFNetworking.h"


@interface TreasureViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, UIScrollViewDelegate, UICollectionViewDelegateFlowLayout, GJAutoCycleScrollViewDelegate, GJAutoCycleScrollViewDataSource, HomeTempCollectionViewCellDelegate>
{
    UIImageView *imgV;
    BOOL isFirst;
}
@property (nonatomic, strong) GJAutoCycleScrollView *adScrollView;
@property (nonatomic, strong) HomeTreasureHeaderView * headerView;
@property (nonatomic, strong) NSArray *imageNames;
@property (nonatomic, strong) NSMutableArray * dataArray;
@property (nonatomic, strong) NSArray * newestPublicGoods;
@property (nonatomic, assign) NSInteger pageCount;
@property (nonatomic, assign) NSInteger sortId;
@property (nonatomic, assign) NSInteger selectItemIndex;
@property (nonatomic, assign) NSInteger adClickIndex;
@property (nonatomic, strong) HomeGoodsModelHandle * modelHandle;
@property (nonatomic, strong) NSArray * adsClickArray;
@property (nonatomic, assign) BOOL isClickAds;

@end

static NSString * identifier = @"treasureCell";
static NSString * newestIdentifier = @"HomeTempCollectionViewCell";
static NSString * reuseableHeaderViewIdentifier = @"reuseableHeaderView";
static NSString * normalHeaderViewIdentifier = @"normalHeaderView";

static CGFloat headerViewHeight = 175;

@implementation TreasureViewController
- (void)viewDidAppear:(BOOL)animated{
    isFirst= YES;
}
- (void)viewWillAppear:(BOOL)animated
{
    if (isFirst) {
        [self.collectionView.header beginRefreshing];
    }
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    CGSize size = VIEW_WIDTH > 375. ? CGSizeMake((VIEW_WIDTH - 10) / 2, 226) : CGSizeMake((VIEW_WIDTH - 1) / 2, 226);
    self.layout.itemSize = size;
    NSLog(@"item.size = %@", NSStringFromCGSize(self.layout.itemSize));
    
    self.layout.naviHeight = 64.;
    self.layout.minimumLineSpacing = 1;
    self.layout.minimumInteritemSpacing = 1;
    self.layout.headerReferenceSize = CGSizeMake(VIEW_WIDTH, 30);

    self.dataArray = [NSMutableArray array];
    self.modelHandle = [[HomeGoodsModelHandle alloc] init];
    
    [self registCellMethod];
    
    self.headerView = [[[NSBundle mainBundle] loadNibNamed:@"HomeTreasureHeaderView" owner:self options:nil] firstObject];
    self.headerView.frame = CGRectMake(0, -headerViewHeight - 1, VIEW_WIDTH, headerViewHeight);
    [self.collectionView addSubview:self.headerView];
    
    _pageCount = 0;
    self.collectionView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshMethod)];
    self.collectionView.footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMore)];
    self.collectionView.header.ignoredScrollViewContentInsetTop = headerViewHeight;
    
    for (UITabBarItem * item in self.tabBarController.tabBar.items) {
        UIImage * image = [item selectedImage];
        item.selectedImage = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    }
    [self getBadgeValue];
    [self.collectionView.header beginRefreshing];
    // Do any additional setup after loading the view.View controller-based status bar appearance
}

- (void)registCellMethod
{
    self.collectionView.contentInset = UIEdgeInsetsMake(headerViewHeight + 1, 0, 0, 0);
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([HomeGoodsCollectionViewCell class]) bundle:nil] forCellWithReuseIdentifier:identifier];
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([HomeTempCollectionViewCell class]) bundle:nil] forCellWithReuseIdentifier:newestIdentifier];
    [self.collectionView registerClass:[SegmentCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:reuseableHeaderViewIdentifier];
    [self.collectionView registerClass:[NormalCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:normalHeaderViewIdentifier];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)showMoreButtonMethod
{
    [self.tabBarController setSelectedIndex:1];
}

- (void)refreshMethod
{
    _pageCount = 1;
    [self.network postWithParameter:@{} method:getSlideShowAndNotice];
    [self getNewTermsData];
    [self getSegmentData];
}

- (void)getNewTermsData
{
    [self.network postWithParameter:@{@"page" : @(1)} method:getNewTerms];
}

- (void)getSegmentData
{
    [self.network postWithParameter:@{@"page": @(_pageCount), @"categoryId" : @"0", @"sortId" : @(_sortId)} method:getItemsByCatagoryAndSort];
}

- (void)loadMore
{
    _pageCount ++;
    [self.network postWithParameter:@{@"page": @(_pageCount), @"categoryId" : @"0", @"sortId" : @(_sortId)} method:getItemsByCatagoryAndSort];
}
#pragma mark --  轮播图  ---
- (GJAutoCycleScrollView *)adScrollView
{
    if (_adScrollView == nil) {
        self.adScrollView = [[GJAutoCycleScrollView alloc] initWithFrame:CGRectMake(0, 0, VIEW_WIDTH, 130)];
        self.adScrollView.pageControl.pageIndicatorTintColor  = [UIColor grayColor];
        self.adScrollView.delegate = self;
        self.adScrollView.dataSource = self;
    }
    return _adScrollView;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self setHidesBottomBarWhenPushed:NO];
}

//- (IBAction)searchButtonMethod:(id)sender
//{
//    [self setHidesBottomBarWhenPushed:YES];
//    [self performSegueWithIdentifier:@"search" sender:self];
//}

- (void)shoppingButtonMethod:(UIButton *)btn
{
    HomeGoodsCollectionViewCell * cell = (HomeGoodsCollectionViewCell *)[[[btn superview] superview] superview];
    NSLog(@"cell==== %f",cell.frame.origin.y);
    
    
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
    CGPoint fromPoint = [self.collectionView convertPoint:CGPointMake(theAttributes.center.x , theAttributes.center.y ) toView:[self.collectionView superview]];
    CGPoint toPoint = CGPointMake(VIEW_WIDTH * 0.8 - VIEW_WIDTH / 20.0, VIEW_HEIGHT +20);
    
    //    CALayer * layer = [HomeGoodsModelHandle creatLayerWithFromPoint:fromPoint];
    //    [self.view.layer addSublayer:layer];
    [HomeGoodsModelHandle animationWithLayer:imgV.layer withFromPoint:fromPoint byPoint:fromPoint toPoint:toPoint];
}

- (void)getBadgeValue
{
    UITabBarItem * item = self.tabBarController.tabBar.items[3];
    item.badgeValue = [[HomeGoodsModelHandle tabbarBadgeValue] isEqualToString:@"0"] ? nil : [HomeGoodsModelHandle tabbarBadgeValue];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 2;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }
    return self.dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        HomeTempCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:newestIdentifier forIndexPath:indexPath];
        [cell configViewWithModelArray:self.newestPublicGoods];
        cell.delegate = self;
        return cell;
    }else{
        HomeGoodsCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
        if (indexPath.row < self.dataArray.count) {
            HomeGoodsModel * model = [HomeGoodsModel objectWithKeyValues:self.dataArray[indexPath.row]];
            cell.model = model;
            [cell.shoppingButton addTarget:self action:@selector(shoppingButtonMethod:) forControlEvents:UIControlEventTouchUpInside];
        }
        return cell;
    }
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        if (indexPath.section == 0) {
            NormalCollectionReusableView * headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:normalHeaderViewIdentifier forIndexPath:indexPath];
            [headerView addNormalTitle];
            __weak TreasureViewController * wself = self;
            [headerView handleButtonTaped:^{
                [wself.tabBarController setSelectedIndex:1];
            }];
            return headerView;
        }else{
            SegmentCollectionReusableView * header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:reuseableHeaderViewIdentifier forIndexPath:indexPath];
            [header addSegmentView];
            [header.segment addTarget:self action:@selector(indexChangeBlockMethod:) forControlEvents:UIControlEventValueChanged];
            return header;
        }
    }
    return nil;
}

- (void)indexChangeBlockMethod:(HMSegmentedControl *)segment
{
    self.sortId = segment.selectedSegmentIndex;
    self.pageCount = 1;
    [self.collectionView setContentOffset:CGPointMake(0, -64) animated:YES];
    [self getSegmentData];
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self setHidesBottomBarWhenPushed:YES];
    self.selectItemIndex = indexPath.row;
    [self performSegueWithIdentifier:@"detail" sender:self];
}

#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section) {
        return self.layout.itemSize;
    }
    return CGSizeMake(VIEW_WIDTH, 144);
}
// 设置section头视图的参考大小，与tableheaderview类似
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    if (!section) {
        return CGSizeMake(VIEW_WIDTH, 30);
    }        return CGSizeMake(VIEW_WIDTH, 40);
    
}

#pragma mark - HomeEmptyCollectionViewCellDelegate
- (void)clickedItemAtIndex:(NSInteger)index
{
    UIStoryboard *sty = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    XRNewDetailViewController *vc = [sty instantiateViewControllerWithIdentifier:@"newDetail"];
    
    XRIssueCellModel *model = self.newestPublicGoods[index];
    vc.itemId = [NSString stringWithFormat:@"%@",@(model.itemId)];
    vc.itemTermId = [NSString stringWithFormat:@"%@",@(model.Id)];
    vc.state = model.state;
    
    NSIndexPath * path = [NSIndexPath indexPathForRow:0 inSection:0];
    HomeTempCollectionViewCell * cell = (HomeTempCollectionViewCell *)[self.collectionView cellForItemAtIndexPath:path];
    NewestPublicView * view = (NewestPublicView *)[cell viewWithTag:100 + index];
    vc.downCount = view.timeLabel.getTimeCounted;
    
    [self setHidesBottomBarWhenPushed:YES];    
    [self.navigationController pushViewController:vc animated:YES];
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

#pragma mark - GJAutoCycleScrollViewDelegate
- (void)autoCycleScrollView:(GJAutoCycleScrollView *)autoCycleScrollView didSelectPageAtIndex:(NSInteger)index
{
    _isClickAds = YES;
    _adClickIndex = index;
    [self performSegueWithIdentifier:@"detail" sender:self];
}

#pragma mark - BaseNetworkDelegate
- (void)successfulWithDic:(NSDictionary *)dic method:(NSString *)method
{
    if ([method isEqualToString:getSlideShowAndNotice]) {
        if ([self isPostSuccessedWithDic:dic]) {
            NSDictionary * d = dic[DIC_DATA][@"notice"];
            self.headerView.winnerNameLabel.text = d[@"nickName"];
            self.headerView.goodsNameLabel.text = [NSString stringWithFormat:@"[第%@期]%@", d[@"term"], d[@"itemTitle"]];
            self.imageNames = [self.modelHandle getAdsImageArrayWithDic:dic];
            self.adsClickArray = self.modelHandle.imageIDs;
            [self.headerView addSubview:self.adScrollView];
        }
    }
    if ([method isEqualToString:getItemsByCatagoryAndSort]) {
        if ([self isPostSuccessedWithDic:dic]) {
            if (_pageCount == 1) {
                [self.dataArray removeAllObjects];
                [self.collectionView.footer resetNoMoreData];
            }
            ResponseModel * model = [ResponseModel objectWithKeyValues:dic];
            NSArray * tempArr = model.data[@"list"];
            if (tempArr.count) {
                for (NSDictionary * d in tempArr) {
                    [self.dataArray addObject:d];
                }
            }else{
                [self.collectionView.footer noticeNoMoreData];
            }
            [self.collectionView reloadData];
        }
        [self endRefreshing];
    }
    if ([method isEqualToString:getNewTerms]) {
        if ([self isPostSuccessedWithDic:dic]) {
            NSArray * arr = [HomeGoodsModelHandle getOpeningGoodsByAllGoods:dic[DIC_DATA][@"list"]];
            self.newestPublicGoods = [XRIssueCellModel objectArrayWithKeyValuesArray:arr];
            
            [self.collectionView reloadData];
        }
        [self endRefreshing];
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

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"detail"]) {
        GoodDetailViewController * detailVC = [segue destinationViewController];
        if (self.selectItemIndex < self.dataArray.count) {
            HomeGoodsModel * model = [HomeGoodsModel objectWithKeyValues:self.dataArray[self.selectItemIndex]];
            detailVC.itemId = [NSString stringWithFormat:@"%@", model.itemTermID];
            detailVC.itemTermId = model.itemTermID;
        }
        if (_isClickAds) {
            _isClickAds = NO;
            NSLog(@"%@, %@", self.adsClickArray, @(_adClickIndex));
            detailVC.adsID = self.adsClickArray[_adClickIndex];
        }
    }
}


@end
