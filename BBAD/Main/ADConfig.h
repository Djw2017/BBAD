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
@property (nonatomic, copy) NSString *third_appkey;

/// 广告位id
@property (nonatomic, copy) NSString *third_placementId;


@property (nonatomic,copy) NSString *begin_date;

@property (nonatomic,copy) NSString *end_date;

/// 广告配置是否生效
@property (nonatomic, assign) BOOL isValid;

///	广告类型
//@property (nonatomic, assign) ADType adType;


@property (nonatomic, copy) NSString *title;

/// 需要展示的广告平台，服务端没有ad_channel字段，说明为自家广告，此值为0
@property (nonatomic, assign) ADPlatform platform;

///	当前广告存在的页面控制器
@property (nonatomic, assign) ADPage page;

/// 原生广告，开屏广告都有自家广告。点击类型: 1=下载app 2=打开web 3=打开帖子
@property (nonatomic, copy) NSString *type;

- (instancetype)initWithDic:(NSDictionary *)dic;

@end
