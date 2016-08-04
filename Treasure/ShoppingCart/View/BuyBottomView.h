//
//  BuyBottomView.h
//  Treasure
//
//  Created by 苹果 on 15/11/3.
//  Copyright © 2015年 YDS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BuyBottomView : UIView
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UIButton *buyButton;

@property (strong, nonatomic) IBOutlet UIView *deleteBackView;
@property (strong, nonatomic) IBOutlet UIButton *allSelectButton;
@property (strong, nonatomic) IBOutlet UILabel *totalCountLabel;
@property (strong, nonatomic) IBOutlet UIButton *deleteButton;

@property (assign, nonatomic) BOOL isDelete;

+ (id)initViewWithFrame:(CGRect)frame;

@end
