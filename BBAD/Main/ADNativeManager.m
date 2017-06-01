//
//  ADNativeManager.m
//  BBAD
//
//  Created by Dongjw on 17/5/25.
//  Copyright © 2017年 Babybus. All rights reserved.
//

#import "ADBBNativeManager.h"

#ifdef ADPLATFORMGDT
#import "ADGDTNativeManager.h"
#import "GDTNativeAd.h"
#endif


#import "ADAnalysis.h"
#import "ADNativeConfig.h"

#import "ADNativeManager.h"

@implementation ADNativeManager

+ (id)createNativeAdWithConfig:(nonnull ADNativeConfig *)nativeConfig {
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(initWithConfig:) name:@"mytest" object:nil];
    if (!nativeConfig) {
        return nil;
    }
    
    if ([ADAnalysis sharedInstance].adConfigs) {
        // 假如请求页面广告数据不为空，则使用请求数据
        return [self useAdConfigsNative:nativeConfig];
    }else {
        // 使用默认数据
        return [self useDefaultPlatformNative:nativeConfig];
    }
}

- (void)mytest {

//    self = [[self class] initAllNativePlatform:4 withConfig:a];
}

+ (id)useAdConfigsNative:(ADNativeConfig *)nativeConfig {
    
    for (ADConfig *config in [ADAnalysis sharedInstance].adConfigs) {
        // 匹配服务端响应页面与当前页面
        if (nativeConfig.page == config.page) {
        
            // 初始化响应页面的第一个平台
            return [self initAllNativePlatform:[config.adPlatformAry[0] intValue] withConfig:nativeConfig];
        }
    }
    return nil;
}

+ (id)useDefaultPlatformNative:(ADNativeConfig *)nativeConfig {
    return [self initAllNativePlatform:nativeConfig.defaultPlatform withConfig:nativeConfig];
}

/**
 初始化广告平台

 @param platform 需要使用的广告平台
 @param config 默认信息
 @return <ADNativeProtocol>单个界面原生广告管理者
 */
+ (id)initAllNativePlatform:(int)platform withConfig:(ADNativeConfig *)config {
    switch (platform) {
            
        case ADPlatformBabybus:
            return [[ADBBNativeManager alloc] initWithConfig:config];
            
#ifdef ADPLATFORMGDT
        case ADPlatformGDT:
            return [[ADGDTNativeManager alloc] initWithConfig:config];
#endif
            
        default:
            return nil;
    }
}

#pragma mark - parse
/**
 平台广告返回数据解析器，用于统一不同平台返回的原生广告数据
 
 @param nativeData 第三方平台广告原始数据
 @param platform 平台
 @return 处理后的数据，GDT为数组类型包含ADNativeContent，其它平台为ADNativeContent类型
 */
- (id)parseAdTypeFrom:(id)nativeData withADPlatform:(ADPlatform)platform {
    
    self.contentMAry = [[NSMutableArray alloc] init];
    
    switch (platform) {
        case ADPlatformBabybus:
            return [self parseFromBabybusNative:nativeData];
#ifdef ADPLATFORMGDT
        case ADPlatformGDT:
            return [self parseFromGDTNative:nativeData];
#endif
            
        default:{
            self.contentMAry = nil;
            return nil;
        }
    }
}

- (NSMutableArray<ADNativeContent *>*)parseFromBabybusNative:(NSArray *)dataAry {
    
    if (!dataAry || [dataAry count] == 0) {
        return nil;
    }
    
    for (int i = 0; i < dataAry.count; i ++ ) {

        if (!dataAry[i] || ![dataAry[i] isKindOfClass:[NSDictionary class]]) {
            break;
        }else {
            
            ADNativeContent *content = [[ADNativeContent alloc] init];
            content.title = dataAry[i][@"title"];
            content.imageUrl = dataAry[i][@"img"];
            content.describe = dataAry[i][@"desc"];
            content.nativeOriginalData = dataAry[i];

            [self.contentMAry addObject:content];
        }
    }
    return self.contentMAry;
}

#ifdef ADPLATFORMGDT
- (NSMutableArray<ADNativeContent *>*)parseFromGDTNative:(NSArray *)dataAry {
    
    if (!dataAry || [dataAry count] == 0) {
        return nil;
    }

    for (int i = 0; i < dataAry.count; i ++ ) {
        GDTNativeAdData *nativeAdData = dataAry[i];
        if (!nativeAdData.properties || ![nativeAdData.properties isKindOfClass:[NSDictionary class]]) {
            break;
        }else {
            
            ADNativeContent *content = [[ADNativeContent alloc] init];
            content.title = [nativeAdData.properties valueForKey:@"title"];
            content.imageUrl = [nativeAdData.properties valueForKey:@"img"];
            content.describe = [nativeAdData.properties valueForKey:@"desc"];
            content.nativeOriginalData = nativeAdData;
            
            [self.contentMAry addObject:content];
        }
    }
    return self.contentMAry;
}
#endif

#pragma mark - overwrite

- (void)setDelegate:(id<ADNativeDelegate>)delegate {
    
    if (_delegate != delegate) {
        _delegate = delegate;
        
        _delegateFlags.delegateDidReceiveAdType				= [_delegate respondsToSelector:@selector(nativeAdWithManager:didReceiveContent:)];
        _delegateFlags.delegateDidFailToReceiveWithError  = [_delegate respondsToSelector:@selector(nativeAdWithManager:didFailToReceiveWithError:)];
        _delegateFlags.delegateNativeAdWillPresentScreen  = [_delegate respondsToSelector:@selector(nativeAdWillPresentScreenWithManager:)];
        _delegateFlags.delegateNativeAdApplicationWillEnterBackground  = [_delegate respondsToSelector:@selector(nativeAdApplicationWillEnterBackgroundWithManager:)];
        _delegateFlags.delegateNativeAdClosed  = [_delegate respondsToSelector:@selector(nativeAdClosedWithManager:)];
        
    }
}

- (instancetype)initWithConfig:(nonnull ADNativeConfig *)nativeConfig {
    self = [super init];
    return self;
}

- (void)startRequest {}

- (void)stop {}

- (void)attachNativeAd:(ADNativeContent *)nativeAdData toView:(UIView *)view {}

- (void)clickNativeAd:(ADNativeContent *)nativeAdData {}

@end
