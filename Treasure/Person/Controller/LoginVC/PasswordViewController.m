//
//  PasswordViewController.m
//  Treasure
//
//  Created by 苹果 on 15/10/28.
//  Copyright © 2015年 YDS. All rights reserved.
//

#import "PasswordViewController.h"
#import "MyMD5.h"
#import "LoginViewController.h"
#import <AdSupport/AdSupport.h>
#import "APService.h"

@interface PasswordViewController ()

@property (nonatomic, strong) NSUserDefaults * userDefault;

@end

@implementation PasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.userDefault = [NSUserDefaults standardUserDefaults];
    
    [self.passwordTF becomeFirstResponder];
    UIView * leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 55)];
    self.passwordTF.leftView = leftView;
    self.passwordTF.leftViewMode = UITextFieldViewModeAlways;
    
    self.passwordTF.layer.masksToBounds = self.sureButton.layer.masksToBounds = YES;
    self.passwordTF.layer.cornerRadius = self.sureButton.layer.cornerRadius = 5;
    if (self.type == Register) {
        self.title = @"设置密码";
    }
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)sureButtonMethod:(id)sender
{
    if (self.passwordTF.text.length < 6 || self.passwordTF.text.length > 16) {
        [ResponseModel showInfoWithString:@"密码长度不对哦"];
        return;
    }
    NSString * secretKey = [MyMD5 md5ByphoneNumber:self.phone code:self.passwordTF.text];
    NSString * idfa = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];

    if (self.type == Register) {
        [self.network postWithParameter:@{@"phone":self.phone, @"password":self.passwordTF.text, @"secretKey":secretKey, @"token":idfa, @"platform":@"IOS"} method:registe isHud:YES];
    }else if (self.type == ChangeCode){
        [self.network postWithParameter:@{@"phone":self.phone, @"password":self.passwordTF.text, @"secretKey":secretKey} method:changePassword isHud:YES];
    }
}

- (void)successfulWithDic:(NSDictionary *)dic method:(NSString *)method
{
    [ResponseModel showInfoWithString:dic[DIC_INFO]];
    if ([method isEqualToString:changePassword] || [method isEqualToString:registe]) {
        if ([self isPostSuccessedWithDic:dic]) {
            NSString * md5 = [MyMD5 md5ByphoneNumber:self.phone code:self.passwordTF.text];
            [self.network postWithParameter:@{@"phone": self.phone, @"password": self.passwordTF.text  , @"secretKey": md5} method:login isHud:YES];
        }
    }
    if ([method isEqualToString:login]) {
        if ([self isPostSuccessedWithDic:dic]) {
            
            [APService setAlias:self.phone callbackSelector:nil object:nil];
            [self.userDefault setObject:self.phone forKey:USER_PHONE];
            [self.userDefault setObject:self.passwordTF.text forKey:USER_PASSWORD];
            [self.userDefault setObject:dic[DIC_DATA][COOKIE] forKey:COOKIE];
            [self.userDefault setObject:dic[DIC_DATA][@"mode"] forKey:MODE];
            for (UIViewController * vc in self.navigationController.viewControllers) {
                if ([vc isKindOfClass:[LoginViewController class]]) {
                    [vc dismissViewControllerAnimated:YES completion:nil];
                }
            }
        }
    }
}

@end
