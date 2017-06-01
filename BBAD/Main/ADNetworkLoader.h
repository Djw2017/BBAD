//
//  ADNetworkLoader.h
//  BBAD
//
//  Created by Dongjw on 17/5/26.
//  Copyright © 2017年 Babybus. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ADConfig.h"

typedef void(^ADNetworkLoaderCompletedBlock) (NSArray<ADConfig*> *ads ,NSError *error);

/**
 网络请求器
 */
@interface ADNetworkLoader : NSObject


/**
 请求服务端配置各页面广告具体数据

 @param version 当前版本号
 @param completedBlock 配置数据
 */
- (void)loadAdConfigsWithVersion:(NSString *)version completed:(ADNetworkLoaderCompletedBlock)completedBlock;

- (void)cancel;

@end
