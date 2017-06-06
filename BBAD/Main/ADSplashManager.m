//
//  ADSplashManager.m
//  BBAD
//
//  Created by Dongjw on 17/5/11.
//  Copyright © 2017年 sinyee.babybus. All rights reserved.
//

#import <BBNetwork/BBNetwork.h>
#import <BBSDK/NSUserDefaults+BBSDK.h>

#import "ADBBSplashManager.h"
#import "ADGDTSplashManager.h"
#import "ADIFLYSplashManager.h"
#import "ADNetworkLoader.h"

#import "ADSplashConfig.h"
#import "ADSplashManager.h"

NSString *const KSplashKey = @"splash_ResponseDic";

@interface ADSplashManager ()
{
    ADSplashManager *_manager;
}
@end


static ADSplashManager * _instance;

@implementation ADSplashManager

+ (instancetype)sharedInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
        // 未显示开屏广告
        _instance.splashing = NO;

//        _instance.testNetwork = NO;
        
        /// 拉取广告超时时间
        _instance.fetchDelay = 3;
        
        _instance.splashBackgroundImage = [_instance splashBackgroundImage];
    });
    return _instance;
}

#pragma mark - property
- (void)setDelegate:(id<ADSplashDelegate>)delegate {
    
    if (_delegate != delegate) {
        _delegate = delegate;
        
        _delegateFlags.delegateSplashRequestSuccess		= [_delegate respondsToSelector:@selector(splashRequestSuccess:)];
        _delegateFlags.delegateSplashShowFail           = [_delegate respondsToSelector:@selector(splashShowFail:withError:)];
        _delegateFlags.delegateSplashDidPresentScreen	= [_delegate respondsToSelector:@selector(splashDidPresentScreen:)];
        _delegateFlags.delegateSplashDidUserClickedAd	= [_delegate respondsToSelector:@selector(splashDidUserClickedAd:withContent:)];
        _delegateFlags.delegateSplashDidDismissScreen	= [_delegate respondsToSelector:@selector(splashDidDismissScreen:)];
    }
}

- (UIImage *)splashBackgroundImage {
        
    CGFloat scale = [UIScreen mainScreen].scale;
    NSString* imageName = [NSString stringWithFormat:@"%0.0fx%0.0f",SCREEN_FULL_HEIGHT*scale,SCREEN_FULL_WIDTH*scale];
    
    UIImage *ig = [UIImage imageNamed:imageName];
    //6p 9.0.2系统 imageName = "2001x1125"
    if (ig == nil) {
        if (667 == SCREEN_FULL_HEIGHT) {
            ig = [UIImage imageNamed:@"2208x1242"];
        }
    }
    return ig;
}




#pragma mark - view life cycle
/**
 开启开屏广告
 */
- (void)startSplashWith:(NSDictionary *)splash {
    
    if (self.isSplashing) {
        return;
    }
    // 正在显示开屏
    self.splashing = YES;
    
    if (splash) {
        
    }else {

        [self startReqeustSplashAd];
    }
}

#pragma mark - inward method
/**
 开启开屏广告时，开始请求开屏广告数据
 */
- (void)startReqeustSplashAd {

    // 读取上次缓存数据，从未缓存则不会展示开屏
    if ([NSUserDefaults retrieveObjectForKey:KSplashKey]) {
        NSDictionary *dic = [NSUserDefaults retrieveObjectForKey:KSplashKey];
        if ([dic[@"allow"] isEqualToString:@"YES"]) {
            ADSplashConfig *config = [[ADSplashConfig alloc] initWithDic:dic];
            [self initAllSplashPlatformWithConfig:config];
        }
    }
    // 请求广告数据，下次展示
    [ADNetworkLoader loadSplashAdConfigCompleted:^(ADSplashConfig *currentSplashConfig, NSError *error) {
        if (error) {
            if (error.code == -1) {
                [NSUserDefaults saveObject:@{@"allow": @"NO"}
                                    forKey:KSplashKey];
            }
            [self splashShowFail:self withError:error];
        }else {
            if (currentSplashConfig.platform == ADPlatformBabybus) {
                [NSUserDefaults saveObject:@{@"allow": @"YES",
                                             @"ad_channel": @"0",
                                             @"ipad_image":currentSplashConfig.ipad_image,
                                             @"phone_image": currentSplashConfig.phone_image,
                                             @"delay_time": [NSString stringWithFormat:@"%d",currentSplashConfig.showInterval*1000]}
                                    forKey:KSplashKey];
            }else {
                [NSUserDefaults saveObject:@{@"allow": @"YES",
                                             @"ad_channel": [NSString stringWithFormat:@"%d",currentSplashConfig.platform],
                                             @"delay_time": [NSString stringWithFormat:@"%d",currentSplashConfig.showInterval*1000]}
                                    forKey:KSplashKey];
            }

        }
    }];
}



/**
 初始化广告平台
 
 @param config 平台
 */
- (void)initAllSplashPlatformWithConfig:(ADSplashConfig *)config {
    
    ADPlatform platform = config.platform;
    if (platform == ADPlatformBabybus) {
        _manager = [[ADBBSplashManager alloc] initWithConfig:config];
    }
    
#ifdef ADPLATFORMGDT
    else if (platform == ADPlatformGDT) {
        _manager = [[ADGDTSplashManager alloc] initWithConfig:config];
    }
#endif
    
#ifdef ADPLATFORMIFLY
    else if (platform == ADPlatformIFLY) {
        _manager = [[ADIFLYSplashManager alloc] initWithConfig:config];
    }
#endif
    
    if (_manager) {
        [_manager startRequest];
    }else {
        NSError *error = [NSError errorWithDomain:@"Ad type of the response was incorrect" code:KADSplashErrorPlatformNotSupported
                                         userInfo:nil];
        [self splashShowFail:self withError:error];
    }
}

/**
 开屏展示失败

 @param splashAd 当前控制器
 @param err 失败原因
 */
- (void)splashShowFail:(ADSplashManager *)splashAd withError:(NSError *)err {
    
    self.splashing = NO;
    if (_delegateFlags.delegateSplashShowFail) {
        // 开屏展示失败代理
        [self.delegate splashShowFail:self withError:err];
    }
}


#pragma mark - self Protocol
- (instancetype)initWithConfig:(ADSplashConfig *)splashConfig {
    self = [super init];
    return self;
}

- (void)startRequest {}

@end
