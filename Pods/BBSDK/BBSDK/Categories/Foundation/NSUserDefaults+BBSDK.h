//
//  NSUserDefaults+BBSDK.h
//  BBSDK
//
//  Created by Dongjw on 17/5/12.
//  Copyright © 2017年 sinyee.babybus. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSUserDefaults (BBSDK)

#pragma mark - Helpers
/** convenience method to save a given object for a given key
 *  NSUserDefaults存储
 *  @param object 要存储的内容
 *  @param key 关键字
 */
+ (void)saveObject:(id)object forKey:(NSString *)key;

/** convenience method to return an object for a given key
 *  获取NSUserDefaults关键字内容
 *  @param key 关键字
 */
+ (id)retrieveObjectForKey:(NSString *)key;

/** convenience method to delete a value for a given key
 *  删除NSUserDefaults关键字内容
 *  @param key 关键字
 */
+ (void)deleteObjectForKey:(NSString *)key;

/**
 *  NSUserDefaults存储bool
 *  @param object bool值
 *  @param key 关键字
 */
+ (void)saveBool:(BOOL)object forkey:(NSString *)key;

/**
 *  获取NSUserDefaults关键字bool值
 *  @param key 关键字
 */
+ (BOOL)retrieveBoolForKey:(NSString *)key;

/**
 *  NSUserDefaults存储NSInteger
 *  @param num NSInteger值
 *  @param key 关键字
 */
+ (void)saveInteger:(NSInteger)num forkey:(NSString *)key;

/**
 *  获取NSUserDefaults关键字NSInteger值
 *  @param key 关键字
 */
+ (NSInteger)retrieveIntegerForKey:(NSString *)key;

@end
