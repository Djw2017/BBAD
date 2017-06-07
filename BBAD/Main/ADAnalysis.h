//
//  ADAnalysis.h
//  BBAD
//
//  Created by Dongjw on 17/5/26.
//  Copyright © 2017年 Babybus. All rights reserved.
//

#import <BBSDK/MethodMacro.h>
#import <Foundation/Foundation.h>

#import "ADConfig.h"

/**
 广告分析器
 1、请求初始每个页面广告平台数据
 2、下发轮循通知，出现的每个页面进行广告平台替换
 */
@interface ADAnalysis : NSObject

/// 服务端获取的广告数据
@property (nonatomic, readonly) NSArray<ADConfig *> *adConfigs;

/// 是否启用原生
@property (nonatomic, assign) BOOL enableInterstitial;

SingletonH;

- (void)startAnalysis;

+ (ADConfig *)setThridKey:(ADConfig *)config;

@end
