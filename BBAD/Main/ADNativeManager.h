//
//  ADNativeManager.h
//  BBAD
//
//  Created by Dongjw on 17/5/25.
//  Copyright © 2017年 Babybus. All rights reserved.
//

#import <BBSDK/BBUIUtility.h>

#import "ADNativeConfig.h"
#import "ADNativeContent.h"
#import "ADNativeDelegate.h"

NS_ASSUME_NONNULL_BEGIN

@class ADNativeContent;

@protocol ADNativeProtocol <NSObject>

/**
 根据配置分发初始化各平台
 
 @param nativeConfig 初始化配置
 @return 继承ADNativeManager的平台管理者
 */
- (instancetype)initWithConfig:(ADNativeConfig *)nativeConfig;

/**
 开始请求广告数据
 */
- (void)startRequest;

/**
 停止请求广告数据
 */
- (void)stop;

/**
 *  广告数据渲染完毕即将展示时调用方法
 *  详解：[必选]广告数据渲染完毕，即将展示时需调用本方法。
 *      @param nativeAdData 广告渲染的数据对象
 *      @param view         渲染出的广告结果页面
 */
- (void)attachNativeAd:(nonnull ADNativeContent *)nativeAdData toView:(nonnull UIView *)view;

/**
 *  广告点击调用方法
 *  详解：当用户点击广告时，开发者需调用本方法，系统会弹出内嵌浏览器、或内置AppStore、
 *      或打开系统Safari，来展现广告目标页面
 *      @param nativeAdData 用户点击的广告数据对象
 */
- (void)clickNativeAd:(nonnull ADNativeContent *)nativeAdData;

@end


/**
 原生广告基类
 分配广告平台
 */
@interface ADNativeManager : NSObject <ADNativeProtocol> {
    
    @package
    
    struct {
        unsigned int delegateDidReceiveAdType                           : 1;
        unsigned int delegateDidFailToReceiveWithError                  : 1;
        unsigned int delegateNativeAdWillPresentScreen					: 1;
        unsigned int delegateNativeAdApplicationWillEnterBackground		: 1;
        unsigned int delegateNativeAdClosed								: 1;
        
    }_delegateFlags;
}

/// 请求成功后经处理的广告数据
@property (nullable, nonatomic, strong) NSMutableArray<ADNativeContent *>* contentMAry;

//
@property (nonatomic, weak) id<ADNativeDelegate> delegate;


/**
 创建原生广告，需传入当前界面的广告页 @see ADPage,用以匹配服务端配置广告数据

 @param nativeConfig  原生广告配置
 @return <ADNativeProtocol>单个界面原生广告管理者
 */
+ (nullable id<ADNativeProtocol>)createNativeAdWithConfig:(ADNativeConfig *)nativeConfig;

/**
 平台广告返回数据解析器，用于统一不同平台返回的原生广告数据
 
 @param nativeData 第三方平台广告原始数据
 @param platform 平台
 @return 处理后的数据，GDT为数组类型包含ADNativeContent，其它平台为ADNativeContent类型
 */
- (nullable id)parseAdTypeFrom:(id)nativeData withADPlatform:(ADPlatform)platform;

@end

NS_ASSUME_NONNULL_END
