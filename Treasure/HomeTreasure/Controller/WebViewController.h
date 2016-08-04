//
//  WebViewController.h
//  Treasure
//
//  Created by 苹果 on 15/10/27.
//  Copyright © 2015年 YDS. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ShareTableViewController;

@interface WebViewController : UIViewController
@property (strong, nonatomic) IBOutlet UIWebView *webView;

@property (weak, nonatomic) ShareTableViewController * vc;
@property (nonatomic, strong) NSString * url;
@property (strong, nonatomic) NSString * bodyString;

@end
