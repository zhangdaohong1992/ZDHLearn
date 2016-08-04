//
//  XRWinRecordCell.h
//  Treasure
//
//  Created by 荣 on 15/10/28.
//  Copyright © 2015年 YDS. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XRWinRecordCell;

@protocol winRecordDelegate <NSObject>
@optional
-(void)lookMynumInCell:(XRWinRecordCell *)cell;

-(void)finshedCountDownTimer:(XRWinRecordCell *)cell;

@end

@protocol newCellDelegate <NSObject>
@optional



@end

@class XRWinRecordModel;

@interface XRWinRecordCell : UITableViewCell

@property(nonatomic,strong)XRWinRecordModel *model;

@property(nonatomic,weak)id<winRecordDelegate>delegate;

-(void)tableView:(UITableView *)tableView refrshModel:(XRWinRecordModel *)model;

@end
