//
//  XRPursrHeadView.h
//  Treasure
//
//  Created by 荣 on 15/10/27.
//  Copyright © 2015年 YDS. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XRPursrHeadView;
@protocol XRPurseHeadViewDelegate <NSObject>

@optional

-(void)didClickChargeBtn:(XRPursrHeadView *)headView;

@end

@interface XRPursrHeadView : UIView

-(void)addSubviewWithBalanceCount:(NSString *)count;

@property(nonatomic,weak)id<XRPurseHeadViewDelegate>delegate;

@property(nonatomic,weak)UILabel *balanceLabel;

@end
