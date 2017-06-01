//
//  ADNativeContent.h
//  BBAD
//
//  Created by Dongjw on 17/5/25.
//  Copyright © 2017年 Babybus. All rights reserved.
//

#import <Foundation/Foundation.h>

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

/// 广告尺寸 width
@property (nonatomic, assign) NSInteger width;

/// 广告尺寸 height
@property (nonatomic, assign) NSInteger height;

/// 广告 展弦比
@property (nonatomic, assign) float aspectRatio;

/// 原始数据
@property (nonatomic, strong) id nativeOriginalData;


@end

NS_ASSUME_NONNULL_END
