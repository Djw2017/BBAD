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

#ifdef ADPLATFORMIFLY
#import "ADIFLYNativeManager.h"
#import "IFLYNativeAd.h"
#endif

#import "ADAnalysis.h"
#import "ADNativeConfig.h"
#import "ADNativeManager.h"
#import "ADNetworkLoader.h"

@implementation ADNativeManager {

    ADNetworkLoader *_loader;
#ifdef ADPLATFORMGDT
    ADGDTNativeManager *_gdtmanager;
#endif
    
#ifdef ADPLATFORMIFLY
    ADIFLYNativeManager *_iflymanager;
#endif

}

- (instancetype)initWithPage:(ADPage)page {
    self = [super init];
    if (self) {

        _page = page;
            
//        if (nativeConfig.defaultPlatform) {
//            // 假如请求页面广告数据不为空，则使用请求数据
//            [self useAdConfigsNative:nativeConfig];
//        }else {
//            // 使用默认数据
//            return [self useDefaultPlatformNative:nativeConfig];
//        }

    }
    return self;
}

//+ (id)useAdConfigsNative:(ADNativeConfig *)nativeConfig {
//    
//    for (ADNativeConfig *config in [ADAnalysis sharedInstance].adConfigs) {
//        // 匹配服务端响应页面与当前页面
//        if (nativeConfig.page == config.page) {
//        
//            // 初始化响应页面的平台
//            return [self initAllNativePlatform:config.platform withConfig:nativeConfig];
//        }
//    }
//    return nil;
//}
//
//+ (id)useDefaultPlatformNative:(ADNativeConfig *)nativeConfig {
//    return [self initAllNativePlatform:nativeConfig.defaultPlatform withConfig:nativeConfig];
//}

/**
 初始化广告平台

 @param config 服务端响应
 */
- (void)initAllNativePlatformWithConfig:(ADNativeConfig *)config {
    
    ADNativeManager * manager;
    switch (config.platform) {
            
        case ADPlatformBabybus:
            manager = [[ADBBNativeManager alloc] initWithConfig:config];
            break;
            
#ifdef ADPLATFORMGDT
        case ADPlatformGDT:
            _gdtmanager = [[ADGDTNativeManager alloc] initWithConfig:config];
            manager = _gdtmanager;
            break;
#endif
   
#ifdef ADPLATFORMIFLY
        case ADPlatformIFLY:
            _iflymanager = [[ADIFLYNativeManager alloc] initWithConfig:config];
            manager = _iflymanager;
            break;
#endif
            
        default:
            break;

    }
    manager.ads = self.ads;
    manager.delegate = self;
    if (manager) {
        [manager startRequest];
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
            
#ifdef ADPLATFORMIFLY
        case ADPlatformIFLY:
            return [self parseFromIFLYNative:nativeData];
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
            
            for (ADNativeConfig *config in _ads) {
                if (config.platform == ADPlatformGDT) {
                    content.child_page = [config.child_page intValue];
                    content.platform = config.platform;
                    break;
                }
            }
            
            [self.contentMAry addObject:content];
        }
    }
    return self.contentMAry;
}
#endif

