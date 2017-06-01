//
//  BBNetworkDefine.h
//  BBNetwork
//
//  Created by Dongjw on 17/5/17.
//  Copyright © 2017年 Babybus. All rights reserved.
//

#import <Foundation/Foundation.h>

#pragma mark - optionsAttributes
/// 请求超时时间, NSNumber containing integer, default 30s
FOUNDATION_EXPORT NSString * const BBNetworkTimeoutIntervalName;

/// 请求返回类型, NSNumber containing integer, @see BBNetResponseType, default BBNetResponseNSDictionary
FOUNDATION_EXPORT NSString * const BBNetworkResponseTypeName;



/**
 post请求响应指定数据类型
 
 - BBNetResponseNSDictionary: NSDictionary
 - BBNetResponseNSData: NSData
 */
typedef NS_OPTIONS(NSInteger, BBNetResponseType) {
    
    BBNetResponseNSDictionary = 1,
    
    // 只对服务端返回NSData数据时有效
    BBNetResponseNSData = 2,
    // 只对服务端返回NSData数据时有效
    BBNetResponseNSString = 3,
};

@interface BBNetworkDefine : NSObject

@end
