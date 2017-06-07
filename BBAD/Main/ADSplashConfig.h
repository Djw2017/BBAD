//
//  ADSplashConfig.h
//  BBAD
//
//  Created by Dongjw on 17/6/1.
//  Copyright © 2017年 Babybus. All rights reserved.
//

#import "ADConfig.h"

@interface ADSplashConfig : ADConfig <NSCoding>

/// 缓存的开屏广告错误原因
@property (nonatomic, strong) NSError *error;

#pragma mark 自家广告独有
/// 开屏广告展示时长
@property (nonatomic, assign) int showInterval;

/// iPhone图
@property (nonatomic, copy) NSString *phone_image;

/// iPad图
@property (nonatomic, copy) NSString *ipad_image;

/// type为2使用此参数，打开链接
@property (nonatomic, copy) NSString *url;


- (instancetype)initWithDic:(NSDictionary *)dic;

@end
