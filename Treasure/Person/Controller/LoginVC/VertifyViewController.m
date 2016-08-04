//
//  VertifyViewController.m
//  Treasure
//
//  Created by 苹果 on 15/10/28.
//  Copyright © 2015年 YDS. All rights reserved.
//

#import "VertifyViewController.h"
#import "PasswordViewController.h"

@interface VertifyViewController ()

@end

@implementation VertifyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.vertifyTF becomeFirstResponder];
    UIView * leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 55)];
    self.vertifyTF.leftView = leftView;
    self.vertifyTF.leftViewMode = UITextFieldViewModeAlways;
    self.sureButton.layer.masksToBounds = self.verifyButton.layer.masksToBounds = self.vertifyTF.layer.masksToBounds = YES;
    self.sureButton.layer.cornerRadius = self.verifyButton.layer.cornerRadius = self.vertifyTF.layer.cornerRadius = 5.;
    
    [self verifyTimerMethod];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)verifyTimerMethod
{
    __block int timeout = 60; //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if(timeout<=0){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                _verifyButton.titleLabel.text = @"重新发送";
                _verifyButton.backgroundColor = UIColorFromRGB(0x1C87FF);
                _verifyButton.userInteractionEnabled = YES;
            });
        }else{
            int seconds = timeout % 60;
            NSString *strTime = [NSString stringWithFormat:@"%.2d", seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                _verifyButton.titleLabel.text = @"";
                _verifyButton.backgroundColor = [UIColor lightGrayColor];
                _verifyButton.titleLabel.textAlignment = NSTextAlignmentCenter;
                _verifyButton.userInteractionEnabled = NO;
                _verifyButton.titleLabel.text = [NSString stringWithFormat:@"重新发送(%@)",strTime];
                [_verifyButton setTitle:[NSString stringWithFormat:@"重新发送(%@)",strTime] forState:UIControlStateNormal];
            });
            timeout--;
        }
    });
    dispatch_resume(_timer);
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"changeCode"]) {
        PasswordViewController * passwordVC = [segue destinationViewController];
        passwordVC.phone = self.phoneNumber;
        passwordVC.type = self.type;
    }
}

- (IBAction)sureButtonMethod:(id)sender
{
    [self.view endEditing:YES];
    if (self.vertifyTF.text.length < 1 || self.vertifyTF.text.length > 8) {
        [ResponseModel showInfoWithString:@"请输入正确的验证码"];
        return;
    }
    [self.network postWithParameter:@{@"phone":self.phoneNumber, @"checkCode":self.vertifyTF.text} method:checkCellPhoneCheckCode isHud:YES];
}

- (IBAction)verifyButtonMethod:(id)sender
{
    [self verifyTimerMethod];
    [self.network postWithParameter:@{@"phone":self.phoneNumber, @"type":@(_type)} method:getCellPhoneCheckCode isHud:YES];
}

- (void)successfulWithDic:(NSDictionary *)dic method:(NSString *)method
{
    [ResponseModel showInfoWithString:dic[DIC_INFO]];
    if ([method isEqualToString:checkCellPhoneCheckCode]) {
        if ([self isPostSuccessedWithDic:dic]) {
            [self performSegueWithIdentifier:@"changeCode" sender:self];
        }
    }
}
@end
