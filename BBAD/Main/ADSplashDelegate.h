//
//  ADSplashDelegate.h
//  BBAD
//
//  Created by Dongjw on 17/5/11.
//  Copyright © 2017年 sinyee.babybus. All rights reserved.
//

#ifndef ADSplashDelegate_h
#define ADSplashDelegate_h

@class ADSplashContent;
@class ADSplashManager;

/**
 * 开屏广告代理
 */
@protocol ADKSplashAdDelegate <NSObject>

@optional

#pragma mark Ad Request Lifecycle Notifications

/// 开屏广告请求成功，开屏广告即将展示
- (void)splashRequestSuccess:(ADSplashManager *)splashAd;

/// 开屏广告请求失败
- (void)splashRequestFail:(ADSplashManager *)splashAd withError:(NSError *)err;

#pragma mark Display-Time Lifecycle Notifications

/// 开屏广告已经展示
- (void)splashDidPresentScreen:(ADSplashManager *)splashAd;

/// 开屏广告展示结束
- (void)splashDidDismissScreen:(ADSplashManager *)splashAd;

/// 用户点击开屏广告
- (void)splashDidUserClickedAd:(ADSplashManager *)splashAd withContent:(ADSplashContent *)splashContent;

#endif /* ADSplashDelegate_h */

@end
