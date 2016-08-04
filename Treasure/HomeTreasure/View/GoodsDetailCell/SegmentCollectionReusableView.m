//
//  SegmentCollectionReusableView.m
//  Treasure
//
//  Created by 苹果 on 16/4/5.
//  Copyright © 2016年 YDS. All rights reserved.
//

#import "SegmentCollectionReusableView.h"
#import "HMSegmentedControl.h"

@implementation SegmentCollectionReusableView

- (void)addSegmentView
{
    [self addSubview:self.segment];
}

- (HMSegmentedControl *)segment
{
    if (!_segment) {
        _segment = [[HMSegmentedControl alloc] initWithSectionTitles:@[@"最热", @"最快", @"最新", @"高价", @"低价"]];
        _segment.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
        _segment.selectionStyle = HMSegmentedControlSelectionStyleFullWidthStripe;
        _segment.selectionIndicatorColor = UIColorFromRGB(0xFF4640);
        _segment.titleTextAttributes = @{NSFontAttributeName : [UIFont systemFontOfSize:13], NSForegroundColorAttributeName : UIColorFromRGB(0x263238)};
        _segment.selectedTitleTextAttributes = @{NSForegroundColorAttributeName : UIColorFromRGB(0xFF4640), NSFontAttributeName : [UIFont systemFontOfSize:13]};
        _segment.frame = CGRectMake(0, 0, self.width, self.height - .5);

    }
    return _segment;
}
@end
