//
//  XRWinRecordViewController.m
//  Treasure
//
//  Created by 荣 on 15/10/28.
//  Copyright © 2015年 YDS. All rights reserved.
//
//===================夺宝记录的根控制器=================
//
#import "XRWinRecordViewController.h"
#import "UIView+RSAdditions.h"
#import "UIColor+XRAdditions.h"
#import "XRWinRecordCell.h"
#import "XRWinRecordModel.h"
#import "XRWinRecordTableView.h"
#import <MJRefresh/MJRefresh.h>

#define state @"state"

@interface XRWinRecordViewController ()<UIScrollViewDelegate>

/** 所有标题的父控件 */
@property (nonatomic, weak) UIView *titlesView;
/** 标题底部的指示线（下划线） */
@property (nonatomic, weak) UIView *titleUnderlineView;
/** 记录上一次点击的标题按钮 */
@property (nonatomic, weak) UIButton *clickedTitleButton;


@property(nonatomic,weak)UIScrollView *scrollView;

@property(nonatomic,strong)NSArray *titleArr;

@end

@implementation XRWinRecordViewController

static CGFloat old = 0;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.navigationItem setTitle:@"夺宝记录"];
    
    [self setupTitlesView];

    [self setupScrollView];
    
    [self setupAllChildVcs];
    
    // 默认显示第0个控制器的view
    [self scrollViewDidEndScrollingAnimation:self.scrollView];
//    //请求网络数据
//     [self.network postWithParameter:@{COOKIE:USER_COOKIE,@"page":@(0),state:@(0)} method:getDuoBaoRecords];
}
- (void)setupTitlesView
{
    UIView *titlesView = [[UIView alloc] init];
    titlesView.x = 0;
    titlesView.y = 64;
    titlesView.width = self.view.width;
    titlesView.height = 40;
    titlesView.backgroundColor = self.view.backgroundColor;
    [self.view addSubview:titlesView];
    self.titlesView = titlesView;
    
    // 标题底部的指示线
    UIView *titleUnderlineView = [[UIView alloc] init];
    titleUnderlineView.height = 2;
    titleUnderlineView.y = titlesView.height - titleUnderlineView.height;
       titleUnderlineView.backgroundColor = [UIColor colorWithHexString:@"#ff4640"];
    [titlesView addSubview:titleUnderlineView];
    self.titleUnderlineView = titleUnderlineView;
    //添加分割线
    UIView *devideLine = [[UIView alloc]initWithFrame:CGRectMake(0, titlesView.height - 1, titlesView.width, 1)];
    devideLine.backgroundColor = UIColorFromRGB(0Xdbe4e8);
    [titlesView insertSubview:devideLine belowSubview:self.titleUnderlineView];
    
    // 文字数据
    NSArray *titles = @[@"全部", @"进行中", @"已揭晓"];
    
    // 添加所有的标题文字（所有的按钮）
    CGFloat titleW = titlesView.width / titles.count;
    CGFloat titleH = titlesView.height;
    for (int i = 0; i < titles.count; i++) {
        // 创建按钮
        UIButton *titleButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [titleButton setTitleColor:[UIColor colorWithHexString:@"#ff4640"] forState:UIControlStateSelected];
        [titleButton setTitleColor:[UIColor colorWithHexString:@"#263238"] forState:UIControlStateNormal];
        titleButton.tag = i;
        [titleButton addTarget:self action:@selector(titleClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [titlesView addSubview:titleButton];
        [self.titleButtons addObject:titleButton];
        
        // 设置文字
        [titleButton setTitle:titles[i] forState:UIControlStateNormal];
        
        // 设置frame
        titleButton.width = titleW;
        titleButton.height = titleH;
        titleButton.y = 0;
        titleButton.x = i * titleW;
        
        if (i == 0) {
            // 默认选中第0个按钮
            titleButton.selected = YES;
            self.clickedTitleButton = titleButton;
            // 马上根据文字设置内部label的尺寸
            [titleButton.titleLabel sizeToFit];
            self.titleUnderlineView.width = self.view.width/3;
            self.titleUnderlineView.centerX = titleButton.centerX;
        }
    }
}
#pragma mark - 设置控制器块
- (void)setupAllChildVcs
{
    XRWinRecordTableView *all = [[XRWinRecordTableView alloc]init];
    all.statue = kAll;
    all.titleButtons = self.titleButtons;
    [self addChildViewController:all];
    
    XRWinRecordTableView *ingVC = [[XRWinRecordTableView alloc]init];
    ingVC.statue =kIng;
    ingVC.titleButtons = self.titleButtons;
    [self addChildViewController:ingVC];
    
    XRWinRecordTableView *didVC = [[XRWinRecordTableView alloc]init];
    didVC.statue = kdid;
    didVC.titleButtons = self.titleButtons;
    [self addChildViewController:didVC];
    // 设置contentSize
    CGFloat contentW = self.childViewControllers.count * self.scrollView.width;
    NSLog(@"%f",contentW);
    self.scrollView.contentSize = CGSizeMake(contentW, 0);
    
    
}
- (void)setupScrollView
{
    // 不要自动调整scrollView的inset
    self.automaticallyAdjustsScrollViewInsets = NO;
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 104, VIEW_WIDTH, VIEW_HEIGHT - 104)];
    scrollView.delegate = self;
    scrollView.pagingEnabled = YES;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:scrollView];
    self.scrollView = scrollView;
}
#pragma mark - <UIScrollViewDelegate>
/**
 *  滚动完毕就会调用（如果不是人为拖拽scrollView导致滚动完毕，才会调用这个方法）
 */
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    int index = scrollView.contentOffset.x / scrollView.width;
    UIViewController *willShowChildVc = self.childViewControllers[index];
    
    // 如果这个子控制器的view已经添加过了，就直接返回
    if (willShowChildVc.isViewLoaded) return;
    
    // 添加子控制器的view
    willShowChildVc.view.frame = scrollView.bounds;
    [scrollView addSubview:willShowChildVc.view];
    self.titleUnderlineView.x = scrollView.contentOffset.x / 3;
}
/**
 *  滚动完毕就会调用（如果是人为拖拽scrollView导致滚动完毕，才会调用这个方法）
 */
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    int index = scrollView.contentOffset.x / scrollView.width;
    // 点击对应的按钮
    [self titleClick:self.titleButtons[index]];
    
    // 添加子控制器的view
    [self scrollViewDidEndScrollingAnimation:scrollView];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat dic = scrollView.contentOffset.x - old;
    self.titleUnderlineView.x += dic / 3.0;
    old = scrollView.contentOffset.x;
}

