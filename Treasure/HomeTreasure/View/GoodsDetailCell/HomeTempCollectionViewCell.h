//
//  HomeTempCollectionViewCell.h
//  Treasure
//
//  Created by 苹果 on 16/4/8.
//  Copyright © 2016年 YDS. All rights reserved.
//

#import <UIKit/UIKit.h>
@class NewestPublicView;

@protocol HomeTempCollectionViewCellDelegate <NSObject>

- (void)clickedItemAtIndex:(NSInteger)index;

@end

@interface HomeTempCollectionViewCell : UICollectionViewCell//显示最新揭晓cell

@property (weak, nonatomic) id <HomeTempCollectionViewCellDelegate> delegate;

- (void)configViewWithModelArray:(NSArray *)array;

@end
