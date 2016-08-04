//
//  XRAddAdressViewController.m
//  Treasure
//
//  Created by 荣 on 15/10/28.
//  Copyright © 2015年 YDS. All rights reserved.
//

#import "XRAddAdressViewController.h"
#import "XRUserInfo.h"
#import "XRCityField.h"
#import "UIImage+XRImage.h"
@interface XRAddAdressViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *phoneField;
@property (weak, nonatomic) IBOutlet UITextField *receiveNameField;
@property (weak, nonatomic) IBOutlet XRCityField *areaField;
@property (weak, nonatomic) IBOutlet UITextField *adressField;
@end

@implementation XRAddAdressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
    [btn setTitle:@"保存" forState:UIControlStateNormal];
    [btn sizeToFit];
    [btn setTitleColor:UIColorFromRGB(0x1c87ff) forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(saveInfo) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:btn];
    [self.navigationItem setRightBarButtonItem:rightItem];
    [self.navigationItem setTitle:@"添加地址"];
    _phoneField.delegate = self;
    _receiveNameField.delegate = self;
    _areaField.delegate = self;
    _adressField.delegate = self;
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.adressField.text = [[NSUserDefaults standardUserDefaults]objectForKey:@"address"];
    self.phoneField.text = [[NSUserDefaults standardUserDefaults]objectForKey:USER_PHONE];
    self.areaField.text = [[NSUserDefaults standardUserDefaults]objectForKey:@"area"];
    self.receiveNameField.text = [[NSUserDefaults standardUserDefaults]objectForKey:@"receiveName"];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithRed:236/255.0 green:236/255.0 blue:236/255.0 alpha:1]] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    [self.navigationController.navigationBar setTintColor:[UIColor blackColor]];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor blackColor]}];
    [self.navigationController preferredStatusBarStyle];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear: animated];
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:UIColorFromRGB(0xff4640)] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

-(void)saveInfo
{
    if (self.adressField.text.length < 1 || self.receiveNameField.text.length < 1 || self.phoneField.text.length < 11 || self.areaField.text.length < 1) {
        [ResponseModel showInfoWithString:@"信息不完整,请完善信息"];
        return;
    }
    
    [[NSUserDefaults standardUserDefaults]setObject:self.adressField.text forKey:@"address"];
    [[NSUserDefaults standardUserDefaults]setObject:self.areaField.text forKey:@"area"];
    [[NSUserDefaults standardUserDefaults]setObject:self.receiveNameField.text forKey:@"receiveName"];
    
    NSString *fullAddress = [NSString stringWithFormat:@"%@ %@",_areaField.text,_adressField.text];
    [self.network postWithParameter:@{COOKIE:USER_COOKIE,
                                          @"receiveName":_receiveNameField.text,
                                          @"address":fullAddress,
                                          @"phone":_phoneField.text,
                                          @"id":self.ID}
                                 method:submintOrderInfo isHud:YES];

}

#pragma mark - UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if ([string isEqual: @""]) {
        return YES;
    }
    if (textField == self.phoneField) {
        return (textField.text.length < 11);
    }
    else if (textField == self.receiveNameField){
        return (textField.text.length < 16);
    }
    else if (textField == self.adressField){
        return (textField.text.length < 128);
    }else{
        return YES;
    }
}

-(void)successfulWithDic:(NSDictionary *)dic method:(NSString *)method
{
    if ([method isEqualToString:submintOrderInfo]) {
        if ([self isPostSuccessedWithDic:dic]) {
            [SVProgressHUD showSuccessWithStatus:@"保存成功"];
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}

@end
