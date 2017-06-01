//
//  BBNetworkDefine.m
//  BBNetwork
//
//  Created by Dongjw on 17/5/17.
//  Copyright © 2017年 Babybus. All rights reserved.
//

#import "BBNetworkDefine.h"

@implementation BBNetworkDefine

/// 请求超时时间, NSNumber containing integer, default 30s
NSString * const BBNetworkTimeoutIntervalName = @"BBNetworkTimeoutIntervalName";

/// 请求返回类型, NSNumber containing integer, @see BBNetResponseType, default BBNetResponseNSDictionary
NSString * const BBNetworkResponseTypeName = @"BBNetworkResponseTypeName";

@end
