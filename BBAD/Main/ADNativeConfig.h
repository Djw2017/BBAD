//
//  ADNativeConfig.h
//  BBAD
//
//  Created by Dongjw on 17/5/25.
//  Copyright © 2017年 Babybus. All rights reserved.
//

#import "ADConfig.h"
#import "ADDefine.h"

/**
 原生广告配置
 */
@interface ADNativeConfig : ADConfig

///	广告拉取数量
@property (nonatomic, assign) int count;

/// 广告所在列表位置
@property (nonatomic, strong) NSArray *adPosition;

/// 广告所在页面控制器子分类：年龄段的第几个分类 或【0，1，2】代表对应位置榜单
@property (nonatomic, copy) NSString *child_page;

/// 宝宝巴士原生广告信息
@property (nonatomic, strong) NSArray *bbadInfoAry;


- (instancetype)initWithDic:(NSDictionary *)dic;

@end
