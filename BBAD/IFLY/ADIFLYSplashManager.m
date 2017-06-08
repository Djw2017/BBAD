//
//  ADIFLYSplashManager.m
//  BBAD
//
//  Created by Dongjw on 17/6/2.
//  Copyright © 2017年 Babybus. All rights reserved.
//

#import "IFLYNativeAd.h"

#import "ADSplashView.h"
#import "ADIFLYSplashManager.h"

@interface ADIFLYSplashManager ()<IFLYNativeAdDelegate,ADSplashViewDelegate>
{
    IFLYNativeAd *_native;
    IFLYNativeAdData *_currentAd;
 
    // 业务相关
    BOOL _attached;
    
    // 讯飞开屏广告使用请求原生广告自定义界面展示
    ADSplashView *_splashView;
    
    ADSplashConfig *_currentSplashConfig;
}

@end

@implementation ADIFLYSplashManager

- (instancetype)initWithConfig:(ADSplashConfig *)splashConfig {
    self = [super initWithConfig:splashConfig];
    if (self) {
        _currentSplashConfig = splashConfig;
    }
    return self;
}

- (void)startRequest {
    _native = [[IFLYNativeAd alloc]initWithAppId:_currentSplashConfig.third_appkey adunitId:_currentSplashConfig.third_placementId];
    _native.delegate = self;
    _native.currentViewController = [BBUIUtility getCurrentVC];
    [_native loadAd:1];
    
    if (!_splashView) {
        _splashView = [[ADSplashView alloc] init];
        _splashView.splashVdelegate = self;
    }
    [_splashView showToRoot];
}




#pragma mark IFLYNativeAdDelegate
-(void)nativeAdReceived:(NSArray *)nativeAdDataArray{
    
    
    _currentAd = [nativeAdDataArray objectAtIndex:0];
    
    /*广告详情图*/
    
    [_splashView displayWithPortraitADImage:[_currentAd.properties objectForKey:IFLYNativeAdDataKeyImg]
                           landscapeADImage:nil
                                   interval:_currentSplashConfig.showInterval];
    
    [_native attachAd:_currentAd toView:_splashView];
    
}

-(void)nativeAdFailToLoad:(AdError *)error{

}




#pragma mark ADSplashViewDelegate
/**
 开屏广告视图展示成功
 
 @param splashAdView 当前开屏广告视图
 */
- (void)splashAdViewDidDisplayed:(ADSplashView *)splashAdView {
    if (_delegateFlags.delegateSplashDidPresentScreen) {
        [self.delegate splashDidPresentScreen:self];
    }
}

/**
 用户点击开屏广告视图
 
 @param splashAdView 当前开屏广告视图
 */
- (void)splashAdViewDidUserClicked:(ADSplashView *)splashAdView {
    /*点击发生，调用点击接口*/
    [_native clickAd:_currentAd];
    if (_delegateFlags.delegateSplashDidUserClickedAd) {
        [self.delegate splashDidUserClickedAd:self withContent:_currentSplashConfig];
    }
}

/**
 开屏广告视图展示结束
 
 @param splashAdView 当前开屏广告视图
 */
- (void)splashAdViewDidDisplayCompleted:(ADSplashView *)splashAdView {
    self.splashing = NO;
    if (_delegateFlags.delegateSplashDidDismissScreen) {
        [self.delegate splashDidDismissScreen:self];
    }
}

@end
