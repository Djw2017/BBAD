//
//  ADNativeConfig.h
//  BBAD
//
//  Created by Dongjw on 17/5/25.
//  Copyright © 2017年 Babybus. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ADDefine.h"

@interface ADNativeConfig : NSObject

///	广告拉取数量
@property (nonatomic, assign) int count;

/// AppKey
@property (nonatomic, copy) NSString *appkey;

/// 广告位id
@property (nonatomic, copy) NSString *placementId;

///	默认广告平台,服务端未请求到广告平台时使用
@property (nonatomic, assign) ADPlatform defaultPlatform;

///	当前广告存在的页面控制器，此值优先于上值，platform
@property (nonatomic, assign) ADPage page;

@end
