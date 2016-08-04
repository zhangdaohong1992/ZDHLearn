//
//  XRNewCell.h
//  Treasure
//
//  Created by 荣 on 15/10/27.
//  Copyright © 2015年 YDS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MZTimerLabel.h"
@class XRIssueCellModel;
@class XRNewCell;
@protocol newCellDelegate <NSObject>
@optional

-(void)finshedCountDownTimer:(XRNewCell *)cell;

@end

@interface XRNewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet MZTimerLabel *openTimeLabel;

@property(nonatomic,strong)XRIssueCellModel *model;

@property(nonatomic,weak)id<newCellDelegate>delegate;

-(void)tableView:(UITableView *)tableView refrshModel:(XRIssueCellModel *)model;

@end
