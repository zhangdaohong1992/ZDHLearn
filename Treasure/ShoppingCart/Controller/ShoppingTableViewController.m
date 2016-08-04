//
//  ShoppingTableViewController.m
//  Treasure
//
//  Created by 苹果 on 15/10/30.
//  Copyright © 2015年 YDS. All rights reserved.
//

#import "ShoppingTableViewController.h"
#import "ShopingCartTableViewCell.h"
#import "HomeGoodsModel.h"
#import "HomeGoodsModelHandle.h"
#import "BuyBottomView.h"
#import "PayViewController.h"
#import "PAStepper.h"
#import "ShopcartNoResultView.h"

static NSString * identifier = @"shoppcart";
@interface ShoppingTableViewController ()

@property (nonatomic, strong) NSArray * dataArray;
@property (nonatomic, strong) UIWindow * window;
@property (nonatomic, strong) BuyBottomView * buyBottomView;
@property (nonatomic, strong) ShopcartNoResultView * noResultView;

@property (nonatomic, weak)UIButton *rightBtn;
@property(nonatomic,strong)NSString *itemString;
@property(nonatomic,strong)NSString *joinCountString;

@property(nonatomic,assign)int allBuyCount;
@property(nonatomic,assign)int restCount;/**<删除操作后bottomView剩下的价格 */

@end


@implementation ShoppingTableViewController

static int allSpend;
static int oldCount;
static NSInteger selectedCount;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataArray = [NSMutableArray array];
    self.window = [[UIApplication sharedApplication].delegate window];
    
    [self setupRightItem];
    [self setupTabelView];
    [self addNoMoreResultView];
    
}

-(void)setServerTime:(NSString *)serverTime
{
    __block NSInteger timeout = [self theCountdownTimeConversion:serverTime]; //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if(timeout <= 0){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                
            });
        }else{
            
            NSInteger hourTime = timeout / 3600;
            NSInteger minutesTime = (timeout - hourTime * 3600) / 60;
            NSInteger secondTime = timeout - hourTime * 3600 - minutesTime * 60;
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
//                [hourBtn setTitle:[NSString stringWithFormat:@"%ld", hourTime] forState:UIControlStateNormal];
//                [minuteBtn setTitle:[NSString stringWithFormat:@"%ld", minutesTime] forState:UIControlStateNormal];
//                [secondBtn setTitle:[NSString stringWithFormat:@"%ld", secondTime] forState:UIControlStateNormal];
                
            });
            timeout--;
            
        }
    });
    dispatch_resume(_timer);
}

-(NSInteger)theCountdownTimeConversion:(NSString *)serverTime
{
    NSTimeZone* localzone = [NSTimeZone localTimeZone];
    NSTimeZone* timeZone = [NSTimeZone timeZoneForSecondsFromGMT:0];
    //先把时间转换成年月日
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[serverTime integerValue]];
    NSDateFormatter *format = [[NSDateFormatter alloc]init];
    [format setTimeZone:timeZone];
    format.dateFormat = @"yyyy-MM-dd";
    NSString * timeStr = [format stringFromDate:date];
    //再把年月日转换时间戳
    [format setTimeZone:localzone];
    NSDate * timeDeta = [format dateFromString:timeStr]; //------------将字符串按formatter转成nsdate
    NSString * timeSp = [NSString stringWithFormat:@"%ld", (long)[timeDeta timeIntervalSince1970]];
    NSInteger  downTime = [timeSp integerValue]  + 24 * 3600 - [serverTime integerValue] - 1;
    return downTime;
}


- (void)addNoMoreResultView
{
    self.noResultView = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([ShopcartNoResultView class]) owner:self options:nil] lastObject];
    self.noResultView.frame = CGRectMake(0, 0, 150, 179);
    self.noResultView.center = self.view.center;
    [self.noResultView.goButton addTarget:self action:@selector(noResultViewButtonMethod) forControlEvents:UIControlEventTouchUpInside];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.view addSubview:self.noResultView];
    });
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setupBottomView];
    
    self.dataArray = [HomeGoodsModelHandle queryData:nil];
    
    [self updataDataArray];
    
    [self.tableView reloadData];
    
    [self loadBottomDataFromDataArr:self.dataArray];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.buyBottomView removeFromSuperview];
    _rightBtn.selected = NO;
}

- (void)noResultViewButtonMethod
{
    [self.tabBarController setSelectedIndex:0];
}

-(void)setupBottomView
{
    self.buyBottomView = [BuyBottomView initViewWithFrame:CGRectMake(0, VIEW_HEIGHT - 49 - 48, VIEW_WIDTH, 48)];
    [self.buyBottomView.buyButton addTarget:self action:@selector(buyButtonMethod) forControlEvents:UIControlEventTouchUpInside];
    [self.buyBottomView.deleteButton addTarget:self action:@selector(deleteButtonMethod) forControlEvents:UIControlEventTouchUpInside];
    [self.buyBottomView.allSelectButton addTarget:self action:@selector(allSelectButtonMethod:) forControlEvents:UIControlEventTouchUpInside];
    [self.window addSubview:self.buyBottomView];
}

