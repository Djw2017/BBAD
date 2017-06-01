//
//  ADSplashView.h
//  BBAD
//
//  Created by BabyBus on 15/11/27.
//  Copyright © 2015年 babybus. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ADSplashContent.h"

@class ADSplashView;

/**
 开屏广告视图委托协议
 */
@protocol ADSplashViewDelegate <NSObject>

@required

/**
 开屏广告视图展示成功

 @param splashAdView 当前开屏广告视图
 */
- (void)splashAdViewDidDisplayed:(ADSplashView *)splashAdView;

/**
 用户点击开屏广告视图

 @param splashAdView 当前开屏广告视图
 */
- (void)splashAdViewDidUserClicked:(ADSplashView *)splashAdView;

/**
 开屏广告视图展示结束

 @param splashAdView 当前开屏广告视图
 */
- (void)splashAdViewDidDisplayCompleted:(ADSplashView *)splashAdView;


@end

@interface ADSplashView : UIWindow

/// 设置开屏广告视图代理
@property (nonatomic, weak) id<ADSplashViewDelegate> splashViewDelegate;

/// 设置背景图片，默认启动页
@property (nonatomic, copy) NSString *splashBackgroundImageStr;

/// 开屏视图是否正在显示
@property (nonatomic, readwrite, assign, getter=isExcuting) BOOL excuting;


/**
 开始展现开屏
 此时程序已经启动，获取Default图并延长过渡，开屏广告请求成功并加载图片后，
 调用 -(void)displayWithPortraitImage:landscapeImage: 显示闪屏广告。
 可手动调用 -(void)stop: 方法停止执行开屏广告继续显示。
 */
- (void)showToRoot;

/**
 移除开屏广告视图
 */
- (void)removeForRoot;

/**
 * 切换显示广告视图
 *
 * @param portrait  广告竖屏图
 * @param landscape 广告横屏图
 * @param interval  广告显示时间，ver=5 添加
 */
- (void)displayWithPortraitADImage:(NSString *)portrait landscapeADImage:(NSString *)landscape interval:(NSTimeInterval)interval;

@end
