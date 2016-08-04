//
//  PaySucessCell.h
//  Treasure
//
//  Created by 荣 on 15/11/7.
//  Copyright © 2015年 YDS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PaySuccessModel.h"
@interface PaySucessCell : UITableViewCell

typedef void (^payLookNum)(PaySucessCell *);

@property(nonatomic,strong)PaySuccessModel *model;

@property(nonatomic,strong)payLookNum block;

@end
