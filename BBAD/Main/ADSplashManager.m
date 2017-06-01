//
//  ADSplashManager.m
//  BBAD
//
//  Created by Dongjw on 17/5/11.
//  Copyright © 2017年 sinyee.babybus. All rights reserved.
//

#import <BBNetwork/BBNetwork.h>
#import <BBSDK/BBMacros.h>

#import "ADSplashManager.h"

#import "ADSplashView.h"

@interface ADSplashManager ()<ADSplashViewDelegate>
{
    @package
    
    struct {
        /// 开屏广告请求成功，开屏广告即将展示
        unsigned int delegateSplashRequestSuccess			: 1;
        /// 开屏广告请求失败
        unsigned int delegateSplashRequestFail				: 1;
        /// 开屏广告已经展示
        unsigned int delegateSplashDidPresentScreen         : 1;
        /// 开屏广告展示结束
        unsigned int delegateSplashDidDismissScreen         : 1;
        /// 用户点击开屏广告
        unsigned int delegateSplashDidUserClickedAd         : 1;
        
    }_delegateFlags;
    
    // 需要展示的广告图片地址
    NSString *_splashImageUrlStr;
    
    // 整个广告视图
    ADSplashView *_splashView;
}

@end

@implementation ADSplashManager

static ADSplashManager *_sharedInstance = nil;

+ (ADSplashManager *)sharedInstance {

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        _sharedInstance = [[self alloc] init];
        // 未显示开屏广告
        _sharedInstance.splashing = NO;
        // 开屏广告自动消失
        _sharedInstance.autoDismiss = YES;
        // 开屏广告默认展示时间
        _sharedInstance.showInterval = 3;
    });
    return _sharedInstance;
}




#pragma mark - property set
- (void)setDelegate:(id<ADKSplashAdDelegate>)delegate {
    
    if (_delegate != delegate) {
        _delegate = delegate;
        
        _delegateFlags.delegateSplashRequestSuccess		= [_delegate respondsToSelector:@selector(splashRequestSuccess:)];
        _delegateFlags.delegateSplashRequestFail		= [_delegate respondsToSelector:@selector(splashRequestFail:withError:)];
        _delegateFlags.delegateSplashDidPresentScreen	= [_delegate respondsToSelector:@selector(splashDidPresentScreen:)];
        _delegateFlags.delegateSplashDidUserClickedAd	= [_delegate respondsToSelector:@selector(splashDidUserClickedAd:withContent:)];
        _delegateFlags.delegateSplashDidDismissScreen	= [_delegate respondsToSelector:@selector(splashDidDismissScreen:)];
    }
}

- (void)setSplashBackgroundImageStr:(NSString *)splashBackgroundImageStr {
    if (!_splashView) {
        _splashView = [[ADSplashView alloc] init];
        _splashView.splashViewDelegate = self;
    }
    _splashView.splashBackgroundImageStr = splashBackgroundImageStr;
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
        if (!_splashView) {
            _splashView = [[ADSplashView alloc] init];
            _splashView.splashViewDelegate = self;
        }
        [_splashView showToRoot];
        [self startReqeustSplashAd];
    }
}

/**
 强制停止开屏广告
 */
- (void)stopSplash {
    [_splashView removeForRoot];
}




#pragma mark - inward method
/**
 开启开屏广告时，开始请求开屏广告数据
 */
- (void)startReqeustSplashAd {
    
    [BBNetworkManager postURLString:URL_AD_RECOMMEND parameters:nil success:^(id  _Nonnull responseObject) {
        
        NSDictionary *responseDic = (NSDictionary *)responseObject;
   
        [responseDic[@"data"] enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            if ([obj isKindOfClass:[NSDictionary class]]) {
                _currentSplashContent = [[ADSplashContent alloc] initWithDic:obj];
            }else{
                return ;
            }
            
            // 时间有效则展示
            BOOL beginIsSmall = [_currentSplashContent.begin_date integerValue]<[responseDic[@"always_time"] integerValue];
            BOOL endIsBig = [_currentSplashContent.end_date integerValue]>[responseDic[@"always_time"] integerValue];
            
            if (beginIsSmall && endIsBig){
                
                // 开屏广告位可以展示请求的广告
                [self adImageViewIsShow];
                
                *stop = YES;
            }
        }];
        
    } failure:^(NSError * _Nonnull error) {
        if (_delegateFlags.delegateSplashRequestFail) {
            [self.delegate splashRequestFail:self withError:error];
        }
    }];
}

/**
 请求成功后，发送消息，splashView开始展示
 */
- (void)adImageViewIsShow {
    
    if (_delegateFlags.delegateSplashRequestSuccess) {
        [self.delegate splashRequestSuccess:self];
    }
    
    if (_splashView.isExcuting) {
        _splashImageUrlStr = IS_IPAD?_currentSplashContent.ipad_image:_currentSplashContent.phone_image;
        NSRange range = [_splashImageUrlStr rangeOfString:@"http"];
        NSUInteger location = range.location;
        
        
        if ( location != NSNotFound) {
            [_splashView displayWithPortraitADImage:_splashImageUrlStr landscapeADImage:nil interval:self.showInterval];
        } else{
            //        [_adImageView sd_setImageWithURL:URL_IMAGE_HTTP(_splashImageUrlStr)];
        }
    }
}




#pragma mark -ADSplashViewDelegate

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
    if (_delegateFlags.delegateSplashDidUserClickedAd) {
        [self.delegate splashDidUserClickedAd:self withContent:_currentSplashContent];
    }
}

/**
 开屏广告视图执行结束
 
 @param splashAdView 当前开屏广告视图
 */
- (void)splashAdViewDidDisplayCompleted:(ADSplashView *)splashAdView {
    
    self.splashing = NO;
    if (_delegateFlags.delegateSplashDidDismissScreen) {
        [self.delegate splashDidDismissScreen:self];
    }
}

@end
