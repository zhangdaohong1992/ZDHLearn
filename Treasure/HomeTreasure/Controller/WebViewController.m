//
//  WebViewController.m
//  Treasure
//
//  Created by 苹果 on 15/10/27.
//  Copyright © 2015年 YDS. All rights reserved.
//

#import "WebViewController.h"
#import "NJKWebViewProgress.h"
#import "NJKWebViewProgressView.h"
#import "UMSocial.h"
#import "UMSocialQQHandler.h"
#import "UMSocialWechatHandler.h"
#import "ShareTableViewController.h"

@interface WebViewController ()<UIWebViewDelegate, NJKWebViewProgressDelegate>

@property (nonatomic, strong) NJKWebViewProgress * progressProxy;
@property (nonatomic, strong) NJKWebViewProgressView * progressView;

@end

@implementation WebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _progressProxy = [[NJKWebViewProgress alloc] init]; // instance variable
    _webView.delegate = _progressProxy;
    _progressProxy.webViewProxyDelegate = self;
    _progressProxy.progressDelegate = self;
    
    CGFloat progressBarHeight = 2.f;
    CGRect navigationBarBounds = self.navigationController.navigationBar.bounds;
    CGRect barFrame = CGRectMake(0, navigationBarBounds.size.height - progressBarHeight, navigationBarBounds.size.width, progressBarHeight);
    _progressView = [[NJKWebViewProgressView alloc] initWithFrame:barFrame];
    _progressView.progressBarView.backgroundColor = UIColorFromRGB(0xFF9500);
    _progressView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    
    if (_bodyString) {
        NSMutableURLRequest * request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", BASE_URL, _url]]];
        [request setHTTPMethod:@"POST"];
        [request setHTTPBody:[_bodyString dataUsingEncoding:NSUTF8StringEncoding]];
        [_webView loadRequest:request];
    }else{
        [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", BASE_URL, self.url]]]];
    }
    
    [self.navigationItem setLeftBarButtonItem:[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back-icon"] style:UIBarButtonItemStylePlain target:self action:@selector(backItemMethod)]];
    self.navigationController.interactivePopGestureRecognizer.delegate = (id<UIGestureRecognizerDelegate>) self;
    // Do any additional setup after loading the view.
}

- (void)backItemMethod
{
    if ([self.webView canGoBack]) {
        [self.webView goBack];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark- viewlife
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar addSubview:_progressView];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [_progressView removeFromSuperview];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    self.vc.isTabBarSelected = NO;
}

#pragma mark - NJKWebViewProgressDelegate
-(void)webViewProgress:(NJKWebViewProgress *)webViewProgress updateProgress:(float)progress
{
    [_progressView setProgress:progress animated:YES];
}

#pragma mark - UIWebViewDelegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSString * str = request.URL.absoluteString;
    NSLog(@"url == %@", str);
    if (navigationType == UIWebViewNavigationTypeOther) {
        if ([str containsString:@"gap://"]) {
                NSMutableDictionary * dic = [NSMutableDictionary dictionary];
                NSLog(@"%@", str);
                NSArray * arr = nil;
                if ([str containsString:@"gap://recommend"]) {
                    arr = [str componentsSeparatedByString:@"gap://recommend?"];
                }
                NSString * param = [arr lastObject];
                NSArray * params = [param componentsSeparatedByString:@"&"];
                for (NSString * string in params) {
                    NSArray * arr = [string componentsSeparatedByString:@"="];
                    NSString * decodeString = [[arr lastObject] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                    [dic setObject:decodeString forKey:[arr firstObject]];
                }
                if ([str containsString:@"gap://recommend"]) {
                    [self shareWithDic:dic];
                }
                NSLog(@"dic = %@", dic);
            }
        }
    return YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    self.title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
}

- (void)shareWithDic:(NSDictionary *)dic
{
    NSString * url = dic[@"activityLink"];
    NSString * title = dic[@"title"];
    [UMSocialData defaultData].extConfig.wechatTimelineData.url = url;
    [UMSocialData defaultData].extConfig.wechatTimelineData.title = title;
    [UMSocialData defaultData].extConfig.wechatSessionData.url = url;
    [UMSocialData defaultData].extConfig.wechatSessionData.title = title;
    [UMSocialData defaultData].extConfig.qqData.title = title;
    [UMSocialData defaultData].extConfig.qqData.url = url;
    
    [[UMSocialData defaultData].urlResource setResourceType:UMSocialUrlResourceTypeImage url:dic[@"imgUrl"]];
    
    [UMSocialSnsService presentSnsIconSheetView:self appKey:UMENG_APPKEY shareText:dic[@"desc"] shareImage:nil shareToSnsNames:@[UMShareToWechatTimeline,UMShareToWechatSession,UMShareToQQ] delegate:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
