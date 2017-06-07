//
//  ADNetworkLoader.h
//  BBAD
//
//  Created by Dongjw on 17/5/26.
//  Copyright © 2017年 Babybus. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ADNativeConfig.h"
#import "ADSplashConfig.h"

typedef void(^ADNetworkLoaderNativeBlock) (NSArray<ADNativeConfig*> *ads ,NSError *error);


/**
 开屏数据回调

 @param currentSplashConfig 开屏广告数据
 @param error 错误原因
 */
typedef void(^ADNetworkLoaderSplashBlock) (ADSplashConfig *currentSplashConfig ,NSError *error);

/**
 网络请求器
 */
@interface ADNetworkLoader : NSObject


/**
 请求服务端配置各页面广告具体数据

 @param page 当前界面
 @param completedBlock 配置数据
 */
- (void)loadAdConfigsWithPage:(ADPage)page completed:(ADNetworkLoaderNativeBlock)completedBlock;

/**
 大全后台开屏数据(开屏广告)
 
 @param completedBlock 开屏广告数据
 */
+ (void)loadSplashAdConfigCompleted:(ADNetworkLoaderSplashBlock)completedBlock;

- (void)cancel;

@end
