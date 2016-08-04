//
//  PaySucessCell.m
//  Treasure
//
//  Created by 荣 on 15/11/7.
//  Copyright © 2015年 YDS. All rights reserved.
//

#import "PaySucessCell.h"
#import "RewardNumView.h"
@interface PaySucessCell ()
@property (weak, nonatomic) IBOutlet UILabel *titleLael;
@property (weak, nonatomic) IBOutlet UIView *numView;
@property (weak, nonatomic) IBOutlet UILabel *joinLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *numViewH;

@end

@implementation PaySucessCell

- (void)awakeFromNib {
    // Initialization code
    
}
-(void)setModel:(PaySuccessModel *)model{
    _model = model;
    _titleLael.text = [NSString stringWithFormat:@"[%@]%@",model.itemTermId,model.title];
    NSArray *array = [_model.numberRecords componentsSeparatedByString:@","];
    [self sortNumWithArr:array];
    _joinLabel.text = model.joinCount;
}

-(void)sortNumWithArr:(NSArray *)array
{
    //先移除掉复用时存在的label
    for (UILabel *label in self.numView.subviews) {
        [label removeFromSuperview];
    }
    //计算样品的长宽度
    UILabel *testLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 40)];
    testLabel.text = array[0];
    [testLabel sizeToFit];
    CGSize labelSize = testLabel.bounds.size;
    CGFloat labelMargin = (self.numView.width - 3 * labelSize.width) / 4;
    NSLog(@"--------%@", NSStringFromCGRect(self.numView.frame));
    NSInteger count = MIN(array.count, 8);
    for (int i = 0; i<count; i++) {
        CGFloat labelX = labelMargin + i%3*(labelSize.width + labelMargin);
        CGFloat labelY = i/3 *(10 + labelSize.height);
        UILabel *label = [[UILabel alloc]initWithFrame:(CGRect){{labelX,labelY},labelSize}];
        label.textAlignment = NSTextAlignmentCenter;
        [label setFont:[UIFont  systemFontOfSize:13]];
        [label setTextColor:UIColorFromRGB(0x263238)];
        label.text = array[i];
        [self.numView addSubview:label];
        //判断是否为最后一个label从而确定numView的高度
        if (i == count - 1) {
            CGFloat labelMaxY = CGRectGetMaxY(label.frame);
            _numViewH.constant = labelMaxY;
        }
    }
    if (array.count > 8) {
        UILabel *lastLabel = [[UILabel alloc]initWithFrame:CGRectMake(labelMargin + 8%3*(labelSize.width + labelMargin), 8/3 *(10 + labelSize.height), labelSize.width, labelSize.height)];
        lastLabel.text = @"查看更多";
        lastLabel.textAlignment = NSTextAlignmentCenter;
        lastLabel.userInteractionEnabled = YES;
        [lastLabel setFont:[UIFont  systemFontOfSize:13]];
        [lastLabel setTextColor:[UIColor blueColor]];
        [self.numView addSubview:lastLabel];
        [lastLabel addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(watchForMore)]];
        
        CGFloat labelMaxY = CGRectGetMaxY(lastLabel.frame);
        _numViewH.constant = labelMaxY;

    }
}

-(void)watchForMore
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    UIView *hubView = [[UIView alloc]initWithFrame:window.bounds];
    hubView.backgroundColor = [UIColor blackColor];
    hubView.alpha = 0.3;
    
    [window addSubview:hubView];
    
    RewardNumView  *numView = [[RewardNumView alloc]initWithFrame:CGRectMake((VIEW_WIDTH - 270)*0.5, 225, 270, 200)];
    NSArray *scrollArr = [self.model.numberRecords componentsSeparatedByString:@","];
    [numView scrollViewWithNumArray:scrollArr];
    [window addSubview:numView];
    __weak RewardNumView *tempView = numView;
    
    numView.block = ^(){
        [hubView removeFromSuperview];
        [tempView removeFromSuperview];
    };
}
@end
