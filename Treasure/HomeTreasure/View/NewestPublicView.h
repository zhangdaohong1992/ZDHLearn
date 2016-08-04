//
//  NewestPublicView.h
//  Treasure
//
//  Created by 苹果 on 16/4/8.
//  Copyright © 2016年 YDS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MZTimerLabel.h"
@class XRIssueCellModel;


@interface NewestPublicView : UIView<MZTimerLabelDelegate>
@property (strong, nonatomic) IBOutlet UIImageView *imgView;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet MZTimerLabel *timeLabel;

@property (strong, nonatomic) XRIssueCellModel * model;

@end
