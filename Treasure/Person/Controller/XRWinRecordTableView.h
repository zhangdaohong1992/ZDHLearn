//
//  XRWinRecordTableView.h
//  Treasure
//
//  Created by 荣 on 15/10/30.
//  Copyright © 2015年 YDS. All rights reserved.
//

#import "BaseTableViewController.h"

typedef enum
{
    kAll = -1,
    kIng = 0,
    kdid = 2,
}statue;

@interface XRWinRecordTableView : BaseTableViewController

@property(nonatomic,assign)statue statue;

/** 存放所有的标题按钮 */
@property (nonatomic, strong) NSMutableArray *titleButtons;

@end
