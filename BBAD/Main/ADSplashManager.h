//
//  ADSplashManager.h
//  BBAD
//
//  Created by Dongjw on 17/5/11.
//  Copyright © 2017年 sinyee.babybus. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

#import "ADDefine.h"
#import "ADSplashDelegate.h"

#import "ADSplashContent.h"

@interface ADSplashManager : NSObject
{
    // 当前开屏数据
    ADSplashContent *_currentSplashContent;
    
}

+ (ADSplashManager *)sharedInstance;

/// 设置开屏广告管理代理
@property (nonatomic, weak) id<ADKSplashAdDelegate> delegate;

/// 是否正在显示开屏广告
@property (nonatomic, assign, getter=isSplashing) BOOL splashing;

/// 是否自动消失
@property (nonatomic, assign, getter=isAutoDismiss) BOOL autoDismiss;

/// 广告展示时间
@property (nonatomic, assign) NSInteger showInterval;

/// 开屏图默认背景-竖屏
@property (nonatomic, strong) NSString *splashBackgroundImageStr;


/**
 开启开屏广告
 */
- (void)startSplashWith:(NSDictionary *)splash;

/**
 强制停止开屏广告
 */
- (void)stopSplash;

@end
