//
//  NSMutableArray+BBSDK.h
//  BBSDK
//
//  Created by Dongjw on 17/5/12.
//  Copyright © 2017年 sinyee.babybus. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableArray (BBSDK)

#pragma mark - Safe
/**
 *  删除数组某一位置的值
 *  @param index 数组位置
 */
- (void)safeRemoveObjectAtIndex:(NSUInteger)index;

@end
