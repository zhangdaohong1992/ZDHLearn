//
//  XRUpdataNickNameViewController.m
//  Treasure
//
//  Created by 荣 on 15/11/4.
//  Copyright © 2015年 YDS. All rights reserved.
//

#import "XRUpdataNickNameViewController.h"

@interface XRUpdataNickNameViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *nickField;

@end

@implementation XRUpdataNickNameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:@"修改昵称"];
    [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc]initWithTitle:@"确定" style:UIBarButtonItemStyleDone target:self action:@selector(saveNickName)]];
    _nickField.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
}

-(void)saveNickName
{
    NSString *temp = [_nickField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if(temp.length >= 2 || temp.length <= 12){
        [self.network postWithParameter:@{COOKIE:USER_COOKIE,@"nickName":temp} method:updateUserInfo];
    }
    else{
        [SVProgressHUD showErrorWithStatus:@"字符数不符合要求"];
    }
}
#pragma mark - UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString *temp = [_nickField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if ([string isEqual: @""]) {
        return YES;
    }
    if (textField == self.nickField) {
        return (temp.length < 12);
    }else {
    return YES;
    }
}
#pragma mark - 网络请求
-(void)successfulWithDic:(NSDictionary *)dic method:(NSString *)method
{
    if ([method isEqualToString:updateUserInfo]) {
        if ([self isPostSuccessedWithDic:dic]) {
            [SVProgressHUD showSuccessWithStatus:@"保存成功"];
            [[NSUserDefaults standardUserDefaults]setObject:_nickField.text forKey:@"nickName"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
        }
    }
}
@end
