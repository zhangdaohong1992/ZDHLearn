//
//  HomeCategoryViewController.m
//  Treasure
//
//  Created by 苹果 on 16/4/6.
//  Copyright © 2016年 YDS. All rights reserved.
//

#import "HomeCategoryViewController.h"
#import "CategoryCollectionViewCell.h"
#import "SearchDetailViewController.h"
#import "CategoryModel.h"

static NSString * identifier = @"categoryCell";
static NSString * searchIdentifier = @"searchCell";

@interface HomeCategoryViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout,UISearchBarDelegate, UISearchDisplayDelegate, UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) IBOutlet UICollectionViewFlowLayout *layout;

@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) NSArray * searchArray ;
@property (nonatomic, strong) UISearchBar * searchBar;
@property (nonatomic, strong) UISearchDisplayController *searchDisplay;

@property (nonatomic, strong) NSArray * dataArray;
@property (nonatomic, assign) NSInteger selectItemId;
@property (nonatomic, strong) NSString * categoryName;
@property (nonatomic, strong) NSString * metnodName;
@property (nonatomic, strong) NSString * searchText;

@end

@implementation HomeCategoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CGSize size = CGSizeMake((VIEW_WIDTH - 3) / 2., 70);
    self.layout.itemSize = size;
    NSLog(@"item.size = %@", NSStringFromCGSize(self.layout.itemSize));
    self.layout.minimumLineSpacing = 1;
    self.layout.minimumInteritemSpacing = 1;
    
    [self.network postWithParameter:@{} method:getCategories];
    

    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([CategoryCollectionViewCell class]) bundle:nil] forCellWithReuseIdentifier:identifier];
    
    [self.network postWithParameter:@{} method:getHotWords];
    
    [self addSearchView];
    [self addTabelView];
    // Do any additional setup after loading the view from its nib.
}

- (void)addSearchView
{
    [[UIBarButtonItem appearanceWhenContainedIn: [UISearchBar class], nil] setTintColor:[UIColor whiteColor]];

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
    
}

- (void)addTabelView
{
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.hidden = YES;
    self.tableView.tableFooterView = [UIView new];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:searchIdentifier];
    [self.view addSubview:self.tableView];
}

- (void)searchBarMethod
{
    [self jumpToDetailVC];
}

- (void)jumpToDetailVC
{
    [self.searchBar resignFirstResponder];
    if (!self.searchText.length) {
        [ResponseModel showInfoWithString:@"输入想要搜索的商品名称"];
        return;
    }
    self.metnodName = queryItem;
    [self performSegueWithIdentifier:@"categorySearchDetail" sender:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UISearchBarDelegate
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    self.tableView.hidden = NO;
    [searchBar setShowsCancelButton:YES animated:YES];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    self.tableView.hidden = YES;
    [searchBar setShowsCancelButton:NO animated:YES];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    self.searchText = searchBar.text;
    [self jumpToDetailVC];
}

- (BOOL)searchBar:(UISearchBar *)searchBar shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if([text isEqualToString:@""]){
        return YES;
    }
    if(searchBar.text.length > 11){
        return NO;
    }
    return YES;
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.searchArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:searchIdentifier forIndexPath:indexPath];
    [cell.textLabel setFont:[UIFont systemFontOfSize:13]];
    [cell.textLabel setTextColor:UIColorFromRGB(0x78909c)];
    cell.textLabel.text = self.searchArray[indexPath.row];
    return cell;
}

#pragma mark  - UITableViewDataSource
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    self.searchText = self.searchArray[indexPath.row];
    [self jumpToDetailVC];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CategoryCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    if (self.dataArray.count > indexPath.row) {
        CategoryModel * model = self.dataArray[indexPath.row];
        cell.titleLabel.text = model.name;
    }
    return cell;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.dataArray.count > indexPath.row) {
        CategoryModel * model = self.dataArray[indexPath.row];
        self.selectItemId = model.categoryId;
        self.categoryName = model.name;
        self.metnodName = getItemsByCatagoryAndSort;
        [self performSegueWithIdentifier:@"categorySearchDetail" sender:self];
    }
}

#pragma mark - network
- (void)successfulWithDic:(NSDictionary *)dic method:(NSString *)method
{
    if ([method isEqualToString:getCategories]) {
        if ([self isPostSuccessedWithDic:dic]) {
            self.dataArray = [CategoryModel objectArrayWithKeyValuesArray:dic[DIC_DATA][@"categoryList"]];
            [self.collectionView reloadData];
        }
    }
    if ([method isEqualToString:getHotWords]) {
        if ([self isPostSuccessedWithDic:dic]) {
            NSString * string = dic[DIC_DATA][@"hotWords"];
            if (![string isKindOfClass:[NSNull class]]) {
                self.searchArray = [string componentsSeparatedByString:@","];
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
    if ([segue.identifier isEqualToString:@"categorySearchDetail"]) {
        SearchDetailViewController * detailVC = [segue destinationViewController];
        detailVC.methodName = self.metnodName;
        detailVC.catagoryId = self.selectItemId;
        detailVC.searchTitle = [self.metnodName isEqualToString:queryItem] ? self.searchText : self.categoryName;
    }
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


@end
