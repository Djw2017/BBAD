//
//  ADConfig.h
//  BBAD
//
//  Created by Dongjw on 17/5/26.
//  Copyright © 2017年 Babybus. All rights reserved.
//

#import "ADDefine.h"

/**
 服务端请求数据模型，包含每个界面广告的具体信息
 */
@interface ADConfig : NSObject

/// 广告页面标识
@property (nonatomic, assign) ADPage page;

/// 广告显示时间间隔
@property (nonatomic, assign) NSInteger displayInterval;

/// 广告配置是否生效
@property (nonatomic, assign) BOOL isValid;

///	广告类型
@property (nonatomic, assign) ADType adType;

/// 需要展示的广告平台
@property (nonatomic, strong) NSArray *adPlatformAry;

/// 广告所在列表位置
@property (nonatomic, strong) NSArray *adPosition;

/// 宝宝巴士原生广告信息
@property (nonatomic, strong) NSArray *bbadInfoAry;

/// 广告唯一标识
@property (nonatomic, assign) NSInteger adId;

/// 应用首次启动后，广告延迟显示时间。开屏广告忽略该参数
@property (nonatomic, assign) NSInteger launchInterval;


- (NSString *)key;

- (instancetype)initWithDic:(NSDictionary *)dic;
@end
