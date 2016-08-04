//
//  NormalCollectionReusableView.h
//  Treasure
//
//  Created by 苹果 on 16/4/5.
//  Copyright © 2016年 YDS. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^ButtonTaped)();

@interface NormalCollectionReusableView : UICollectionReusableView

@property (nonatomic, strong) UILabel * label;
@property (nonatomic, strong) UIButton * button;
@property (nonatomic, copy) ButtonTaped taped;

- (void)handleButtonTaped:(ButtonTaped)tap;

- (void)addNormalTitle;
@end
