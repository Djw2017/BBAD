//
//  AppDelegate.m
//  BBAD
//
//  Created by Dongjw on 17/5/23.
//  Copyright © 2017年 Babybus. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    [self creatRootViewController];
//    [[ADAnalysis sharedInstance] startAnalysis];
    
//    ADSplashManager *splash = [[ADSplashManager alloc] init];
//    splash.delegate = self;
//    [splash startSplash];
//    [ADSplashManager sharedInstance].splashBackgroundImage = [UIImage imageNamed:@""];
    [ADSplashManager sharedInstance].debugMode = YES;
    [ADSplashManager sharedInstance].delegate = self;
    [[ADSplashManager sharedInstance] startSplash];
    return YES;
}

/// 开屏广告请求成功
- (void)splashRequestSuccess:(ADSplashManager *)splashAd {
    NSLog(@"==================b050");
//    广告曝光
//    AdCountModel *model = [[AdCountModel alloc] init];
//    model.ad_title = _currentSplashConfig.title;
//    model.begin_date = @"";
//    model.end_date = @"";
//    model.ad_position = @"开屏广告";
//    model.ad_exposure = 1;
//    model.ad_click = @"0";
//    model.ad_url = _splashImageUrlStr;
//    BOOL isHaveAd = NO;
//    for (AdCountModel *adModel in CurAppDelegate.adCountArray) {
//        if ([adModel.ad_title isEqualToString:model.ad_title] && [adModel.begin_date isEqualToString:model.begin_date] && [adModel.end_date isEqualToString:model.end_date] && [adModel.ad_position isEqualToString:model.ad_position]) {
//            adModel.ad_exposure += 1;
//            isHaveAd = YES;
//            break;
//        }
//    }
//    if (!isHaveAd) {
//        [CurAppDelegate.adCountArray addObject:model];
//    }
}

- (void)splashShowFail:(ADSplashManager *)splashAd withError:(NSError *)err {
    NSLog(@"%s",__FUNCTION__);
}

/// 开屏广告已经展示
- (void)splashDidPresentScreen:(ADSplashManager *)splashAd {
    NSLog(@"%s",__FUNCTION__);
}

/// 用户点击开屏广告
- (void)splashDidUserClickedAd:(ADSplashManager *)splashAd withContent:(ADSplashConfig *)splashContent {
    NSLog(@"==================b12");
    if (splashContent.platform == ADPlatformBabybus) {
        [splashAd stopSplash];
    }
//    NSString *url;
//    if([splashContent.type intValue] == 3){//打开帖子
//        url = splashContent.url;
//        [_rootTabbarController pushToWelfareVCFromSocialVC:url];
//        return;
//    }
//    else if([splashContent.type intValue] == 2){//打开web
//        url = splashContent.url;
//    }
//    NSRange range=[url rangeOfString:@"itms-apps://"];
//    NSRange range2=[url rangeOfString:@"https://itunes.apple.com/"];
//    if (range.length == 0 && range2.length ==0) {
//        [_rootTabbarController openWebFormRecommendVC:url];
//    }
    
    //广告点击
    //    NSString *string = [NSString stringWithFormat:@"\"ad_title\":%@,\"begin_date\":%@,\"end_date\":%@,\"ad_position\":%@,\"ad_exposure\":0,\"ad_click\":1,\"ad_url\":%@  ",splashContent.title,@"",@"",@"开屏广告",_urlImage];
    //    NSDictionary *parameter = [NSDictionary dictionaryWithObjectsAndKeys:string,@"string", nil];
    
    //    NSDictionary *parameter = [NSDictionary dictionaryWithObjectsAndKeys:@"",@"begin_date",@"",@"end_date",@"开屏广告",@"pos",@"0",@"exposure",@"1",@"clicks",_urlImage,@"url",splashContent.title,@"title", nil];
    //    [RGHttpsHelper adCount:parameter];
    
}

/// 开屏广告展示结束
- (void)splashDidDismissScreen:(ADSplashManager *)splashAd {
    NSLog(@"==================b038");
    
    //首页banner开始addTimer
    [[NSNotificationCenter defaultCenter] postNotificationName:@"addTimerNowForBanner" object:nil];
}


- (void)creatRootViewController {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.viewController = [[ViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:self.viewController];
    nav.navigationBar.barStyle = UIBarStyleDefault;
    nav.navigationBar.topItem.title = @"广告";
    self.window.backgroundColor = [UIColor whiteColor];
    self.window.rootViewController = nav;
    [self.window makeKeyAndVisible];
}

@end
