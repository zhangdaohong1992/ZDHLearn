//
//  ShopingCartTableViewCell.m
//  Treasure
//
//  Created by 苹果 on 15/10/30.
//  Copyright © 2015年 YDS. All rights reserved.
//

#import "ShopingCartTableViewCell.h"
#import "PAStepper.h"
#import "UIImageView+AFNetworking.h"
#import "HomeGoodsModel.h"
#import "HomeGoodsModelHandle.h"
@interface ShopingCartTableViewCell ()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *dic2Left;
@property (nonatomic,assign)int oldCount;
@property (nonatomic,assign)double property;
@end

static int newCount;

@implementation ShopingCartTableViewCell

- (void)awakeFromNib {
    CGFloat rate = VIEW_WIDTH / 375.;
    self.stepViewWidth.constant = 100 * rate;
    self.allInButtonWidth.constant = 55 * rate;
    [self.stepperView addTarget:self action:@selector(stepViewChange:) forControlEvents:UIControlEventValueChanged];
    _model.allBuy = NO;
    _stepperView.stepValue = 1;
}

-(void)stepViewChange:(PAStepper *)stepView
{
    NSLog(@"%f",stepView.value);
    if(stepView.value != _oldCount){
    //自己模型的restCount改变
    _model.joinCount = stepView.value;
    newCount = (int)(_model.joinCount - _oldCount);
    _oldCount = (int)_model.joinCount;
        
    //计算概率
        _property = _model.joinCount / [self.model.allCount doubleValue];
        self.needLabel.text = [NSString stringWithFormat:@"%.2f%%",_property * 100];
    //模型写入数据库
    NSString *updateSql = [NSString stringWithFormat:@"UPDATE %@ SET  join_count = %ld WHERE item_id = %d;", NSStringFromClass([HomeGoodsModelHandle class]), (long)_model.joinCount,_model.itemId];
    [HomeGoodsModelHandle modifyData:updateSql];
        
    //判断是否加到最大值
        if (stepView.value >= stepView.maximumValue) {
            _model.allBuy = YES;
            _allInButton.selected = YES;
        }else{
            _model.allBuy = NO;
            _allInButton.selected = NO;
        }
    _stepChange(newCount);
    }
}

- (void)setModel:(HomeGoodsModel *)model
{
    _model = model;
    [self.iconImageView setImageWithURL:[NSURL URLWithString:model.picture] placeholderImage:[UIImage imageNamed:@"head_gray"]];
    self.titleLabel.text = [NSString stringWithFormat:@"[第%@期] %@", model.term, model.title];
    self.totalCountLabel.text = [NSString stringWithFormat:@"%@", model.restCount];
    self.needLabel.text = [NSString stringWithFormat:@"%.2f%%",  model.joinCount / [model.allCount doubleValue] * 100];
    self.stepperView.value = (double)model.joinCount ;
    
    self.stepperView.maximumValue = [model.restCount floatValue];
    
    if (model.isEditState) {
        _dic2Left.constant = 45;
        _checkBtn.hidden = NO;
        _allInButton.hidden = YES;
    }
    else{
        _dic2Left.constant = 10;
        _checkBtn.hidden = YES;
        _allInButton.hidden = NO;
    }
    _checkBtn.selected = model.isSelected;
    
    _allInButton.selected = (model.restCount.integerValue == model.joinCount);
//    _allInButton.selected = model.isAllBuy;
}

//点击了包尾按钮
- (IBAction)allInbuyClick:(UIButton *)sender {
    _model.allBuy = !_model.isAllBuy;
    sender.selected = _model.isAllBuy;
    if (sender.selected) {
        _model.tempCount = _stepperView.value;
        
        _stepperView.value = [_model.restCount floatValue];
    }
    else {
        _stepperView.value = _model.tempCount;
        
    }
}

- (IBAction)checkBtnClick:(id)sender {
    self.model.selected = !self.model.selected;
    _selectState(self);//在控制器设置已进行tableView的reloadData
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
@end
