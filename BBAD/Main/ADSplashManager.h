//
//  ADSplashManager.h
//  BBAD
//
//  Created by Dongjw on 17/5/11.
//  Copyright © 2017年 sinyee.babybus. All rights reserved.
//

#import <BBSDK/BBMacros.h>
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "ADDefine.h"
#import "ADSplashConfig.h"
#import "ADSplashDelegate.h"

@protocol ADSplashProtocol <NSObject>

/**
 根据配置分发初始化各平台
 
 @param splashConfig 初始化配置
 @return 继承ADSplashManager的平台管理者
 */
- (instancetype)initWithConfig:(ADSplashConfig *)splashConfig;

/**
 开始请求广告数据
 */
- (void)startRequest;

/**
 停止开屏广告
 */
- (void)stop;

@end


@interface ADSplashManager : NSObject <ADSplashProtocol>
{
    @package
    
    struct {
        /// 开屏广告请求成功，开屏广告即将展示
        unsigned int delegateSplashRequestSuccess			: 1;
        /// 开屏广告展示失败
        unsigned int delegateSplashShowFail                 : 1;
        /// 开屏广告已经展示
        unsigned int delegateSplashDidPresentScreen         : 1;
        /// 开屏广告展示结束
        unsigned int delegateSplashDidDismissScreen         : 1;
        /// 用户点击开屏广告
        unsigned int delegateSplashDidUserClickedAd         : 1;
        
    }_delegateFlags;

    // 当前开屏数据
    ADSplashConfig *_currentSplashConfig;
    
}

/// 设置开屏广告管理代理
@property (nonatomic, weak) id<ADSplashDelegate> delegate;

/// 是否正在显示开屏广告
@property (nonatomic, assign, getter=isSplashing) BOOL splashing;

/// debug模式
@property (nonatomic, assign, getter=isDebugMode) BOOL debugMode;

/// 拉取广告超时时间，默认为3秒
@property (nonatomic, assign) int fetchDelay;

/// 开屏图默认背景-竖屏
@property (nonatomic, strong) UIImage *splashBackgroundImage;

///
@property (nonatomic, strong) NSError *error;

SingletonH

/**
 开启开屏广告
 */
- (void)startSplash;

/**
 强制停止开屏广告,只对自家广告有效
 */
- (void)stopSplash;

@end
