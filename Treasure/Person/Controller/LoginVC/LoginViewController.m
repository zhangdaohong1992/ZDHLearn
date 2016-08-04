//
//  LoginViewController.m
//  Treasure
//
//  Created by 苹果 on 15/10/28.
//  Copyright © 2015年 YDS. All rights reserved.
//

#import "LoginViewController.h"
#import "MyMD5.h"
#import "PhoneViewController.h"
#import "APService.h"

@interface LoginViewController ()

@property (nonatomic, strong) NSUserDefaults * userDefault;
- (IBAction)cancelBarButtonItemMethod:(id)sender;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.userDefault = [NSUserDefaults standardUserDefaults];
    
    self.loginButton.layer.cornerRadius = self.registButton.layer.cornerRadius = 5.;
    self.loginButton.layer.masksToBounds = self.registButton.layer.masksToBounds = YES;
    self.registButton.layer.borderColor = MAIN_NAV_COLOR.CGColor;
    self.registButton.layer.borderWidth = 1.;
    
    if ([self.userDefault objectForKey:USER_PHONE]) {
        self.phoneTF.text = [self.userDefault objectForKey:USER_PHONE];
    }
    if ([self.userDefault objectForKey:USER_PASSWORD]) {
        self.passwordTF.text = [self.userDefault objectForKey:USER_PASSWORD];
    }

    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    PhoneViewController * phoneVC = [segue destinationViewController];
    if ([segue.identifier isEqualToString:@"registe"]) {
        phoneVC.type = 1;
    }else{
        phoneVC.type = 2;
    }
}


- (IBAction)loginButtonMethod:(id)sender
{
    if (self.phoneTF.text.length != 11) {
        [SVProgressHUD showErrorWithStatus:@"手机号格式错误"];
        return;
    }
    if (self.passwordTF.text.length > 16 || self.passwordTF.text.length < 6) {
        [SVProgressHUD showErrorWithStatus:@"密码长度不符合"];
        return;
    }
    NSString * md5 = [MyMD5 md5ByphoneNumber:self.phoneTF.text code:self.passwordTF.text];
    [self.network postWithParameter:@{@"phone": self.phoneTF.text, @"password": self.passwordTF.text  , @"secretKey": md5} method:login isHud:YES];
}

- (IBAction)registeButtonMethod:(id)sender
{
    [self performSegueWithIdentifier:@"registe" sender:self];
}

- (IBAction)changePasswordButtonMethod:(id)sender
{
    [self performSegueWithIdentifier:@"changepassword" sender:self];
}

- (void)successfulWithDic:(NSDictionary *)dic method:(NSString *)method
{
    if ([method isEqualToString:login]) {
        [ResponseModel showInfoWithString:dic[DIC_INFO]];
        if ([self isPostSuccessedWithDic:dic]) {
            
            [APService setAlias:self.phoneTF.text callbackSelector:nil object:nil];
            [self.userDefault setObject:self.phoneTF.text forKey:USER_PHONE];
            [self.userDefault setObject:self.passwordTF.text forKey:USER_PASSWORD];
            [self.userDefault setObject:dic[DIC_DATA][COOKIE] forKey:COOKIE];
            [self.userDefault setObject:dic[DIC_DATA][@"mode"] forKey:MODE];
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    }
}

- (IBAction)cancelBarButtonItemMethod:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
