//
//  RewardNumView.m
//  Treasure
//
//  Created by 荣 on 15/11/3.
//  Copyright © 2015年 YDS. All rights reserved.
//

#import "RewardNumView.h"

@interface RewardNumView ()

@property(nonatomic,weak)UILabel *titileLabel;
@property(nonatomic,weak)UIScrollView *numScroll;
@property(nonatomic,weak)UIButton *closeBtn;
@property(nonatomic,weak)UIView *upLine;
@property(nonatomic,weak)UIView *downLine;


@end

@implementation RewardNumView
static CGFloat contentH;
-(instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        //添加子控件
        UILabel *label = [[UILabel alloc]init];
        UIScrollView *scroll = [[UIScrollView alloc]init];
        UIButton *closeBtn = [[UIButton alloc]init];
        UIView *upLine = [[UIView alloc]init];
        UIView *downLine = [[UIView alloc]init];
        
        _titileLabel = label;
        _numScroll = scroll;
        _closeBtn = closeBtn;
        _upLine = upLine;
        _downLine = downLine;
        
        _titileLabel.textAlignment = NSTextAlignmentCenter;
        [_titileLabel setFont:[UIFont systemFontOfSize:15]];
        [_titileLabel setTextColor:UIColorFromRGB(0x263238)];
        [_titileLabel setText:@"夺宝号码"];
        
         _numScroll.bounces = NO;
        [_closeBtn setTitle:@"关闭" forState:UIControlStateNormal];
        [_closeBtn setTitleColor:UIColorFromRGB(0x1c87ff) forState:UIControlStateNormal];
        [_closeBtn addTarget:self action:@selector(closeClick:) forControlEvents:UIControlEventTouchUpInside];
        [_upLine setBackgroundColor:UIColorFromRGB(0xdbe4e8)];
        [_downLine setBackgroundColor:UIColorFromRGB(0xdbe4e8)];
        
        [self addSubview:_titileLabel];
        [self addSubview:_numScroll];
        [self addSubview:_closeBtn];
        [self addSubview:upLine];
        [self addSubview:downLine];
        
        self.layer.cornerRadius = 5;
        self.backgroundColor = [UIColor whiteColor];
        
    }
    return self;
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    
    _titileLabel.frame = CGRectMake(0, 0, self.width, 35);
  
    _upLine.frame = CGRectMake(0, CGRectGetMaxY(_titileLabel.frame), self.width, 1);

    
    _numScroll.frame = CGRectMake(0, CGRectGetMaxY(_titileLabel.frame), self.width, 130);
   
    _downLine.frame = CGRectMake(0, CGRectGetMaxY(_numScroll.frame), self.width, 1);
    
    _closeBtn.frame = CGRectMake(0, CGRectGetMaxY(_numScroll.frame), self.width, 35);
    
}

-(void)scrollViewWithNumArray:(NSArray *)array
{
    //计算样品的长宽度
    UILabel *testLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 40)];
    testLabel.text = array[0];
    [testLabel sizeToFit];
    CGSize labelSize = testLabel.bounds.size;
    CGFloat margin = 15;
    CGFloat labelMargin = (self.width - 3 * labelSize.width - 2 * 15) * 0.5;
    for (int i = 0; i<array.count; i++) {
        
        CGFloat labelX = margin + i%3*(labelSize.width + labelMargin);
        CGFloat labelY = 10 + i/3 *(10 + labelSize.height);
        
        UILabel *label = [[UILabel alloc]initWithFrame:(CGRect){{labelX,labelY},labelSize}];
        label.textAlignment = NSTextAlignmentCenter;
        [label setFont:[UIFont  systemFontOfSize:13]];
        [label setTextColor:UIColorFromRGB(0x263238)];
        NSLog(@"%@",array[i]);
        label.text = array[i];
        [self.numScroll addSubview:label];
        if (i == array.count - 1) {
             contentH = CGRectGetMaxY(label.frame);
        }
        
    }
        self.numScroll.contentSize = CGSizeMake(self.width, contentH);
        self.numScroll.alwaysBounceVertical = YES;
}

-(void)closeClick:(void(^)())clickBlock
{
    _block();
}
@end
