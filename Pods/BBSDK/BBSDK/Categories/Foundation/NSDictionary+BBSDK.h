//
//  NSDictionary+BBSDK.h
//  BBSDK
//
//  Created by Dongjw on 17/5/12.
//  Copyright © 2017年 sinyee.babybus. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (BBSDK)

#pragma mark - Safe
/**
 *  获取字典关键字值
 *  @param key 关键字
 */
-(id)safeObjectForKey:(NSString*) key;

/**
 *  转换成可变字典
 */
-(NSMutableDictionary *)mutableDeepCopy;

@end
