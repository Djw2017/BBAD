//
//  NSArray+BBSDK.h
//  BBSDK
//
//  Created by Dongjw on 17/5/11.
//  Copyright © 2017年 sinyee.babybus. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (BBSDK)

#pragma mark - Safe
/**
 在不超出数组个数的的情况下返回vlaue

 @param index 数组中第N个
 @return 超出则返回Nil
 */
- (id)safeObjectAtIndex:(NSUInteger)index;

@end
