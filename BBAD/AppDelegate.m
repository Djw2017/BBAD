//
//  AppDelegate.m
//  BBAD
//
//  Created by Dongjw on 17/5/23.
//  Copyright © 2017年 Babybus. All rights reserved.
//

#import "AppDelegate.h"
#import "ADSplashManager.h"

#import "ADAnalysis.h"

@interface AppDelegate () <ADKSplashAdDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    [[ADAnalysis sharedInstance] startAnalysis];
    
//    [[ADSplashManager sharedInstance] startSplashWith:nil];
//    [ADSplashManager sharedInstance].delegate = self;
    return YES;
}

/// 开屏广告请求成功
- (void)splashRequestSuccess:(ADSplashManager *)splashAd {
    NSLog(@"==================b050");
//    广告曝光
//    AdCountModel *model = [[AdCountModel alloc] init];
//    model.ad_title = _currentSplashContent.title;
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

- (void)splashRequestFail:(ADSplashManager *)splashAd withError:(NSError *)err {
    NSLog(@"- (void)splashRequestFail:(ADSplashManager *)splashAd withError:(NSError *)err");
}

/// 开屏广告已经展示
- (void)splashDidPresentScreen:(ADSplashManager *)splashAd {
    NSLog(@"- (void)splashDidPresentScreen:(ADSplashManager *)splashAd");
}

/// 用户点击开屏广告
- (void)splashDidUserClickedAd:(ADSplashManager *)splashAd withContent:(ADSplashContent *)splashContent {
    NSLog(@"==================b12");
    
//    NSString *url;
//    if([splashContent.type intValue] == 3){//打开帖子
//        url = splashContent.url;
//        [_rootTabbarController pushToWelfareVCFromSocialVC:url];
//        return;
//    }
//    else if([splashContent.type intValue] == 1){//下载app
//        url = splashContent.app_download;
//    }
//    else if([splashContent.type intValue] == 2){//打开web
//        url = splashContent.url;
//    }
//    NSRange range=[url rangeOfString:@"itms-apps://"];
//    NSRange range2=[url rangeOfString:@"https://itunes.apple.com/"];
//    if (range.length != 0 || range2.length !=0) {
//        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
//    }else{
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



@end
