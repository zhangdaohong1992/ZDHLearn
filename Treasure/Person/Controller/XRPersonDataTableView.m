//
//  XRPersonDataTableView.m
//  Treasure
//
//  Created by 荣 on 15/10/28.
//  Copyright © 2015年 YDS. All rights reserved.
//

#import "XRPersonDataTableView.h"
#import "XRAddAdressViewController.h"
#import "XRUpdataNickNameViewController.h"
#import "XRUserInfo.h"
#import "UIImage+XRImage.h"
#import "RootVCHandle.h"
#import <QiniuSDK.h>

typedef enum
{
    kHeadImage,
    kNickName = 3,
    kAdress = 4,
}selectRow;
@interface XRPersonDataTableView ()<UINavigationControllerDelegate, UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property(nonatomic,weak)UINavigationBar *bar;
@property (strong, nonatomic) IBOutlet UIImageView *iconImageVeiw;
@property (strong, nonatomic) IBOutlet UILabel *IDLabel;
@property (strong, nonatomic) IBOutlet UILabel *accountLabel;
@property (strong, nonatomic) IBOutlet UILabel *nickNameLabel;
@property (strong, nonatomic) NSString * token;
@property (nonatomic, strong) NSURL * imageURL;

@end

@implementation XRPersonDataTableView

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.delegate  = self;
    self.tableView.delegate = self;
    UIImage *selfPhoto = [RootVCHandle getCacheImage];
    self.iconImageVeiw.image = selfPhoto ? : [UIImage imageNamed:@"head_gray"];
    
    self.IDLabel.text = USER_ID;
    self.accountLabel.text = [[NSUserDefaults standardUserDefaults]objectForKey:USER_PHONE];
    self.nickNameLabel.text = USER_NICKNAME;
    self.tableView.contentInset = UIEdgeInsetsMake(-36, 0, 0, 0);
    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setupNai];
    _nickNameLabel.text = USER_NICKNAME;
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
}

-(void)setupNai
{
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithRed:236/255.0 green:236/255.0 blue:236/255.0 alpha:1]] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    [self.navigationController.navigationBar setTintColor:[UIColor blackColor]];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor blackColor]}];
    [self.navigationController preferredStatusBarStyle];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == kNickName) {
        [self.navigationController pushViewController:[[XRUpdataNickNameViewController alloc]init] animated:YES];
    }
    if (indexPath.section == kHeadImage) {
        UIActionSheet* actionSheet = [[UIActionSheet alloc] initWithTitle:@"请选择文件来源" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"照相机",@"本地相簿",nil];
        [actionSheet showInView:self.view];
    }
}
#pragma mark - UIActionSheet Delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0://照相机
        {
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
                UIImagePickerController * imagePickerC = [[UIImagePickerController alloc] init];
                imagePickerC.sourceType = UIImagePickerControllerSourceTypeCamera;
                imagePickerC.delegate = self ;
                imagePickerC.allowsEditing = YES;
                [self presentViewController:imagePickerC animated:YES completion:nil];
            }
        }
            break;
        case 1://本地相簿
        {
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
                UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
                imagePicker.delegate = self;
                imagePicker.allowsEditing = YES;
                imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                [self presentViewController:imagePicker animated:YES completion:nil];
            }
        }
            break;
    }
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    if ([[info objectForKey:UIImagePickerControllerMediaType] isEqualToString:(__bridge NSString *)kUTTypeImage]) {
        UIImage *img = [info objectForKey:UIImagePickerControllerEditedImage];
        [self saveImage:img];
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)saveImage:(UIImage *)image
{
    [self dismissViewControllerAnimated:YES completion:nil];
    [RootVCHandle saveIconImage:image];
    self.iconImageVeiw.image = image;
    [self.network postWithParameter:@{COOKIE: USER_COOKIE, @"Key":[[NSUserDefaults standardUserDefaults] objectForKey:USER_PHONE]} method:getUptoken isHud:NO];
    self.imageURL = [[NSURL alloc] initFileURLWithPath:[RootVCHandle getImageFilePath]];
}



#pragma mark - 网络请求处理
-(void)successfulWithDic:(NSDictionary *)dic method:(NSString *)method
{
    if ([method isEqualToString:getUptoken]) {
        if ([self isPostSuccessedWithDic:dic]) {
            [SVProgressHUD showWithStatus:@"正在上传..."];
            NSString * token = dic[DIC_DATA][@"uptoken"];
            NSString * key = dic[DIC_DATA][@"key"];
            QNUploadManager * manager = [[QNUploadManager alloc] init];
            [manager putData:[NSData dataWithContentsOfURL:self.imageURL] key:key token:token complete:^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
                [self dismissViewControllerAnimated:YES completion:nil];
                NSLog(@"info = %@, key = %@, resp = %@", info, key, resp);
                [SVProgressHUD dismiss];
                if (resp) {
                    [ResponseModel showInfoWithString:@"上传成功!"];
                }
                [SVProgressHUD dismiss];
            } option:nil];
        }
    }
}

- (void)errorWith:(NSError *)error method:(NSString *)method
{

}

@end
