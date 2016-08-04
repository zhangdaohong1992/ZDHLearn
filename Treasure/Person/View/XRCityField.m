//
//  XRCityField.m
//  Treasure
//
//  Created by 荣 on 15/10/28.
//  Copyright © 2015年 YDS. All rights reserved.
//

#import "XRCityField.h"
#import <MJExtension/MJExtension.h>
#import "XRProvince.h"
#import "XRCitys.h"
@interface XRCityField ()<UIPickerViewDataSource,UIPickerViewDelegate,UITextFieldDelegate,UIActionSheetDelegate>

@property (nonatomic, assign) NSInteger selProvinceIndex;

@property (nonatomic, assign) NSInteger selCityIndex;

@property (nonatomic,assign) NSInteger selAreaIndex;

// 保存所有省模型
@property (nonatomic, strong) NSMutableArray *provinces;
@property (nonatomic,strong)NSMutableArray *citys;
@property (nonatomic,strong)NSMutableArray *areas;

@end
@implementation XRCityField
-(void)awakeFromNib
{
    [self setup];
//    [self setupToolBar];
    self.delegate = self;
    
}
#pragma mark - 初始化界面
-(void)setup
{

    //添加一个pickerView
    UIPickerView *pickView = [[UIPickerView alloc]init];
    pickView.dataSource = self;
    pickView.delegate = self;
    pickView.showsSelectionIndicator = YES;
    self.inputView = pickView;
    [self pickerView:pickView didSelectRow:0 inComponent:0];
}
#pragma mark - dataSource
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 3;
}
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (component == 0) {
        return self.provinces.count;
    }
    if (component == 1) {
        XRProvince *province = self.provinces[_selProvinceIndex];
        return province.cities.count;
    }
    else  {
        XRCitys *city = self.citys[_selCityIndex];
        return city.areas.count;
    }
}
// 返回每一行的标题
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (component == 0) { // row:省
        XRProvince *province = self.provinces[row];
        return province.state;
    }
    if (component == 1) {
        XRCitys *city = self.citys[row];
        return city.city;
    }
    else
    {
        XRCitys *city = self.citys[_selCityIndex];
        return city.areas[row];
    }
}

// 用户选中某一行的时候调用
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (component == 0) { // 滚动省
        _selProvinceIndex = row;
        [pickerView reloadComponent:1];
        [pickerView reloadComponent:2];
    }
    if (component == 1) {
        _selCityIndex = row;
        [pickerView reloadComponent:2];
    }
    if (component == 2) {
        _selAreaIndex = row;
    }
    
    // 给文本框赋值
    // 获取当前第0列选中的省
    XRProvince *p = self.provinces[_selProvinceIndex];
    
    // 省会名称
    NSString *pName = p.state;
    
    // 获取第1列选中的城市
    NSInteger cityIndex = [pickerView selectedRowInComponent:1];
    // 获取城市名称
    XRCitys *city = p.cities[cityIndex];
    NSString *cityName = city.city;
    
    //获取第2列选中的区域
    NSInteger areaIndex = [pickerView selectedRowInComponent:2];
    // 获取城市名称
    NSString *areaName;
    if (city.areas.count !=0) {
       areaName = city.areas[areaIndex];
    }
    else{
        areaName = @"";
    }

    self.text = [NSString stringWithFormat:@"%@ %@ %@",pName,cityName,areaName];
    
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    
}
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    
}
#pragma mark - 点击完成与取消后
-(void)clickCancel
{
   
}

#pragma mark - lazy
-(NSMutableArray *)provinces
{
    if (!_provinces) {
        NSArray *dic = [[NSArray alloc]initWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"area.plist" ofType:nil]];
        _provinces = [XRProvince objectArrayWithKeyValuesArray:dic];
    }
    return _provinces;
}

-(NSMutableArray *)citys
{
    if (!_citys) {
        _citys = [NSMutableArray array];
    }
    XRProvince *province = _provinces[_selProvinceIndex];
    [_citys removeAllObjects];
    [_citys addObjectsFromArray:province.cities];
    return _citys;
}
    
@end