#pragma mark - 监听
/**
 *  点击了顶部的标题按钮
 */
- (void)titleClick:(UIButton *)titleButton
{
    // 修改按钮状态
    self.clickedTitleButton.selected = NO;
    titleButton.selected = YES;
    self.clickedTitleButton = titleButton;
    // 让scrollView滚动到对应的位置(不要去修改contentOffset的y值)
    CGPoint offset = self.scrollView.contentOffset;
    offset.x = titleButton.tag * self.view.width;
    [self.scrollView setContentOffset:offset animated:YES];
}
//网络数据
-(void)successfulWithDic:(NSDictionary *)dic method:(NSString *)method
{
    if ([method isEqualToString:getDuoBaoRecords]) {
        XRWinRecordModel *model = [XRWinRecordModel objectArrayWithKeyValuesArray:dic[DIC_DATA][@"list"]].lastObject;
        if(model){
        self.titleArr  = @[model.allTimes,model.underwayTimes,model.hasOpenTimes];
        [self setupBtnTitle];
        }
    }
}
-(void)setupBtnTitle
{
    // 文字数据
    NSArray *titles = @[@"全部", @"进行中", @"已揭晓"];
    
    for (int i = 0; i<self.titleButtons.count; i++) {
        UIButton *btn = self.titleButtons[i];
        if ([self.titleArr[i] intValue] > 0) {
            [btn setTitle:[NSString stringWithFormat:@"%@(%@)",titles[i],self.titleArr[i]] forState:UIControlStateNormal];
        }
    }
}
- (NSMutableArray *)titleButtons
{
    if (!_titleButtons) {
        _titleButtons = [NSMutableArray array];
    }
    return _titleButtons;
}
-(NSArray *)titleArr
{
    if (!_titleArr) {
        _titleArr  =[NSArray array];
    }
    return _titleArr;
}
@end