#ifdef ADPLATFORMIFLY
- (NSMutableArray<ADNativeContent *>*)parseFromIFLYNative:(NSArray *)dataAry {
    
    if (!dataAry || [dataAry count] == 0) {
        return nil;
    }
    
    for (int i = 0; i < dataAry.count; i ++ ) {
        IFLYNativeAdData *nativeAdData = dataAry[i];
        if (!nativeAdData.properties || ![nativeAdData.properties isKindOfClass:[NSDictionary class]]) {
            break;
        }else {
            
            ADNativeContent *content = [[ADNativeContent alloc] init];
            content.title = [nativeAdData.properties valueForKey:IFLYNativeAdDataKeyTitle];
            content.imageUrl = [nativeAdData.properties valueForKey:IFLYNativeAdDataKeyImg];
            content.describe = [nativeAdData.properties valueForKey:IFLYNativeAdDataKeySubTitle];
            content.nativeOriginalData = nativeAdData;
            
            for (ADNativeConfig *config in _ads) {
                if (config.platform == ADPlatformIFLY) {
                    content.child_page = [config.child_page intValue];
                    content.platform = config.platform;
                    break;
                }
            }
            
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
    if (!delegate) {
        [_loader cancel];
    }
}

- (instancetype)initWithConfig:(nonnull ADNativeConfig *)nativeConfig {
    self = [super init];
    return self;
}

- (void)startRequest {
    if ([self isMemberOfClass:[ADNativeManager class]]) {
        if (_page) {
            
            @weakify(self)
            _loader = [[ADNetworkLoader alloc] init];
            _loader.debugMode = self.debugMode;
            [_loader loadAdConfigsWithPage:_page completed:^(NSArray<ADNativeConfig *> *ads, NSError *error) {

                if (ads) {
                    weak_self.ads = ads;
                    
                    for (ADNativeConfig *config in ads) {
                        // 初始化响应页面的平台
                        if (config.count == 0) {
                            config.count = 5;
                        }

                        [self initAllNativePlatformWithConfig:(ADNativeConfig *)[ADAnalysis setThridKey:config]];
                    }
                }else {
                    
                    [self nativeAdWithManager:self didFailToReceiveWithError:error];
                
                }
            }];
        }
    }
}

- (void)stop {}

- (void)attachNativeAd:(ADNativeContent *)nativeContent toView:(UIView *)view {
    switch (nativeContent.platform) {
        case ADPlatformBabybus:
            break;
            
#ifdef ADPLATFORMGDT
        case ADPlatformGDT:
            [_gdtmanager attachNativeAd:nativeContent toView:view];
            break;
#endif

#ifdef ADPLATFORMIFLY
        case ADPlatformIFLY:
            [_iflymanager attachNativeAd:nativeContent toView:view];
            break;
#endif
        default:
            break;
    }
}

- (void)clickNativeAd:(ADNativeContent *)nativeContent {
    switch (nativeContent.platform) {
            
        case ADPlatformBabybus:
            break;
            
#ifdef ADPLATFORMGDT
        case ADPlatformGDT:
            [_gdtmanager clickNativeAd:nativeContent];
            break;
#endif

#ifdef ADPLATFORMIFLY
        case ADPlatformIFLY:
            [_iflymanager clickNativeAd:nativeContent];
            break;
#endif
        default:
            break;
    }
}




#pragma mark - ADNativeDelegate 连接内部广告主代理
- (void)nativeAdWithManager:(ADNativeManager *)nativeAd didReceiveContent:(NSMutableArray<ADNativeContent *>*)contentMAry {
    if (_delegateFlags.delegateDidReceiveAdType) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [_delegate nativeAdWithManager:self didReceiveContent:contentMAry];
        });
    }
}

- (void)nativeAdWithManager:(ADNativeManager *)nativeAd didFailToReceiveWithError:(NSError *)error {
    if (_delegateFlags.delegateDidFailToReceiveWithError) {
        [self.delegate nativeAdWithManager:self didFailToReceiveWithError:error];
    }
}

- (void)nativeAdWillPresentScreenWithManager:(ADNativeManager *)nativeAd {
    if (_delegateFlags.delegateNativeAdWillPresentScreen) {
        [self.delegate nativeAdWillPresentScreenWithManager:nativeAd];
    }
}

- (void)nativeAdApplicationWillEnterBackgroundWithManager:(ADNativeManager *)nativeAd {
    if (_delegateFlags.delegateNativeAdApplicationWillEnterBackground) {
        [self.delegate nativeAdApplicationWillEnterBackgroundWithManager:nativeAd];
    }
}

- (void)nativeAdClosedWithManager:(ADNativeManager *)nativeAd {
    if (_delegateFlags.delegateNativeAdClosed) {
        [self.delegate nativeAdClosedWithManager:nativeAd];
    }
}

- (void)dealloc {
    _loader = nil;
    _delegate = nil;
#ifdef ADPLATFORMGDT
    _gdtmanager = nil;
#endif
    
#ifdef ADPLATFORMIFLY
    _iflymanager = nil;
#endif
}

@end
