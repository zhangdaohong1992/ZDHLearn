//
//  LoginViewController.h
//  Treasure
//
//  Created by 苹果 on 15/10/28.
//  Copyright © 2015年 YDS. All rights reserved.
//

#import "ViewController.h"

typedef NS_ENUM(NSInteger, RegisterOrChangeCode) {
    Register      = 1,
    ChangeCode    = 2,
};

@interface LoginViewController : ViewController
@property (strong, nonatomic) IBOutlet UITextField *phoneTF;
@property (strong, nonatomic) IBOutlet UITextField *passwordTF;
@property (strong, nonatomic) IBOutlet UIButton *loginButton;
@property (strong, nonatomic) IBOutlet UIButton *registButton;
@property (strong, nonatomic) IBOutlet UIButton *changePasswordButton;

- (IBAction)loginButtonMethod:(id)sender;
- (IBAction)registeButtonMethod:(id)sender;
- (IBAction)changePasswordButtonMethod:(id)sender;

@end