-(void)setupTabelView
{
//    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([ShopingCartTableViewCell class]) bundle:nil] forCellReuseIdentifier:identifier];
    self.tableView.rowHeight = 118;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 1, VIEW_WIDTH, 98)];
}

-(void)setupRightItem
{
    UIButton *editBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 40, 50)];
    [editBtn setTitle:@"编辑" forState:UIControlStateNormal];
    [editBtn setTitle:@"完成" forState:UIControlStateSelected];
    [editBtn addTarget:self action:@selector(changeEditState:) forControlEvents:UIControlEventTouchUpInside];
    self.rightBtn = editBtn;
    UIBarButtonItem *editItem = [[UIBarButtonItem alloc]initWithCustomView:editBtn];
    //    self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.navigationItem.rightBarButtonItem = editItem;
    // Do any additional setup after loading the view.
}

#pragma mark - 数据处理
//向服务器请求更新模型数据
-(void)updataDataArray
{
    NSMutableString *strM = [NSMutableString string];
    for (int i =0; i<self.dataArray.count; i++) {
        HomeGoodsModel *model = self.dataArray[i];
        //从model中获取原始数据
        [strM appendString:model.itemTermID];
        [strM appendString:@","];
    }
    if ([strM hasSuffix:@","]) {
        [strM deleteCharactersInRange:NSMakeRange(strM.length-1,1)];
    }
    if (strM.length) {
        [self.network postWithParameter:@{@"itemTermIds":strM} method:flushCart];
    }
}

//从模型数组中更新bottom数据
-(void)loadBottomDataFromDataArr:(NSArray *)arr
{
    int spend = 0;
    for (HomeGoodsModel *model in arr) {
        spend += model.joinCount;
    }
    _buyBottomView.titleLabel.text = [NSString stringWithFormat:@"总共%@件商品,合计%@元",@(arr.count),@(spend)];
    oldCount = spend;
    _restCount = spend;
}
//把数据库数据全部清除
-(void)deleteAllInSql
{
    [HomeGoodsModelHandle deleteData:nil];
    UITabBarItem * item = self.tabBarController.tabBar.items[3];
    self.dataArray = [HomeGoodsModelHandle queryData:nil];
    item.badgeValue = nil;
}
#pragma mark - 点击后响应方法

-(void)changeEditState:(UIButton *)btn
{
    self.buyBottomView.isDelete = !btn.selected;
    btn.selected = !btn.selected;
    selectedCount = 0;
    _buyBottomView.totalCountLabel.text = [NSString stringWithFormat:@"已选择%@件商品",@(selectedCount)];
    
    for (HomeGoodsModel *model in self.dataArray) {
        model.editState = btn.selected;
        if(!model.isEditState){
            model.selected = NO;
            _buyBottomView.allSelectButton.selected = NO;
        }
    }
    
    [self.tableView reloadData];
}

- (void)buyButtonMethod
{
    if (!USER_COOKIE) {
        [self login];
        return;
    }
    NSMutableString * itemString = [NSMutableString string];
    NSMutableString * joinCountString = [NSMutableString string];
    for (HomeGoodsModel * model in self.dataArray) {
        [itemString appendString:model.itemTermID];
        [itemString appendString:@","];
        [joinCountString appendString:[NSString stringWithFormat:@"%@", @(model.joinCount)]];
        [joinCountString appendString:@","];
    }
    if ([itemString hasSuffix:@","]) {
        [itemString deleteCharactersInRange:NSMakeRange(itemString.length - 1, 1)];
    }
    if ([joinCountString hasSuffix:@","]) {
        [joinCountString deleteCharactersInRange:NSMakeRange(joinCountString.length - 1, 1)];
    }
    _itemString = itemString;
    _joinCountString = joinCountString;
    NSLog(@"itemtermID = %@ joincount = %@", itemString, joinCountString);
    if (!_itemString.length || !_joinCountString.length) {
        [ResponseModel showInfoWithString:@"购物车里还没有东西哦"];
        return;
    }
    [self performSegueWithIdentifier:@"gotoPay" sender:nil];
}

- (void)deleteButtonMethod
{
    NSMutableArray *deleteArr = [NSMutableArray array];
    for (HomeGoodsModel *model in self.dataArray) {
        if (model.isSelected) {
            [deleteArr addObject:model];
        }
    }
    //从数据库删除isselected的model
    if (deleteArr.count) {
        for (HomeGoodsModel *model in deleteArr) {
            NSString *deleteSql = [NSString stringWithFormat:@"DELETE FROM HomeGoodsModelHandle WHERE %@ = %d;", ITEM_ID, model.itemId];
            [HomeGoodsModelHandle deleteData:deleteSql];
        }
        self.dataArray = [HomeGoodsModelHandle queryData:nil];
        
        [self updataDataArray];
        
        [self getBadgeValue];
        _rightBtn.selected = YES;
        [self changeEditState:_rightBtn];
        
        [self.tableView reloadData];
        
        [self loadBottomDataFromDataArr:self.dataArray];
        //从数据库中重新加载模型数组
        allSpend = _restCount;
    }
}

