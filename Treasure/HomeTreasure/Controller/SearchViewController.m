//
//  SearchViewController.m
//  Treasure
//
//  Created by 苹果 on 15/10/20.
//  Copyright © 2015年 YDS. All rights reserved.
//

#import "SearchViewController.h"
#import "SearchDetailViewController.h"

@interface SearchViewController ()<UISearchBarDelegate, UISearchDisplayDelegate>

@property (nonatomic, strong) NSArray * dataArray ;
@property (nonatomic, strong) UISearchBar * searchBar;
@property (nonatomic, strong) UISearchDisplayController *searchDisplay;

@end

static NSString * identifier = @"searchCell";

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.dataArray = [NSArray array];
    [self.network postWithParameter:@{} method:getHotWords];
    self.tableView.tableFooterView = [UIView new];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:identifier];
    [self addSearchView];
    [self.searchBar becomeFirstResponder];
    // Do any additional setup after loading the view.
}

- (void)addSearchView
{
    self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, VIEW_WIDTH - 200, 30)];
    _searchBar.delegate = self;
    _searchBar.tintColor = [UIColor blueColor];
    _searchBar.placeholder = @"搜索";
    _searchBar.backgroundImage = [UIImage new];
    [self.navigationItem setTitleView:_searchBar];
    
    self.searchDisplay = [[UISearchDisplayController alloc] initWithSearchBar:_searchBar contentsController:self];
    _searchDisplay.searchResultsDataSource = self;
    _searchDisplay.searchResultsDelegate =self;
    _searchDisplay.searchResultsTableView.tableFooterView = [UIView new];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.definesPresentationContext = YES;

    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"search"] style:UIBarButtonItemStylePlain target:self action:@selector(searchBarMethod)];
}

//- (void)viewWillAppear:(BOOL)animated
//{
//    [super viewWillAppear:animated];
//    [self addSearchView];
//    [self.searchBar becomeFirstResponder];
//}
//
//- (void)viewWillDisappear:(BOOL)animated
//{
//    [super viewWillDisappear:animated];
//    [self.searchBar removeFromSuperview];
//}

- (void)searchBarMethod
{
    [self jumpToDetailVC];
}

- (void)jumpToDetailVC
{
    if (self.searchBar.text.length < 1) {
        [ResponseModel showInfoWithString:@"输入想要搜索的商品名称"];
        return;
    }
    [self performSegueWithIdentifier:@"searchDetail" sender:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UISearchBarDelegate
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self jumpToDetailVC];
}

- (BOOL)searchBar:(UISearchBar *)searchBar shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text NS_AVAILABLE_IOS(3_0)
{
    if([text isEqualToString:@""]){
        return YES;
    }
    if(searchBar.text.length > 11){
        return NO;
    }
    return YES;
}

#pragma mark  - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    [cell.textLabel setFont:[UIFont systemFontOfSize:13]];
    [cell.textLabel setTextColor:UIColorFromRGB(0x78909c)];
    cell.textLabel.text = self.dataArray[indexPath.row];
    return cell;
}

#pragma mark  - UITableViewDataSource
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    self.searchBar.text = self.dataArray[indexPath.row];
    [self jumpToDetailVC];
}


- (void)successfulWithDic:(NSDictionary *)dic method:(NSString *)method
{
    if ([method isEqualToString:getHotWords]) {
        if ([self isPostSuccessedWithDic:dic]) {
            NSString * string = dic[DIC_DATA][@"hotWords"];
            if (![string isKindOfClass:[NSNull class]]) {
                self.dataArray = [string componentsSeparatedByString:@","];
            }
            [self.tableView reloadData];
        }else{
            [ResponseModel showInfoWithString:dic[DIC_INFO]];
        }
    }
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"searchDetail"]) {
        SearchDetailViewController * searchDetailVC = [segue destinationViewController];
        searchDetailVC.searchTitle = self.searchBar.text;
        searchDetailVC.methodName = queryItem;
    }
}


@end
