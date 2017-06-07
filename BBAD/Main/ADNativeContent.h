//
//  ADNativeContent.h
//  BBAD
//
//  Created by Dongjw on 17/5/25.
//  Copyright © 2017年 Babybus. All rights reserved.
//

#import "ADDefine.h"

NS_ASSUME_NONNULL_BEGIN

@interface ADNativeContent : NSObject

/// 广告标题
@property (nonatomic, copy) NSString *title;

/// 广告描述
@property (nullable, nonatomic, copy) NSString *describe;

/// 广告行为地址
@property (nullable, nonatomic, copy) NSString *loadingUrl;

/// 广告行为类型
@property (nullable, nonatomic, copy)  NSString *actionType;

/// 广告图片url
@property (nullable, nonatomic, copy) NSString *imageUrl;

/// 广告子分类 @see ADNativeConfig
@property (nonatomic, assign) int child_page;

/// 广告主 @see ADPlatform
@property (nonatomic, assign) ADPlatform platform;

/// 原始数据
@property (nonatomic, strong) id nativeOriginalData;


@end

NS_ASSUME_NONNULL_END
