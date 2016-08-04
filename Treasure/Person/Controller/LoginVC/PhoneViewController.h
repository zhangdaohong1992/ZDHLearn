//
//  PhoneViewController.h
//  Treasure
//
//  Created by 苹果 on 15/10/28.
//  Copyright © 2015年 YDS. All rights reserved.
//

#import "ViewController.h"

@interface PhoneViewController : ViewController
@property (strong, nonatomic) IBOutlet UITextField *phoneTF;
@property (strong, nonatomic) IBOutlet UIButton *sureButton;
@property (assign, nonatomic) NSInteger type;//1 注册  2改密码


- (IBAction)sureButtonMethod:(id)sender;
@end
