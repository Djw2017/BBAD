//
//  BBSystemUtility.m
//  BBSDK
//
//  Created by Dongjw on 17/5/12.
//  Copyright © 2017年 sinyee.babybus. All rights reserved.
//

#import <sys/utsname.h>

#import "NSArray+BBSDK.h"

#import "BBSystemUtility.h"

@implementation BBSystemUtility

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"

#pragma mark - Device
/**
 获取设备总容量
 
 @return 设备总容量
 */
+ (float)totalDiskSpace
{
    NSDictionary *fattributes = [[NSFileManager defaultManager] attributesOfFileSystemForPath:NSHomeDirectory() error:nil];
    float total=[[fattributes objectForKey:NSFileSystemSize] floatValue];
    float totalSpace=total/(1024.0*1024*1024);
    return totalSpace;
}

/**
 获取设备可用容量
 
 @return 设备可用容量
 */
+ (float)freeDiskSpace
{
    NSDictionary *fattributes = [[NSFileManager defaultManager] attributesOfFileSystemForPath:NSHomeDirectory() error:nil];
    float free=[[fattributes objectForKey:NSFileSystemFreeSize] floatValue];
    float freeSpace=free/(1024.0*1024*1024);
    return freeSpace;
}

/**
 获取设备型号
 
 @return 设备型号
 */
+ (NSString *)devicePlatForm{
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *platform = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    
    //iPhone
    if ([platform isEqualToString:@"iPhone3,1"]||[platform isEqualToString:@"iPhone3,2"]||[platform isEqualToString:@"iPhone3,3"]) {
        return @"iPhone 4";
    } else if ([platform isEqualToString:@"iPhone4,1"]) {
        return @"iPhone 4S";
    } else if ([platform isEqualToString:@"iPhone5,1"]||[platform isEqualToString:@"iPhone5,2"]) {
        return @"iPhone 5";
    } else if ([platform isEqualToString:@"iPhone5,3"]||[platform isEqualToString:@"iPhone5,4"]) {
        return @"iPhone 5c";
    } else if ([platform isEqualToString:@"iPhone6,1"]||[platform isEqualToString:@"iPhone6,2"]) {
        return @"iPhone 5s";
    } else if ([platform isEqualToString:@"iPhone7,1"]) {
        return @"iPhone 6 Plus";
    } else if ([platform isEqualToString:@"iPhone7,2"]) {
        return @"iPhone 6";
    } else if ([platform isEqualToString:@"iPhone8,1"]) {
        return @"iPhone 6s";
    } else if ([platform isEqualToString:@"iPhone8,2"]) {
        return @"iPhone 6s Plus";
    } else if ([platform isEqualToString:@"iPhone8,4"]) {
        return @"iPhone SE";
    } else if ([platform isEqualToString:@"iPhone9,1"]) {
        return @"iPhone 7";
    } else if ([platform isEqualToString:@"iPhone9,2"]) {
        return @"iPhone 7 Plus";
    }
    
    
    //iPod
    else if ([platform isEqualToString:@"iPod1,1"]||[platform isEqualToString:@"iPod2,1"]||[platform isEqualToString:@"iPod3,1"]||[platform isEqualToString:@"iPod4,1"]||[platform isEqualToString:@"iPod5,1"]||[platform isEqualToString:@"iPod7,1"]) {
        return @"iPod Touch";
    }
    
    
    //iPad
    else if ([platform isEqualToString:@"iPad1,1"]) {
        return @"iPad 1";
    } else if ([platform isEqualToString:@"iPad2,1"]||[platform isEqualToString:@"iPad2,2"]||[platform isEqualToString:@"iPad2,3"]||[platform isEqualToString:@"iPad2,4"]) {
        return @"iPad 2";
    } else if ([platform isEqualToString:@"iPad3,1"]||[platform isEqualToString:@"iPad3,2"]||[platform isEqualToString:@"iPad3,3"]) {
        return @"iPad 3";
    } else if ([platform isEqualToString:@"iPad3,4"]||[platform isEqualToString:@"iPad3,5"]||[platform isEqualToString:@"iPad3,6"]) {
        return @"iPad 4";
    } else if ([platform isEqualToString:@"iPad4,1"]||[platform isEqualToString:@"iPad4,2"]||[platform isEqualToString:@"iPad4,3"]) {
        return @"iPad Air 1";
    } else if ([platform isEqualToString:@"iPad5,3"]||[platform isEqualToString:@"iPad5,4"]) {
        return @"iPad Air 2";
    } else if ([platform isEqualToString:@"iPad6,7"]||[platform isEqualToString:@"iPad6,8"]||[platform isEqualToString:@"iPad6,3"]||[platform isEqualToString:@"iPad6,4"]) {
        return @"iPad Pro";
    }
    
    else if ([platform isEqualToString:@"iPad2,5"]||[platform isEqualToString:@"iPad2,6"]||[platform isEqualToString:@"iPad2,7"]) {
        return @"iPad Mini 1";
    } else if ([platform isEqualToString:@"iPad4,4"]||[platform isEqualToString:@"iPad4,5"]||[platform isEqualToString:@"iPad4,6"]) {
        return @"iPad mini 2";
    } else if ([platform isEqualToString:@"iPad4,7"]||[platform isEqualToString:@"iPad4,8"]||[platform isEqualToString:@"iPad4,9"]) {
        return @"iPad mini 3";
    } else if ([platform isEqualToString:@"iPad5,1"]||[platform isEqualToString:@"iPad5,2"]) {
        return @"iPad mini 4";
    }
    
    //Watch
    else if ([platform isEqualToString:@"Watch1,1"]||[platform isEqualToString:@"Watch1,2"]) {
        return @"Apple Watch";
    }
    else if ([platform isEqualToString:@"i386"]) {
        return @"iPhone Simulator";
    } else if ([platform isEqualToString:@"x86_64"]) {
        return @"iPad Simulator";
    }
    
    
    return platform;
}


