//
//  XRProvince.h
//  Treasure
//
//  Created by 荣 on 15/10/28.
//  Copyright © 2015年 YDS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XRProvince : NSObject
/** 省份 */
@property(nonatomic,strong)NSString *state;
/** 城市集合 */
@property(nonatomic,strong)NSArray *cities;
@end
