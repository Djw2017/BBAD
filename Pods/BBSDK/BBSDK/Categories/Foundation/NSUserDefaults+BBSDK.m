//
//  NSUserDefaults+BBSDK.m
//  BBSDK
//
//  Created by Dongjw on 17/5/12.
//  Copyright © 2017年 sinyee.babybus. All rights reserved.
//

#import "NSUserDefaults+BBSDK.h"

@implementation NSUserDefaults (BBSDK)

#pragma mark - Helpers
/* convenience method to save a given string for a given key */
+ (void)saveObject:(id)object forKey:(NSString *)key
{
    NSUserDefaults *defaults = [self standardUserDefaults];
    [defaults setObject:object forKey:key];
    [defaults synchronize];
}


+ (void)saveBool:(BOOL)object forkey:(NSString *)key
{
    NSUserDefaults *defaults = [self standardUserDefaults];
    [defaults setBool:object forKey:key];
    [defaults synchronize];
    
}


+ (BOOL)retrieveBoolForKey:(NSString *)key
{
    return [[self standardUserDefaults] boolForKey:key];
}

/* convenience method to return a string for a given key */
+ (id)retrieveObjectForKey:(NSString *)key
{
    return [[self standardUserDefaults] objectForKey:key];
}

/* convenience method to delete a value for a given key */
+ (void)deleteObjectForKey:(NSString *)key
{
    NSUserDefaults *defaults = [self standardUserDefaults];
    [defaults removeObjectForKey:key];
    [defaults synchronize];
}

+ (void)saveInteger:(NSInteger)num forkey:(NSString *)key{
    
    NSUserDefaults *defaults = [self standardUserDefaults];
    [defaults setInteger:num forKey:key];
    [defaults synchronize];
}

+ (NSInteger)retrieveIntegerForKey:(NSString *)key{
    
    return [[self standardUserDefaults] integerForKey:key];
}

@end
