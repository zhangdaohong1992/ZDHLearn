//
//  ViewController.m
//  Treasure
//
//  Created by 苹果 on 15/10/19.
//  Copyright (c) 2015年 YDS. All rights reserved.
//

#import "ViewController.h"
#import "BaseNetworkModel.h"


@interface ViewController ()
@property (nonatomic, strong) UIScrollView *pageScroll;//启动图

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.network = [BaseNetworkModel shareBaseNetwork];
    self.network.delegate = self;

    self.noMoreDataLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 20)];
    self.noMoreDataLabel.text = @"现在没有数据哦";
    self.noMoreDataLabel.center = self.view.center;
    self.noMoreDataLabel.hidden = YES;
    self.noMoreDataLabel.textAlignment = NSTextAlignmentCenter;
    self.noMoreDataLabel.textColor = [UIColor grayColor];
    [self.view addSubview:self.noMoreDataLabel];
    
    if ([self isFirstLaunch]) {
        [self firstGoToApp]; //引导页面；
    }
    
    [self.network postWithParameter:@{} method:@"getQdy"];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)login
{
    UINavigationController * nav = [self.storyboard instantiateViewControllerWithIdentifier:@"login"];
    [self presentViewController:nav animated:YES completion:nil];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

#pragma mark - BaseNetworkDelegate
- (void)successfulWithValue:(id)value method:(NSString *)method
{
    if ([value isKindOfClass:[NSDictionary class]]) {
        NSDictionary * dic = [NSDictionary dictionaryWithDictionary:value];
        NSLog(@"dic = %@", dic);
        [self successfulWithDic:dic method:method];
        if (![self isPostSuccessedWithDic:dic]) {
            [ResponseModel showInfoWithString:dic[DIC_INFO]];
        }
        if ([dic[DIC_ERRCODE] integerValue] == 2) {
            [self login];
        }
    }
}

- (void)errorWith:(NSError *)error method:(NSString *)method
{
    
}

- (BOOL)isPostSuccessedWithDic:(NSDictionary *)dic
{
    BOOL isSuccess = NO;
    if ([[dic objectForKey:DIC_ERRCODE] integerValue] == 0) {
        isSuccess = YES;
    }
    return isSuccess;
}

- (void)successfulWithDic:(NSDictionary *)dic method:(NSString *)method
{
    //subclass implementation
}





//引导页本地图片
- (void)firstGoToApp
{
    NSArray *imageNameArray = [NSArray arrayWithObjects:@"launchFirst.jpg", @"launchSecond.jpg", @"launchThird.jpg", nil];
    _pageScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, VIEW_WIDTH, VIEW_HEIGHT)];
    self.pageScroll.showsHorizontalScrollIndicator = NO;
    self.pageScroll.pagingEnabled = YES;
    self.pageScroll.contentSize = CGSizeMake(VIEW_WIDTH * imageNameArray.count, VIEW_HEIGHT);
    //设置弹动风格，默认值为YES
    self.pageScroll.bounces = NO;
    [[self mainWindow] addSubview:self.pageScroll];
    NSString *imgName = nil;
    for (int i = 0; i < imageNameArray.count; i++) {
        
        imgName = [imageNameArray objectAtIndex:i];
        UIImageView *imgV = [[UIImageView alloc] initWithFrame:CGRectMake((VIEW_WIDTH * i), 0.f, VIEW_WIDTH,VIEW_HEIGHT)];
        imgV.contentMode = UIViewContentModeScaleAspectFill;
        imgV.image = [UIImage imageNamed:imgName];
        [self.pageScroll addSubview:imgV];
        if (i == imageNameArray.count - 1) {
            imgV.userInteractionEnabled = YES;
            UIButton *enterButton = [[UIButton alloc] initWithFrame:CGRectMake(0.f, 0.f, VIEW_WIDTH,VIEW_HEIGHT)];
            [enterButton addTarget:self action:@selector(pressEnterButton:) forControlEvents:UIControlEventTouchUpInside];
            [imgV addSubview:enterButton];}}
}
- (void)pressEnterButton:(UIButton *)sender
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.4];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(guideHidden)];
    self.pageScroll.frame = CGRectMake(0, VIEW_HEIGHT, VIEW_WIDTH, VIEW_HEIGHT);
    [UIView commitAnimations];
}
- (void)guideHidden //引导页隐藏处理
{
    [self.pageScroll removeFromSuperview];
    self.pageScroll = nil;
    
}
- (UIWindow *)mainWindow //主屏幕
{
    UIApplication *app = [UIApplication sharedApplication];
    if ([app.delegate respondsToSelector:@selector(window)])
    {return [app.delegate window];
    }else{return [app keyWindow];}
}
- (BOOL)isFirstLaunch       //是否第一次运行；（或升级后第一次运行）
{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSDictionary *dicInfo = [[NSBundle mainBundle] infoDictionary];
    float appVer = [[dicInfo objectForKey:@"CFBundleVersion"] floatValue];//读取版本号
    NSString  *newVer = [NSString stringWithFormat:@"%.2f",appVer];
    if ([userDefault objectForKey:@"firstLaunch"]) {
        NSString *verStr = [userDefault objectForKey:@"firstLaunch"];
        //        NSLog(@"verStr = %@ , newVer = %@",verStr,newVer);
        if (![verStr isEqualToString:newVer]) {
            [userDefault setObject:newVer forKey:@"firstLaunch"];
            [userDefault synchronize];
            return YES;
        }else{return NO;}
    }else{
        [userDefault setObject:newVer forKey:@"firstLaunch"];
        [userDefault synchronize];
        return YES;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
