//
//  BaseTableViewController.m
//  Treasure
//
//  Created by 苹果 on 15/10/20.
//  Copyright © 2015年 YDS. All rights reserved.
//

#import "BaseTableViewController.h"
#import "BaseNetworkModel.h"

@interface BaseTableViewController ()

@end

@implementation BaseTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.network = [BaseNetworkModel shareBaseNetwork];
    self.network.delegate = self;
    
    [self addNoMoreDataLabel];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)addNoMoreDataLabel
{
    self.noMoreDataLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 20)];
    self.noMoreDataLabel.text = @"现在没有数据哦";
    self.noMoreDataLabel.center = self.view.center;
    self.noMoreDataLabel.centerY = self.view.centerY - 50;
    self.noMoreDataLabel.hidden = YES;
    self.noMoreDataLabel.textAlignment = NSTextAlignmentCenter;
    self.noMoreDataLabel.textColor = [UIColor grayColor];
    [self.view addSubview:self.noMoreDataLabel];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

#pragma mark - BaseNetworkDelegate
- (void)successfulWithValue:(id)value method:(NSString *)method
{
    if ([value isKindOfClass:[NSDictionary class]]) {
        NSDictionary * dic = [NSDictionary dictionaryWithDictionary:value];
        NSLog(@"dic = %@", dic);
        [self successfulWithDic:dic method:method];
        if (![self isPostSuccessedWithDic:dic]) {
            [ResponseModel showInfoWithString:dic[DIC_INFO]];
        }
        if ([dic[DIC_ERRCODE] integerValue] == 2) {
            [self login];
        }
    }
}

- (BOOL)isPostSuccessedWithDic:(NSDictionary *)dic
{
    BOOL isSuccess = NO;
    if ([[dic objectForKey:DIC_ERRCODE] integerValue] == 0) {
        isSuccess = YES;
    }
    return isSuccess;
}

- (void)successfulWithDic:(NSDictionary *)dic method:(NSString *)method
{
    //subclass implementation
}

- (void)errorHandle:(NSError *)error method:(NSString *)method
{
    
}

- (void)login
{
    UINavigationController * nav = [self.storyboard instantiateViewControllerWithIdentifier:@"login"];
    [self presentViewController:nav animated:YES completion:nil];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