/**
 获取当前语言
 
 @return 当前语言
 */
+ (NSString*)getPreferredLanguage {
    
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    
    NSArray * allLanguages = [defaults objectForKey:@"AppleLanguages"];
    
    NSString *preferredLang = [allLanguages safeObjectAtIndex:0];
    
    //NSLog(@"当前语言:%@", preferredLang);
    NSRange range = [preferredLang rangeOfString:@"zh-Hant" options:NSCaseInsensitiveSearch];
    if([preferredLang isEqualToString:@"en-US"]){
        preferredLang = @"zh";
    }else if(range.length > 0){
        preferredLang = @"zh";
    }else{
        preferredLang = @"zh";
    }
    
    return preferredLang;
}




#pragma mark - time
//年
+(NSString *)getCurrentYear {
    NSDate *currentDate = [NSDate date];
    NSDateFormatter *dateformatterY = [[NSDateFormatter alloc] init];
    [dateformatterY setDateFormat:@"YYYY"];
    return [dateformatterY stringFromDate:currentDate];//当前年份
}
//月
+(NSString *)getCurrentMonth {
    NSDate *currentDate = [NSDate date];
    NSDateFormatter *dateformatterM = [[NSDateFormatter alloc] init];
    [dateformatterM setDateFormat:@"MM"];
    return [dateformatterM stringFromDate:currentDate];//当前月份
}
//日
+(NSString *)getCurrentDay {
    NSDate *currentDate = [NSDate date];
    NSDateFormatter *dateformatterD = [[NSDateFormatter alloc] init];
    [dateformatterD setDateFormat:@"dd"];
    return [dateformatterD stringFromDate:currentDate];
}

//时
+(NSString *)getCurrentTime {
    NSDate *currentDate = [NSDate date];
    NSDateFormatter *dateformatterD = [[NSDateFormatter alloc] init];
    [dateformatterD setDateFormat:@"hh"];
    return [dateformatterD stringFromDate:currentDate];
}

//时
+(NSString *)getCurrentMinute {
    NSDate *currentDate = [NSDate date];
    NSDateFormatter *dateformatterD = [[NSDateFormatter alloc] init];
    [dateformatterD setDateFormat:@"mm"];
    return [dateformatterD stringFromDate:currentDate];
}

//秒
+(NSString *)getCurrentSecond {
    NSDate *currentDate = [NSDate date];
    NSDateFormatter *dateformatterD = [[NSDateFormatter alloc] init];
    [dateformatterD setDateFormat:@"ss"];
    return [dateformatterD stringFromDate:currentDate];
}

+(NSString *)getCurrentDate:(NSString *)format{
    NSDate *currentDate = [NSDate date];
    NSDateFormatter *dateformatterD = [[NSDateFormatter alloc] init];
    [dateformatterD setDateFormat:format];
    return [dateformatterD stringFromDate:currentDate];
}

//当前时间戳
+ (NSString *)timestamp{
    
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a=[dat timeIntervalSince1970];
    return [NSString stringWithFormat:@"%f", a];
}

/**
 是否是圣诞节

 @return 是圣诞节
 */
+ (BOOL)isChristmas{
    NSDate *now = [NSDate date];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger unitFlags = NSMonthCalendarUnit | NSDayCalendarUnit;
    NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:now];
    
    NSInteger month = [dateComponent month];
    NSInteger day = [dateComponent day];
    
    if (month == 12) {
        if (day>=22 && day<=27) {
            return YES;
        }
    }
    
    return NO;
}

/**
 是否是新年

 @return 是新年
 */
+ (BOOL)isNewYear{
    NSDate *now = [NSDate date];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger unitFlags = NSMonthCalendarUnit | NSDayCalendarUnit;
    NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:now];
    
    NSInteger month = [dateComponent month];
    NSInteger day = [dateComponent day];
    
    if (month == 12) {
        if (day==31) {
            return YES;
        }
    }
    if (month == 2) {
        if (day>=7 && day<=8) {
            return YES;
        }
    }
    return NO;
}



#pragma mark - App
+ (NSString *)currentVersion {
    NSString *verStr=[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    NSString *version = [verStr stringByReplacingOccurrencesOfString:@"." withString:@""];
    return version;
}

// 判断用户是否打开通知开关
+ (BOOL)isUIRemoteNotificationTypeNone {
    if (!([[[UIDevice currentDevice] systemVersion] intValue] == 7.0)) { //iOS8以上包含iOS8
        if ([[UIApplication sharedApplication] currentUserNotificationSettings].types  == UIUserNotificationTypeNone) { //判断用户是否打开通知开关
            return YES;
        }else {
            return NO;
        }
    }else{ // ios7 一下
        UIRemoteNotificationType type = [[UIApplication sharedApplication] enabledRemoteNotificationTypes];
        if (type  == UIRemoteNotificationTypeNone) { //判断用户是否打开通知开关
            return YES;
        }else {
            return NO;
        }
    }
}

@end

#pragma clang diagnostic pop
