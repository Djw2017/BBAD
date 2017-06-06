//
//  ADConfig.h
//  BBAD
//
//  Created by Dongjw on 17/5/26.
//  Copyright © 2017年 Babybus. All rights reserved.
//

#import "ADDefine.h"

/**
 服务端请求数据模型基类，包含每个界面广告的具体信息
 */
@interface ADConfig : NSObject

/// AppKey
@property (nonatomic, copy) NSString *appkey;

/// 广告位id
@property (nonatomic, copy) NSString *placementId;

/// 广告配置是否生效
@property (nonatomic, assign) BOOL isValid;

///	广告类型
@property (nonatomic, assign) ADType adType;

///	默认广告平台,服务端未请求到广告平台时使用
@property (nonatomic, assign) ADPlatform defaultPlatform;

///	当前广告存在的页面控制器，此值优先于上值，platform
@property (nonatomic, assign) ADPage page;



- (NSString *)key;

- (instancetype)initWithDic:(NSDictionary *)dic;
@end
