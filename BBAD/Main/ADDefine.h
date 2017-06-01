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
typedef NS_ENUM(NSInteger, ADPlatform) {

    /// 自家广告
    ADPlatformBabybus		= 1,
    /// 百度广告
    ADPlatformBaidu         = 2,
    /// 谷歌广告
    ADPlatformAdmob         = 3,
    /// 广点通广告
    ADPlatformGDT           = 4,
    /// 讯飞广告
    ADPlatformIFLY          = 5,
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
 所有有原生广告页面都需使用该枚举。
 如有需要补充的请通知。
 */
typedef NS_ENUM(NSInteger, ADPage) {
    
    /// 首页排行榜
    ADPageRecommendVC				= 1,
    /// 专题列表
    ADPageTopicDetailVC				= 2,

};

/**
 * ADAction
 *
 * 广告行为类型
 *
 * 注：所有的广告行为类型都需参照该枚举。
 *	  目前的使用到的所有行为类型都已经在此定义。
 */
typedef NS_ENUM(NSInteger, ADAction) {
    kADActionNone					= 0,			///< 没有任何操作.
    kADActionOpensInStoreKit			= 1,			///< 使用StoreKit打开App下载页面，已实现
    kADActionOpensInWebKit			= 2,			///< 使用公共的web视图打开链接地址，已实现
    kADActionOpensOutApp				= 3,			///< 使用 UIApplication 打开链接，已实现
    kADActionOpensInCustomWebPage	= 4,			///< 使用自定义的web视图打开链接地址，需要自行实现
    kADActionOpensInAppDetail		= 5,			///< 打开应用详细页面，需要自行实现
    kADActionOpensInAblum			= 6,			///< 打开软件专辑页面，需要自行实现
    kADActionOpensInNote				= 7,			///< 打开帖子详细页，需要自行实现
    kADActionOpensInActivity			= 8,			///< 打开活动页面，需要自行实现
    kADActionOpensInWPAblum			= 9,			///< 打开壁纸专辑页面，需要自行实现
    kADActionOpensInGift				= 10,			///< 打开礼包详细页面，需要自行实现
    kADActionOpensInSTArticle		= 11			///< 打开攻略文章详细页，需要自行实现
};

@interface ADDefine : NSObject

@end
