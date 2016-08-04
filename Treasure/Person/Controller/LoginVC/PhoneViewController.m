//
//  PhoneViewController.m
//  Treasure
//
//  Created by 苹果 on 15/10/28.
//  Copyright © 2015年 YDS. All rights reserved.
//

#import "PhoneViewController.h"
#import "VertifyViewController.h"

@interface PhoneViewController ()<UIAlertViewDelegate>

@end

@implementation PhoneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.phoneTF becomeFirstResponder];
    UIView * leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 55)];
    self.phoneTF.leftView = leftView;
    self.phoneTF.leftViewMode = UITextFieldViewModeAlways;

    self.phoneTF.layer.cornerRadius = self.sureButton.layer.cornerRadius = 5.;
    self.phoneTF.layer.masksToBounds = self.sureButton.layer.masksToBounds = YES;
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        [self.network postWithParameter:@{@"phone": _phoneTF.text, @"type": @(_type)} method:getCellPhoneCheckCode isHud:YES];
    }
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"vertify"]) {
        VertifyViewController * vertifyVC = [segue destinationViewController];
        vertifyVC.type = self.type;
        vertifyVC.phoneNumber = self.phoneTF.text;
    }
}


- (IBAction)sureButtonMethod:(id)sender
{
    [self.view endEditing:YES];
    if (self.phoneTF.text.length != 11) {
        [SVProgressHUD showInfoWithStatus:@"错误的手机号码"];
        return;
    }
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"短信验证码将发送至:" message:_phoneTF.text delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alert show];
}

- (void)successfulWithDic:(NSDictionary *)dic method:(NSString *)method
{
    [ResponseModel showInfoWithString:dic[DIC_INFO]];
    if ([method isEqualToString:getCellPhoneCheckCode]) {
        if ([self isPostSuccessedWithDic:dic]) {
            [self performSegueWithIdentifier:@"vertify" sender:self];
        }
    }
}
@end
