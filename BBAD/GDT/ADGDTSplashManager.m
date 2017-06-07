//
//  ADGDTSplashManager.m
//  BBAD
//
//  Created by Dongjw on 17/6/1.
//  Copyright © 2017年 Babybus. All rights reserved.
//

#import <BBSDK/BBUIUtility.h>

#import "ADGDTSplashManager.h"

#import "GDTSplashAd.h"

@interface ADGDTSplashManager () <GDTSplashAdDelegate>
{
    ADSplashConfig *_currentSplashConfig;
}
@property (strong, nonatomic) GDTSplashAd *splash;
@property (strong, nonatomic) UIView *bottomView;
@property (strong, nonatomic) UIImageView *logo;
@end

@implementation ADGDTSplashManager 

- (instancetype)initWithConfig:(ADSplashConfig *)splashConfig {
    self = [super initWithConfig:splashConfig];
    if (self) {
        _currentSplashConfig = splashConfig;
    }
    return self;
}

- (void)startRequest {
    //开屏广告初始化并展示代码
    self.splash = [[GDTSplashAd alloc] initWithAppkey:_currentSplashConfig.third_appkey placementId:_currentSplashConfig.third_placementId];
    self.splash.delegate = self; //设置代理 //根据iPhone设备不同设置不同背景图
    self.splash.backgroundColor = [UIColor colorWithPatternImage:[ADSplashManager sharedInstance].splashBackgroundImage];
    self.splash.fetchDelay = [ADSplashManager sharedInstance].fetchDelay;
    self.bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, 100)];
    _logo = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"BBAD.bundle/SplashBottomLogo"]];
    [self.bottomView addSubview:_logo];
    _logo.center = self.bottomView.center;
    self.bottomView.backgroundColor = [UIColor whiteColor];
    [self.splash loadAdAndShowInWindow:[BBUIUtility window] withBottomView:self.bottomView];
}

-(void)splashAdSuccessPresentScreen:(GDTSplashAd *)splashAd
{
    if (_delegateFlags.delegateSplashDidPresentScreen) {
        [self.delegate splashDidPresentScreen:self];
    }
}

-(void)splashAdFailToPresent:(GDTSplashAd *)splashAd withError:(NSError *)error
{
    if (_delegateFlags.delegateSplashShowFail) {
        [self.delegate splashShowFail:self withError:error];
    }
}

-(void)splashAdApplicationWillEnterBackground:(GDTSplashAd *)splashAd
{
    
}

-(void)splashAdClicked:(GDTSplashAd *)splashAd
{
    if (_delegateFlags.delegateSplashDidUserClickedAd) {
        [self.delegate splashDidUserClickedAd:self withContent:_currentSplashConfig];
    }
}

-(void)splashAdClosed:(GDTSplashAd *)splashAd
{
    self.splashing = NO;
    if (_delegateFlags.delegateSplashDidDismissScreen) {
        [self.delegate splashDidDismissScreen:self];
    }
    _splash = nil;
}

-(void)splashAdWillPresentFullScreenModal:(GDTSplashAd *)splashAd
{
    
}

-(void)splashAdDidDismissFullScreenModal:(GDTSplashAd *)splashAd
{

}

@end
