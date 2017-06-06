//
//  ADSplashConfig.h
//  BBAD
//
//  Created by Dongjw on 17/6/1.
//  Copyright © 2017年 Babybus. All rights reserved.
//

#import "ADConfig.h"

@interface ADSplashConfig : ADConfig

//
///// 是否展示广告字样
//@property (nonatomic, assign) BOOL isShowADStr;

@property (nonatomic,copy) NSString *begin_date;

@property (nonatomic,copy) NSString *end_date;

/// 需要展示的平台
@property (nonatomic,assign) ADPlatform platform;

#pragma mark 自家广告独有
/// 开屏广告展示时长
@property (nonatomic,assign) int showInterval;

/// iPhone图
@property (nonatomic,copy) NSString *phone_image;

/// iPad图
@property (nonatomic,copy) NSString *ipad_image;

/// 点击类型: 1=下载app 2=打开web 3=打开帖子
@property (nonatomic,copy) NSString *type;

/// type为2使用此参数，打开链接
@property (nonatomic,copy) NSString *url;

@property (nonatomic,copy) NSString *title;

/// 需要下载的app
@property (nonatomic,copy) NSString *app_download;


- (instancetype)initWithDic:(NSDictionary *)dic;

@end
