//
//  ADKUnionNativeAdDelegate.h
//  adk
//
//  Created by WangMingfu on 16/3/7.
//  Copyright © 2016年 yumo. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ADNativeManager;
@class ADNativeContent;

/**
 * 原生广告加载回调委托
 */
@protocol ADNativeDelegate <NSObject>

@optional

/**
 *  原生广告加载广告数据成功回调，返回为GDTNativeAdData对象的数组
 */
- (void)nativeAdWithManager:(ADNativeManager *)nativeAd didReceiveContent:(NSMutableArray<ADNativeContent *>*)contentAry;

/**
 *  原生广告加载广告数据失败回调
 */
- (void)nativeAdWithManager:(ADNativeManager *)nativeAd didFailToReceiveWithError:(NSError *)error;

/**
 *  原生广告点击之后将要展示内嵌浏览器或应用内AppStore回调
 */
- (void)nativeAdWillPresentScreenWithManager:(ADNativeManager *)nativeAd;

/**
 *  原生广告点击之后应用进入后台时回调
 *  自家广告无此代理
 */
- (void)nativeAdApplicationWillEnterBackgroundWithManager:(ADNativeManager *)nativeAd;

/**
 * 原生广告点击以后，内置AppStore或是内置浏览器被关闭时回调
 * 自家广告无此代理
 */
- (void)nativeAdClosedWithManager:(ADNativeManager *)nativeAd;

@end
