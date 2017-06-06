//
//  ADBBSplashManager.m
//  BBAD
//
//  Created by Dongjw on 17/6/1.
//  Copyright © 2017年 Babybus. All rights reserved.
//

#import "ADBBSplashManager.h"

#import "ADSplashView.h"

@interface ADBBSplashManager () <ADSplashViewDelegate>
{
    
    // 需要展示的广告图片地址
    NSString *_splashImageUrlStr;
    
    // 整个广告视图
    ADSplashView *_splashView;
    
    ADSplashConfig *_currentSplashConfig;
}
@end

@implementation ADBBSplashManager

- (instancetype)initWithConfig:(ADSplashConfig *)splashConfig {
    self = [super initWithConfig:splashConfig];
    if (self) {
        _currentSplashConfig = splashConfig;
    }
    return self;
}

- (void)startRequest {
    if (!_splashView) {
        _splashView = [[ADSplashView alloc] init];
        _splashView.splashVdelegate = self;
    }
    [_splashView showToRoot];
    [self adImageViewIsShow];
}

/**
 请求成功后，发送消息，splashView开始展示
 */
- (void)adImageViewIsShow {
    
    if (_delegateFlags.delegateSplashRequestSuccess) {
        [self.delegate splashRequestSuccess:self];
    }
    
    if (_splashView.isExcuting) {
        _splashImageUrlStr = UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad?_currentSplashConfig.ipad_image:_currentSplashConfig.phone_image;
        NSRange range = [_splashImageUrlStr rangeOfString:@"http"];
        NSUInteger location = range.location;
        
        
        if ( location != NSNotFound) {
            [_splashView displayWithPortraitADImage:_splashImageUrlStr landscapeADImage:nil interval:_currentSplashConfig.showInterval];
        } else{
            //        [_adImageView sd_setImageWithURL:URL_IMAGE_HTTP(_splashImageUrlStr)];
        }
    }
}

- (void)setSplashBackgroundImageStr:(NSString *)splashBackgroundImageStr {
    if (!_splashView) {
        _splashView = [[ADSplashView alloc] init];
        _splashView.splashVdelegate = self;
    }
    _splashView.splashBackgroundImageStr = splashBackgroundImageStr;
}




#pragma mark - ADSplashViewDelegate

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
    
    ADAction action = [_currentSplashConfig.type integerValue];
    if (action == KADActionNone) {
        
    }else if(action == KADActionOpensInStoreKit) {
        
        NSString *url = _currentSplashConfig.url;
        NSRange range=[url rangeOfString:@"itms-apps://"];
        NSRange range2=[url rangeOfString:@"https://itunes.apple.com/"];
        if (range.length != 0 || range2.length !=0) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
        }
        
    }
    
    if (_delegateFlags.delegateSplashDidUserClickedAd) {
        [self.delegate splashDidUserClickedAd:self withContent:_currentSplashConfig];
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
