//
//  ADSplashManager.m
//  BBAD
//
//  Created by Dongjw on 17/5/11.
//  Copyright © 2017年 sinyee.babybus. All rights reserved.
//

#import <BBNetwork/BBNetwork.h>
#import <BBSDK/NSUserDefaults+BBSDK.h>

#import "ADAnalysis.h"

#ifdef ADPLATFORMGDT
#import "ADGDTSplashManager.h"
#endif

#ifdef ADPLATFORMIFLY
#import "ADIFLYSplashManager.h"
#endif

#import "ADBBSplashManager.h"
#import "ADNetworkLoader.h"

#import "ADSplashConfig.h"
#import "ADSplashManager.h"

NSString *const KSplashKey = @"splash_ResponseDic";

@interface ADSplashManager ()
{
    ADSplashManager *_manager;
    NSError *_error;
}
@end


static ADSplashManager * _instance;

@implementation ADSplashManager

+ (instancetype)sharedInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
//        _instance = [[self alloc] init];
        _instance = [self loadSplashConfigCache];
        
        // 未显示开屏广告
        _instance.splashing = NO;
      
        // 拉取广告超时时间
        _instance.fetchDelay = 3;
        
        _instance.splashBackgroundImage = _instance.splashBackgroundImage;
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
    
    NSString* imageName = [NSString stringWithFormat:@"BBAD.bundle/%0.0fx%0.0f",SCREEN_FULL_HEIGHT*scale,SCREEN_FULL_WIDTH*scale];
    
    UIImage *ig = [UIImage imageNamed:imageName];
    //6p 9.0.2系统 imageName = "2001x1125"
    if (ig == nil) {
        if (667 == SCREEN_FULL_HEIGHT) {
            ig = [UIImage imageNamed:@"BBAD.bundle/2208x1242"];
        }
    }
    return ig;
}




#pragma mark - view life cycle
/**
 开启开屏广告
 */
- (void)startSplash {
    
    if (self.isSplashing) {
        return;
    }
    // 正在显示开屏
    self.splashing = YES;

    [self startRequest];
    if (self.error) {
        [self splashShowFail:self withError:self.error];
    }
    [self startReqeustServerSplashAd];
}

/**
 强制停止开屏广告,只对自家广告有效
 */
- (void)stopSplash {
    if ([_instance isMemberOfClass:[ADBBSplashManager class]]) {
        [_instance stop];
    };
}




#pragma mark - inward method
/**
 开启开屏广告时，开始请求开屏广告数据
 */
- (void)startReqeustServerSplashAd {
    
    // 请求广告数据，下次展示
    [ADNetworkLoader loadSplashAdConfigCompleted:^(ADSplashConfig *currentSplashConfig, NSError *error) {
        if (error) {

            ADSplashConfig *currentSplashConfig = [[ADSplashConfig alloc] init];
            currentSplashConfig.error = error;
            currentSplashConfig.isValid = NO;
            NSData *data = [NSKeyedArchiver archivedDataWithRootObject:currentSplashConfig];
            [NSUserDefaults saveObject:data forKey:KSplashKey];
        }else {
            currentSplashConfig.isValid = YES;
            if (currentSplashConfig.platform == ADPlatformBabybus) {
                currentSplashConfig.platform = 0;
            }
            NSData *data = [NSKeyedArchiver archivedDataWithRootObject:currentSplashConfig];
            [NSUserDefaults saveObject:data forKey:KSplashKey];
        }
    }];
}

/**
 读取上次缓存数据，从未缓存则不会展示开屏
 */
+ (ADSplashManager *)loadSplashConfigCache {
    if ([NSUserDefaults retrieveObjectForKey:KSplashKey]) {

        NSData *data = [NSUserDefaults retrieveObjectForKey:KSplashKey];
        ADSplashConfig *config = [NSKeyedUnarchiver unarchiveObjectWithData:data];

        if (config.isValid) {
            return [self initAllSplashPlatformWithConfig:config];
        }else {
            _instance = [[self alloc] init];
            _instance.error = config.error;
            return _instance;
        }
    }else {
        _instance = [[self alloc] init];
        _instance.error = [NSError errorWithDomain:@"No cached data" code:KADSplashErrorNotCache userInfo:nil];
        return _instance;

    }
}

/**
 初始化广告平台
 
 @param config 平台
 */
+ (ADSplashManager *)initAllSplashPlatformWithConfig:(ADSplashConfig *)config {
    
    config.page = ADPageAppDelegate;
    config = (ADSplashConfig *)[ADAnalysis setThridKey:config];
    ADPlatform platform = config.platform;
    if (platform == ADPlatformBabybus) {
        _instance = [[ADBBSplashManager alloc] initWithConfig:config];
    }
    
#ifdef ADPLATFORMGDT
    else if (platform == ADPlatformGDT) {
        _instance = [[ADGDTSplashManager alloc] initWithConfig:config];
    }
#endif
    
#ifdef ADPLATFORMIFLY
    else if (platform == ADPlatformIFLY) {
        _instance = [[ADIFLYSplashManager alloc] initWithConfig:config];
    }
#endif
    
    if (_instance) {

        return _instance;
    }else {

        _instance = [[self alloc] init];
        _instance.error = [NSError errorWithDomain:@"Ad type of the response was incorrect" code:KADSplashErrorPlatformNotSupported
                                          userInfo:nil];
        return _instance;
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
