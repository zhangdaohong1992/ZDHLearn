//
//  RewardNumView.h
//  Treasure
//
//  Created by 荣 on 15/11/3.
//  Copyright © 2015年 YDS. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^clickBlock)();

@interface RewardNumView : UIView

-(void)scrollViewWithNumArray:(NSArray *)array;

@property(nonatomic,strong)clickBlock block;

@end
