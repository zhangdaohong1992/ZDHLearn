//
//  XRSharePostViewController.m
//  Treasure
//
//  Created by 荣 on 15/11/5.
//  Copyright © 2015年 YDS. All rights reserved.
//

#import "XRSharePostViewController.h"
#import "RootVCHandle.h"
#import <QiniuSDK.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "QBImagePickerController.h"

@interface XRSharePostViewController ()<UITextViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,QBImagePickerControllerDelegate>

@property (weak, nonatomic) IBOutlet UILabel *winerLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *photo2Content;

@property (weak, nonatomic) IBOutlet UITextView *contentText;
@property (weak, nonatomic) IBOutlet UIView *contentView;

@property (weak,nonatomic)UIView *viewForImage;

@property (strong, nonatomic) NSString * token;

@property (nonatomic, strong) NSMutableArray * imageDataArr;

@property (weak, nonatomic) IBOutlet UIButton *phontImageV;

@end

@implementation XRSharePostViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:@"晒单"];
    [self setupImageV];
    _contentText.delegate = self;
}
#pragma mark - 初始化设置
//创建图片墙View
-(void)setupImageV
{
    CGFloat margin = 20;
    
    UIView *viewForImg = [[UIView alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(_contentView.frame) + 10, _contentView.width, _contentView.width/(2 * margin) * 2 + margin)];
    
    _viewForImage = viewForImg;
    
    [self.view insertSubview:_viewForImage belowSubview:_phontImageV];
}

-(void)sortImageViewWithArr:(NSArray *)arr
{
    for (UIView *imageV in _viewForImage.subviews) {
        [imageV removeFromSuperview];
    }
    CGFloat imageW = (_contentText.width - 2 * 15) / 3;
    for (int i = 0; i<arr.count; i++) {
        CGFloat imageY = (7.5 + imageW) * (i / 3);
        CGFloat imageX = (15 + imageW)*(i%3);
        UIImageView *imageV = [[UIImageView alloc]initWithFrame:CGRectMake(imageX, imageY, imageW, imageW)];
        imageV.image = [UIImage imageWithData:arr[i]];
        [self.viewForImage addSubview:imageV];
        _photo2Content.constant = imageW + 25;
    }
    if (arr.count > 3) {
        _photo2Content.constant = 2 * imageW + 25;
    }
}

#pragma mark - 按钮点击
- (IBAction)postShareClick:(id)sender {
    if (_contentText.text.length < 3) {
        [ResponseModel showInfoWithString:@"字数太少啦"];
        return;
    }
    if (_contentText.text.length > 256) {
        [ResponseModel showInfoWithString:@"字数太多啦"];
        return;
    }
    if (self.imageDataArr.count < 1) {
        [ResponseModel showInfoWithString:@"还没选择照片"];
        return;
    }
    if (_contentText.text.length > 0) {
        [self.network postWithParameter:@{COOKIE:USER_COOKIE,@"content":_contentText.text,@"picNum":@(self.imageDataArr.count),@"orderId":self.orderId } method:showOrder];
    }
}

- (IBAction)updataImage:(id)sender {
    
    QBImagePickerController *imagePickerController = [[QBImagePickerController alloc]init];
    imagePickerController.delegate = self;
    imagePickerController.allowsMultipleSelection = YES;
    imagePickerController.minimumNumberOfSelection = 1;
    imagePickerController.maximumNumberOfSelection = 6;
    imagePickerController.showsNumberOfSelectedAssets = YES;
    [self.navigationController presentViewController:imagePickerController animated:YES completion:NULL];
}

- (void)textViewDidChange:(UITextView *)textView;
{
    if (textView.text.length > 0) {
        _winerLabel.hidden = YES;
    }
    else {
        _winerLabel.hidden = NO;
    }
    
}

#pragma mark - QBImagePickerDelegate

//取消时
- (void)qb_imagePickerControllerDidCancel:(QBImagePickerController *)imagePickerController
{
    [self dismissViewControllerAnimated:YES completion:NULL];
}

//结束时
- (void)qb_imagePickerController:(QBImagePickerController *)imagePickerController didFinishPickingAssets:(NSArray *)assets {
    [self.imageDataArr removeAllObjects];
    for (PHAsset *asset in assets) {
        
        PHImageRequestOptions * imageRequestOptions = [[PHImageRequestOptions alloc] init];
        imageRequestOptions.synchronous = YES;
        [[PHImageManager defaultManager] requestImageDataForAsset:asset options:imageRequestOptions resultHandler:^(NSData *imageData, NSString *dataUTI,
                         UIImageOrientation orientation,
                         NSDictionary *info)
         {
             UIImage * img = [UIImage imageWithData:imageData];
             NSData * data = UIImageJPEGRepresentation(img, 0.5);
             [self.imageDataArr addObject:data];
             
             if (self.imageDataArr.count > 6) {
                 [SVProgressHUD showErrorWithStatus:@"最多添加6张图片"];
             }
         }];
    }
    [self sortImageViewWithArr:self.imageDataArr];
    [self dismissViewControllerAnimated:YES completion:NULL];
}

-(void)successfulWithDic:(NSDictionary *)dic method:(NSString *)method
{
    if ([method isEqualToString:showOrder]) {
        if ([self isPostSuccessedWithDic:dic]) {
            [SVProgressHUD show];
            NSDictionary * tokenDic = dic[DIC_DATA];
            NSArray *arr = [tokenDic allKeys];
            for (int i = 0; i<arr.count; i++) {
                
                NSString *postKey = arr[i];
                NSString *token = tokenDic[postKey];
                NSData *imageData = self.imageDataArr[i];
                
                QNUploadManager * manager = [[QNUploadManager alloc] init];
                [manager putData:imageData key: postKey token:token complete:^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
                    [self dismissViewControllerAnimated:YES completion:nil];
                    NSLog(@"info = %@, key = %@, resp = %@", info, key, resp);
                    if (i == arr.count - 1) {
                        if (resp) {
                            [SVProgressHUD showSuccessWithStatus:@"上传图片成功"];
                            [self.navigationController popViewControllerAnimated:YES];
                        }else{
                            [SVProgressHUD showSuccessWithStatus:@"上传图片失败"];
                        }
                    }
                } option:nil];
            }
        }
    }
}

-(NSMutableArray *)imageDataArr
{
    if (!_imageDataArr) {
        _imageDataArr = [NSMutableArray array];
    }
    return _imageDataArr;
}
@end