- (void)allSelectButtonMethod:(UIButton *)btn
{
    btn.selected = !btn.selected;
    for (HomeGoodsModel *model in self.dataArray) {
        model.selected = btn.selected;
    }if (btn.selected) {
        selectedCount = self.dataArray.count;
        }else{
        selectedCount = 0;
    }
    _buyBottomView.totalCountLabel.text = [NSString stringWithFormat:@"已选择%@件商品",@(selectedCount)];
    [self.tableView reloadData];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    PayViewController *vc = segue.destinationViewController;
    vc.payCount = allSpend;
    vc.itemString = _itemString;
    vc.joinCountString = _joinCountString;
    
    vc.shopVc = self;
}

- (void)getBadgeValue
{
    UITabBarItem * item = self.tabBarController.tabBar.items[3];
    item.badgeValue = [[HomeGoodsModelHandle tabbarBadgeValue] isEqualToString:@"0"] ? nil : [HomeGoodsModelHandle tabbarBadgeValue];
}

-(void)clickStep:(int)newCount
{
    allSpend+= newCount;
    oldCount = newCount;
    [self loadBottomDataFromDataArr:self.dataArray];
    allSpend = _restCount;
}

#pragma mark - UITableViewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    ShopingCartTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    
    ShopingCartTableViewCell * cell = (ShopingCartTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    cell.userInteractionEnabled = YES;
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([ShopingCartTableViewCell class]) owner:self options:nil] lastObject];
    }
    
    cell.stepChange = ^(int newCount){
        [self clickStep:newCount];
    };
    
    cell.selectState = ^(ShopingCartTableViewCell *selectCell){
        if (selectCell.model.isSelected) {
            selectedCount++;
        }else{
            selectedCount--;
        }
        _buyBottomView.totalCountLabel.text = [NSString stringWithFormat:@"已选择%@件商品",@(selectedCount)];
        _buyBottomView.allSelectButton.selected = (selectedCount == self.dataArray.count);
        [self.tableView reloadData];
    };
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.model = self.dataArray[indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (self.rightBtn.selected) {
        
        ShopingCartTableViewCell * cell = (ShopingCartTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
        [cell checkBtnClick:cell.checkBtn];
        
        
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.rightBtn.selected) {
        return NO;
    }
    return YES;
}
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        ShopingCartTableViewCell * cell = (ShopingCartTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
        
        NSString *deleteSql = [NSString stringWithFormat:@"DELETE FROM HomeGoodsModelHandle WHERE %@ = %d;", ITEM_ID, cell.model.itemId];
        [HomeGoodsModelHandle deleteData:deleteSql];
        self.dataArray = [HomeGoodsModelHandle queryData:nil];
        
        [self updataDataArray];
        [self getBadgeValue];
        [self.tableView reloadData];
        [self loadBottomDataFromDataArr:self.dataArray];
        //从数据库中重新加载模型数组
        allSpend = _restCount;
        
        
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    self.noResultView.hidden = self.dataArray.count ? YES : NO;
    return self.dataArray.count;
}

#pragma mark - 网络请求
- (void)successfulWithDic:(NSDictionary *)dic method:(NSString *)method
{
    if ([method isEqualToString:flushCart]) {
        if ([self isPostSuccessedWithDic:dic]) {
            for (HomeGoodsModel *model in self.dataArray) {
                    NSDictionary *modelDic = [dic[DIC_DATA] objectForKey:model.itemTermID];
                    if ([modelDic[@"restCount"] integerValue] <= 0) {
                        model.restCount = modelDic[@"allCount"];
                        [SVProgressHUD showErrorWithStatus:@"商品已过期~已为您从购物车中除去"];
                        [HomeGoodsModelHandle deleteByModel:model];
                    }else{
                        model.allCount =  modelDic[@"allCount"];
                        model.itemTermID = modelDic[@"id"];
                        model.restCount = modelDic[@"restCount"];
                        model.term = modelDic[@"term"];
                        [HomeGoodsModelHandle saveWithHomeGoodsModel:model];
                    }
            }
            self.dataArray = [HomeGoodsModelHandle queryData:nil];
            UITabBarItem * item = self.tabBarController.tabBar.items[3];
            item.badgeValue = [NSString stringWithFormat:@"%ld",(unsigned long)self.dataArray.count];
            if (self.dataArray.count == 0) {
                item.badgeValue = nil;
            }
            [self loadBottomDataFromDataArr:self.dataArray];
            [self.tableView reloadData];
        }
    }
}

@end
