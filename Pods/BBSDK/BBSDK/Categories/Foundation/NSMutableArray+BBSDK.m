//
//  NSMutableArray+BBSDK.m
//  BBSDK
//
//  Created by Dongjw on 17/5/12.
//  Copyright © 2017年 sinyee.babybus. All rights reserved.
//

#import "NSMutableArray+BBSDK.h"

@implementation NSMutableArray (BBSDK)

#pragma mark - Safe
- (void)safeRemoveObjectAtIndex:(NSUInteger)index
{
    if (index < self.count) {
        [self removeObjectAtIndex:index];
    }
}

@end
