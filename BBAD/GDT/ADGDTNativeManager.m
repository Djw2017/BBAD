//
//  ADGDTNativeManager.m
//  BBAD
//
//  Created by Dongjw on 17/5/25.
//  Copyright © 2017年 Babybus. All rights reserved.
//

#import <BBSDK/BBUIUtility.h>

#import "ADNativeConfig.h"
#import "ADGDTNativeManager.h"
#import "GDTNativeAd.h"

@interface ADGDTNativeManager () <GDTNativeAdDelegate>
{
    GDTNativeAd *_nativeAd;
}
@property (nonatomic, strong) ADNativeConfig *nativeConfig;

@property (nonatomic, readwrite, assign) BOOL attached;

@end

@implementation ADGDTNativeManager

- (void)dealloc {
    [self stop];
}

- (instancetype)initWithConfig:(ADNativeConfig *)nativeConfig {
    self = [super initWithConfig:nativeConfig];
    if (self) {
        self.nativeConfig = nativeConfig;
    }
    return self;
}

#pragma mark - native ad request lifecycle
- (void)startRequest {
    [super startRequest];
    
    [self stop];

    /*
     * 拉取广告,传入参数为拉取个数。
     * 发起拉取广告请求,在获得广告数据后回调delegate
     */
    
    _nativeAd = [[GDTNativeAd alloc] initWithAppkey:self.nativeConfig.appkey placementId:self.nativeConfig.placementId];
    _nativeAd.controller = [BBUIUtility getCurrentVC];
    _nativeAd.delegate = self;
    
    [_nativeAd loadAd:self.nativeConfig.count];
}

- (void)stop {
    [super stop];
    
    if (_nativeAd) {
        _nativeAd.delegate = nil;
        _nativeAd.controller = nil;
        _nativeAd = nil;
    }
    _attached = NO;
}

- (void)attachNativeAd:(ADNativeContent *)nativeAdData toView:(UIView *)view {
    [super attachNativeAd:nativeAdData toView:view];
    
    if (nativeAdData && !_attached) {
        
        [_nativeAd attachAd:nativeAdData.nativeOriginalData toView:view];
        _attached = YES;
    }
}

- (void)clickNativeAd:(ADNativeContent *)nativeAdData {
    [super clickNativeAd:nativeAdData];
    
    if (nativeAdData) {
        [_nativeAd clickAd:nativeAdData.nativeOriginalData];
    }
}

#pragma mark - GDTNativeAdDelegate

/**
 *  原生广告加载广告数据成功回调，返回为GDTNativeAdData对象的数组
 */
- (void)nativeAdSuccessToLoad:(NSArray *)nativeAdDataArray {
    
    NSMutableArray<ADNativeContent *>* contentAry = [self parseAdTypeFrom:nativeAdDataArray withADPlatform:ADPlatformGDT];
    
    if (contentAry) {
        if (_delegateFlags.delegateDidReceiveAdType) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.delegate nativeAdWithManager:self didReceiveContent:contentAry];
            });
        }
    }else {
        if (_delegateFlags.delegateDidFailToReceiveWithError) {
            NSError *error = [[NSError alloc] initWithDomain:@"广点通原生广告解析数据出错" code:-1 userInfo:nil];
            [self.delegate nativeAdWithManager:self didFailToReceiveWithError:error];
        }
    }
}

/**
 *  原生广告加载广告数据失败回调
 */
- (void)nativeAdFailToLoad:(NSError *)error {
    
    if (_delegateFlags.delegateDidFailToReceiveWithError) {
        [self.delegate nativeAdWithManager:self didFailToReceiveWithError:error];
    }
}

/**
 *  原生广告点击之后将要展示内嵌浏览器或应用内AppStore回调
 */
- (void)nativeAdWillPresentScreen {
    
    if (_delegateFlags.delegateNativeAdWillPresentScreen) {
        [self.delegate nativeAdWillPresentScreenWithManager:self];
    }
}

/**
 *  原生广告点击之后应用进入后台时回调
 */
- (void)nativeAdApplicationWillEnterBackground {
    
    if (_delegateFlags.delegateNativeAdApplicationWillEnterBackground) {
        [self.delegate nativeAdApplicationWillEnterBackgroundWithManager:self];
    }
}

/**
 * 原生广告点击以后，内置AppStore或是内置浏览器被关闭时回调
 */
- (void)nativeAdClosed {
    
    if (_delegateFlags.delegateNativeAdClosed) {
        [self.delegate nativeAdClosedWithManager:self];
    }
}

@end
