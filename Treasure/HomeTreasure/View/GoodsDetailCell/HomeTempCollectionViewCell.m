//
//  HomeTempCollectionViewCell.m
//  Treasure
//
//  Created by 苹果 on 16/4/8.
//  Copyright © 2016年 YDS. All rights reserved.
//

#import "HomeTempCollectionViewCell.h"
#import "NewestPublicView.h"

@implementation HomeTempCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        CGSize size = CGSizeMake((VIEW_WIDTH - 2) / 3., 144);
//        
//        for (int i = 0 ; i < 3; i++) {
//            NewestPublicView * view = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([NewestPublicView class]) owner:self options:nil] firstObject];
//            view.frame = CGRectMake(size.width * i , 0, size.width, size.height);
//            view.tag = 100 + i;
//            view.layer.borderWidth = 0.5;
//            view.layer.borderColor = UIColorFromRGB(0xF1F3F2).CGColor;
//            [view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(TapGestureMethod:)]];
//            [self addSubview:view];
//        }
//    });
}

- (void)addNewestPublicView
{
    CGSize size = CGSizeMake((VIEW_WIDTH - 2) / 3., 144);
    for (int i = 0 ; i < 3; i++) {
        NewestPublicView * view = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([NewestPublicView class]) owner:self options:nil] firstObject];
        view.frame = CGRectMake(size.width * i , 0, size.width, size.height);
        view.tag = 100 + i;
        view.layer.borderWidth = 0.5;
        view.layer.borderColor = UIColorFromRGB(0xF1F3F2).CGColor;
        [view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(TapGestureMethod:)]];
        [self addSubview:view];
    }
}

- (void)removeNewestPublicView
{
    for (UIView * view in self.subviews) {
        if ([view isKindOfClass:[NewestPublicView class]]) {
            [view removeFromSuperview];
        }
    }
}

- (void)TapGestureMethod:(UITapGestureRecognizer *)tap
{
    NewestPublicView * view = (NewestPublicView *)tap.view;
    [self.delegate clickedItemAtIndex:view.tag - 100];
}

- (void)configViewWithModelArray:(NSArray *)array
{
    [self removeNewestPublicView];
    [self addNewestPublicView];
    
    NSMutableArray * views = [NSMutableArray array];
    for (UIView * view in self.subviews) {
        if (view.tag >= 100) {
            [views addObject:view];
        }
    }
    NSArray * arr = [views sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        NewestPublicView * view1 = obj1;
        NewestPublicView * view2 = obj2;
        return view1.tag > view2.tag ? NSOrderedDescending : NSOrderedAscending;
    }];
    
    NSInteger count = MIN(arr.count, array.count);
    for (int i = 0; i < count; i ++) {
        NewestPublicView * view = arr[i];
        view.model = array[i];
    }
}
@end
