//
//  PaySuccessViewController.m
//  Treasure
//
//  Created by 荣 on 15/11/7.
//  Copyright © 2015年 YDS. All rights reserved.
//

#import "PaySuccessViewController.h"
#import "PaySucessCell.h"
#import "RewardNumView.h"
#import "XRWinRecordViewController.h"

@interface PaySuccessViewController ()<UITableViewDataSource,UITabBarDelegate>

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end

@implementation PaySuccessViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"支付成功";
    self.tableView.tableFooterView = [UIView new];
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 70;
    self.titleLabel.text = [NSString stringWithFormat:@"已成功支付%ld件商品",(unsigned long)_modelArr.count];
    
    [self.navigationItem setLeftBarButtonItem:[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"back-icon"] style:UIBarButtonItemStylePlain target:self action:@selector(popToRoot)]];
}

-(void)popToRoot
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (IBAction)gotoDuoBaoRecord:(id)sender {
    XRWinRecordViewController *duoBao = [[XRWinRecordViewController alloc]init];
    [self.navigationController pushViewController:duoBao animated:YES];
}
- (IBAction)gotoBuy:(id)sender {
    [self.tabBarController setSelectedIndex:0];
    [self.navigationController popToRootViewControllerAnimated:NO];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.modelArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PaySucessCell *cell = [tableView dequeueReusableCellWithIdentifier:@"successPay"];
    if (!cell) {
        cell = [[NSBundle mainBundle]loadNibNamed:NSStringFromClass([PaySucessCell class]) owner:self options:nil].lastObject;
    }
    cell.model = self.modelArr[indexPath.row];
    
    return cell;
}
@end
