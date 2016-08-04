//
//  PasswordViewController.h
//  Treasure
//
//  Created by 苹果 on 15/10/28.
//  Copyright © 2015年 YDS. All rights reserved.
//

#import "ViewController.h"

@interface PasswordViewController : ViewController
@property (strong, nonatomic) IBOutlet UITextField *passwordTF;
@property (strong, nonatomic) IBOutlet UIButton *sureButton;
@property (assign, nonatomic) NSInteger type;//1 注册  2改密码
@property (nonatomic, strong) NSString * phone;

- (IBAction)sureButtonMethod:(id)sender;
@end
