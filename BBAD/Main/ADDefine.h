//
//  ADDefine.h
//  BBAD
//
//  Created by Dongjw on 17/5/11.
//  Copyright © 2017年 sinyee.babybus. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "BBADMacro.h"

/**
 广告平台
 */
typedef NS_ENUM(int, ADPlatform) {

    /// 自家广告
    ADPlatformBabybus		= 0,
    /// 广点通广告
    ADPlatformGDT           = 1,
    /// 讯飞广告
    ADPlatformIFLY          = 2,
    /// 今日头条广告
    ADPlatformBaidu         = 3,
    /// 谷歌广告
    ADPlatformAdmob         = 4,
};

/**
 广告样式
 */
typedef NS_ENUM(NSInteger, ADType) {
    
    // 开屏广告
    ADTypeSplash    = 1,
    // banner广告
    ADTypeBanner    = 2,
    // 原生广告
    ADTypeNative    = 3,

};


/**
 广告页面，用以区分数据，不同广告页面匹配响应中不同数据
 所有广告页面都需使用该枚举。
 如有需要补充的请通知。
 */
typedef NS_ENUM(int, ADPage) {
    
    /// 首页排行榜
    ADPageRecommendVC				= 1,
    /// 专题列表
    ADPageTopicDetailVC				= 2,
    /// 0-2岁
    ADPageAppAgeZeroVC				= 3,
    /// 2-3岁
    ADPageAppAgeTwoVC				= 4,
    /// 3-4岁
    ADPageAppAgeThreeVC             = 5,
    /// 4-5岁
    ADPageAppAgeFourVC              = 6,
    /// 5+岁
    ADPageAppAgeFiveVC              = 7,
    /// 应用详情
    ADPageAppDetailDesVC            = 8,
    /// 开屏
    ADPageAppDelegate               = 10,
    /// 帖子详情
    ADPagePostDetailVC              = 12,
};

/**
 * ADAction
 *
 * 自家广告行为类型
 *
 * 注：所有的自家广告行为类型都需参照该枚举。
 *	  目前的使用到的所有行为类型都已经在此定义。
 */
typedef NS_ENUM(NSInteger, ADAction) {
    
    /// 没有任何操作.
    KADActionNone                       = 0,
    
    ///使用StoreKit打开App下载页面，点击代理前已实现
    KADActionOpensInStoreKit			= 1,

    ///使用自定义的web视图打开链接地址，需要自行实现
    kADKAdActionOpensInCustomWebPage	= 2,

    /// 打开帖子详细页，需要自行实现
    KADActionOpensInNote				= 3,
};


/**
 上一次请求的开屏错误原因
 */
typedef NS_ENUM(NSInteger, ADSplashError) {
    
    /// 响应数据显示开屏条件不符合
    KADSplashErrorConditionNotMeet                  = -1,
    
    /// 响应数据显示平台本地不支持
    KADSplashErrorPlatformNotSupported              = -2,
    
    /// 响应数据格式不正确
    KADSplashErrorDataFormatError                   = -3,
    
    /// BBNetwork内部报错
    KADSplashErrorBBNetworkError                    = -4,
    
    /// 未缓存开屏数据
    KADSplashErrorNotCache                          = -5,
};

@interface ADDefine : NSObject

@end
