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

/// 宝宝巴士原生广告信息
@property (nonatomic, strong) NSArray *bbadInfoAry;

///	当前广告存在的页面控制器，此值优先于上值，platform
//@property (nonatomic, assign) ADPage page;

/// 需要展示的广告平台
@property (nonatomic, strong) NSArray *adPlatformAry;

- (instancetype)initWithDic:(NSDictionary *)dic;

@end
