//
//  UIMarco.h
//  BBSDK
//
//  Created by Dongjw on 17/5/11.
//  Copyright © 2017年 sinyee.babybus. All rights reserved.
//

#ifndef UIMarco_h
#define UIMarco_h

#import <UIKit/UIKit.h>

#import "BBUIUtility.h"

//****************************************** 版本判断  ************************************//

#define IOS_SYSTEM_VERSION   [[[UIDevice currentDevice] systemVersion] floatValue]

#define IOS7_OR_LATER [[[UIDevice currentDevice] systemVersion] intValue] >= 7.0
#define IOS8_OR_LATER [[[UIDevice currentDevice] systemVersion] intValue] >= 8.0
#define IOS9_OR_LATER [[[UIDevice currentDevice] systemVersion] intValue] >= 9.0
#define IOS10_OR_LATER  [[[UIDevice currentDevice] systemVersion] intValue] >= 10.0

#define IOS_IS_7  [[[UIDevice currentDevice] systemVersion] intValue] == 7.0
#define IOS_IS_8  [[[UIDevice currentDevice] systemVersion] intValue] == 8.0
#define IOS_IS_9  [[[UIDevice currentDevice] systemVersion] intValue] == 9.0
#define IOS_IS_10  [[[UIDevice currentDevice] systemVersion] intValue] == 10.0

// 是否高清设备
#define IS_RETINA ([[UIScreen mainScreen] respondsToSelector:@selector(displayLinkWithTarget:selector:)] && ([UIScreen mainScreen].scale == 2.0))

#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)




//*****************************************  设备的 宽高 *************************************************//
#pragma mark - 设备 的 宽高

// 设备全屏高
#define SCREEN_FULL_HEIGHT  [[UIScreen mainScreen] bounds].size.height
// 设备全屏宽
#define SCREEN_FULL_WIDTH [[UIScreen mainScreen] bounds].size.width

//判断iPhone型号
#define IS_BEGORE_IPHONE_5 [[UIScreen mainScreen] bounds].size.height <= 568.0f
#define IS_IPHONE_5 [[UIScreen mainScreen] bounds].size.height == 568.0f
#define IS_IPHONE_6 [[UIScreen mainScreen] bounds].size.height == 667.0f
#define IS_IPHONE_6P [[UIScreen mainScreen] bounds].size.height == 736.0f




//*****************************************  颜色 *************************************************//
#pragma mark - 颜色

#define COLOR_WITH_HEXSTR(color_hexstr)    [BBUIUtility colorWithHexString:color_hexstr]

#define COLOR_WIHT_HEXSTR_ALPHA(color_hexstr,alphaValue)    [BBUIUtility colorWithHexString:color_hexstr withAlpha:alphaValue]

#endif /* UIMarco_h */
