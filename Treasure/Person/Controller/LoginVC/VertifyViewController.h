//
//  VertifyViewController.h
//  Treasure
//
//  Created by 苹果 on 15/10/28.
//  Copyright © 2015年 YDS. All rights reserved.
//

#import "ViewController.h"

@interface VertifyViewController : ViewController
@property (strong, nonatomic) IBOutlet UITextField *vertifyTF;
@property (strong, nonatomic) IBOutlet UIButton *sureButton;
@property (assign, nonatomic) NSInteger type;//1 注册  2改密码
@property (strong, nonatomic) NSString * phoneNumber;
@property (strong, nonatomic) IBOutlet UIButton *verifyButton;

- (IBAction)sureButtonMethod:(id)sender;
- (IBAction)verifyButtonMethod:(id)sender;
@end
