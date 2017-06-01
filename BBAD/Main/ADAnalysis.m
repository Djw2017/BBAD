//
//  ADAnalysis.m
//  BBAD
//
//  Created by Dongjw on 17/5/26.
//  Copyright © 2017年 Babybus. All rights reserved.
//

#import "ADAnalysis.h"
#import "ADNetworkLoader.h"

// 最大重试请求数，用以请求页面平台
static const int AD_REQUEST_RETRY_MAXIMUM = 5;
// 重连时间
static const int AD_REQUEST_RETRY_INTERVAL = 10;

static const NSTimeInterval kADAnalysisThreadInterval = 5.0f;

@interface ADAnalysis ()
{
    /// 重试次数
    NSInteger _requestRetryCount;
}

/// 定时器，用于实时分析广告数据
@property (nonatomic, strong) NSTimer *analysisThread;

@property (nonatomic, strong) dispatch_queue_t analysisQueue;

@property (nonatomic, strong, readwrite) NSArray *adConfigs;

/// 上一次线程执行时间
@property (nonatomic, strong) NSDate *lastAnalysisDate;

/// 广告加载器
@property (nonatomic, strong) ADNetworkLoader *adLoader;

@end

@implementation ADAnalysis

SingletonM;

- (instancetype)init {
    
    if (self = [super init]) {
        
        _analysisQueue = dispatch_queue_create("ad.analysis.run", DISPATCH_QUEUE_SERIAL);
        
        self.adLoader = [[ADNetworkLoader alloc] init];
        
    }
    return self;
}

- (void)startAnalysis {
    
    // 重试超过最大请求重试数，中断重试
    if (_requestRetryCount > AD_REQUEST_RETRY_MAXIMUM) {
        return;
    }
    NSLog(@"Request ADs...");
    
    self.lastAnalysisDate = [NSDate date];
    
    // 首次加载请求，展示遮罩视图
//    if (_requestRetryCount == 0) {
//        [self __prepareForSplashAd];
//    }
    
    [self.adLoader cancel];
    
    @weakify(self)
    [self.adLoader loadAdConfigsWithVersion:@"1"
                                  completed:^(NSArray<ADConfig *> *ads, NSError *error) {
                                      
                                      if (error) {
                                          // 延迟重试
                                          [weak_self performSelector:@selector(retry)
                                                          withObject:nil
                                                          afterDelay:AD_REQUEST_RETRY_INTERVAL];
                                      }else {
                                          
                                          NSLog(@"Reqeust ADs Success.");
                                          [weak_self start:ads];
                                          
//                                          [[ADKUnionAdCache sharedInstance] setCacheAdConfigs:ads];
                                      }
                                  }];
}

/**
 请求数据成功，开始执行所有广告线程

 @param adConfigs 广告配置数组
 */
- (void)start:(NSArray<ADConfig *> *)adConfigs {
    
    self.adConfigs = adConfigs;

    if ([self.adConfigs count] < 1) {
        NSLog(@"Stop the analysis Thread. Error: [ADs Count <= 0]");
//        [self stopAnalysisThread];
    } else {
        
        // 分析
        [self analysisAllAD];

    }
}

/**
 分析所有广告线程
 */
- (void)analysisAllAD {
    //        NSMutableString *logString = [NSMutableString stringWithString:@"\n\n"];
    //        [logString appendString:@"获取广告配置信息...\n"];
    //
    //        [self.adConfigs enumerateObjectsUsingBlock:^(NSObject *adConfig, NSUInteger idx, BOOL * _Nonnull stop) {
    //            [logString appendString:[adConfig debugDescription]];
    //        }];
    //        [logString appendString:@"\n\n"];
    //        NSLog(@"%@",logString);
    
    NSLog(@"Start the analysis Thread.");
    ///执行开屏线程
    //        [self analysisAdSplashConfigs];
    
    ///分析原生广告数据
    [self analysisNativeAdConfigs];
    
    ///执行其它广告线程
    [self startAnalysisThread];
}

- (void)retry {
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(retry) object:nil];
    
    _requestRetryCount++;
    [self startAnalysis];
}




#pragma mark - Analysis Thread

- (void)stopAnalysisThread {
    
    if (self.analysisThread) {
        [self.analysisThread invalidate];
        self.analysisThread = nil;
    }
}

- (void)startAnalysisThread {
    
    [self stopAnalysisThread];
    
    self.analysisThread = [[NSTimer alloc] initWithFireDate:[NSDate date]
                                                   interval:kADAnalysisThreadInterval
                                                     target:self selector:@selector(timerAdvandce)
                                                   userInfo:nil
                                                    repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.analysisThread forMode:NSDefaultRunLoopMode];
}

- (void)timerAdvandce {
    
    dispatch_async(_analysisQueue, ^{
        [self analysisAdConfigs];
    });
}

- (void)analysisAdConfigs {
    
    for (ADConfig *config in self.adConfigs) {
        
        if (!config || ![config isValid]) { //后台禁用
            continue;
        }
        
//        if ([config adType] == ADKAdTypeBanner ) {
//            
//            [self __analysisBannerAndInterstitialWithConfig:config];
//            
//        }else if (self.enableInterstitial && [config adType] == ADKAdTypeInterstitial ) {
//            
//            [self __analysisBannerAndInterstitialWithConfig:config];
//            
//        }
        else if (config.adType == ADTypeNative) {
            
            [self __analysisBannerAndInterstitialWithConfig];
            
        }
        
    }
}

- (void)__analysisBannerAndInterstitialWithConfig {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"mytest" object:nil];
}

- (void)analysisNativeAdConfigs {
    
//    NSMutableArray *nativeAdConfigs = [NSMutableArray array];
//    
//    for (ADConfig *config in self.adConfigs) {
//        
//        if (!config || ![config isValid]) { //后台禁用
//            continue;
//        }
//        
//        if (config.adType == ADTypeNative ) {
//            
//            [nativeAdConfigs addObject:config];
//        }
//    }
//    
//    for (id<IADKUnionAdNativeDelegate> delegate in self.forwardAdNativeDelegates) {
//        if ([delegate respondsToSelector:@selector(adkUnionAdNativeDidReceiveAd:)]) {
//            [delegate adkUnionAdNativeDidReceiveAd:nativeAdConfigs];
//        }
//    }
}

@end
