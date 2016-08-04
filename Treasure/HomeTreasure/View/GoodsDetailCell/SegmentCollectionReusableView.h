//
//  SegmentCollectionReusableView.h
//  Treasure
//
//  Created by 苹果 on 16/4/5.
//  Copyright © 2016年 YDS. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HMSegmentedControl;

@interface SegmentCollectionReusableView : UICollectionReusableView
@property (nonatomic, strong) HMSegmentedControl * segment;

- (void)addSegmentView;

@end
