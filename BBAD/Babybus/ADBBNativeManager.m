//
//  ADBBNativeManager.m
//  BBAD
//
//  Created by Dongjw on 17/5/27.
//  Copyright © 2017年 Babybus. All rights reserved.
//

#import "ADAnalysis.h"
#import "ADBBNativeManager.h"

@interface ADBBNativeManager ()

@property (nonatomic, strong) ADNativeConfig *nativeConfig;

@property (nonatomic, readwrite, assign) BOOL attached;

@end

@implementation ADBBNativeManager

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
    
    NSError *error;
    if (![ADAnalysis sharedInstance].adConfigs) {
        error = [[NSError alloc] initWithDomain:@"服务端获取的所有广告数据为空，不可使用自家广告" code:-1 userInfo:nil];
        [self nativeAdFailToLoad:error];
    }else {
        for (ADNativeConfig *config in [ADAnalysis sharedInstance].adConfigs) {
            // 匹配服务端响应页面与当前页面
            if (self.nativeConfig.page == config.page) {
                if (!config.bbadInfoAry) {
                    error = [[NSError alloc] initWithDomain:@"服务端获取的自家广告数据为空"   code:-2 userInfo:nil];
                    [self nativeAdFailToLoad:error];
                }else {
                    [self nativeAdSuccessToLoad:config.bbadInfoAry];
                }
            }
        }
    }
}

- (void)stop {
    [super stop];
}

- (void)attachNativeAd:(ADNativeContent *)nativeAdData toView:(UIView *)view {
    [super attachNativeAd:nativeAdData toView:view];
    
    if (nativeAdData && !_attached) {
        
        _attached = YES;
    }
}

- (void)clickNativeAd:(ADNativeContent *)nativeAdData {
    [super clickNativeAd:nativeAdData];
    
    if (nativeAdData) {
        [self nativeAdWillPresentScreen];
    }
}

/**
 *  自家原生广告加载广告数据成功回调，返回为GDTNativeAdData对象的数组
 */
- (void)nativeAdSuccessToLoad:(NSArray *)nativeAdDataArray {
    
    NSMutableArray<ADNativeContent *>* contentAry = [self parseAdTypeFrom:nativeAdDataArray withADPlatform:ADPlatformBabybus];
    
    if (contentAry) {
        if (_delegateFlags.delegateDidReceiveAdType) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.delegate nativeAdWithManager:self didReceiveContent:contentAry];
            });
        }
    }else {
        if (_delegateFlags.delegateDidFailToReceiveWithError) {
            NSError *error = [[NSError alloc] initWithDomain:@"自家原生广告解析数据出错" code:-1 userInfo:nil];
            [self.delegate nativeAdWithManager:self didFailToReceiveWithError:error];
        }
    }
}

/**
 *  自家原生广告加载广告数据失败回调
 */
- (void)nativeAdFailToLoad:(NSError *)error {
    
    if (_delegateFlags.delegateDidFailToReceiveWithError) {
        [self.delegate nativeAdWithManager:self didFailToReceiveWithError:error];
    }
}

/**
 *  自家原生广告点击之后的回调
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
