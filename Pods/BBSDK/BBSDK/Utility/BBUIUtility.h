//
//  BBUIUtility.h
//  BBSDK
//
//  Created by Dongjw on 17/5/12.
//  Copyright © 2017年 sinyee.babybus. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface BBUIUtility : NSObject

/**
 根据rootViewController获取最上层视图

 @param rootViewController <#rootViewController description#>
 @return <#return value description#>
 */
+ (UIViewController *)topViewControllerWithRootViewController:(UIViewController*)rootViewController;

/**
 获取最上层的视图

 @return <#return value description#>
 */
+ (UIView *)topView;

/**
 获取最上层的视图控制器
 如果视图层次中，包含presentController，则递归获取最上层的presentController

 @return <#return value description#>
 */
+ (UIViewController *)topViewController;

/**
 获取最上层的视图导航控制器
 如果视图层次中，包含presentController，则递归获取最上层的presentController

 @return <#return value description#>
 */
+ (UINavigationController *)topNavigationController;

/**
 *	@brief	获取根视图
 *
 *  @since  ver 1.0
 *
 */
+ (UIWindow *)window;

/**
 *	@brief	获取根视图
 *
 *  @since  ver 1.0
 *
 */
+ (UIView *)rootView;

/**
 *	@brief	获取根视图控制器
 *
 *  @since  ver 1.0
 *
 */
+ (UIViewController *)getCurrentVC;


///-----------------------------------------
/// @name Orientation
///-----------------------------------------

+ (NSArray *)supportOrientations;
+ (BOOL)isSupportOrientation:(UIInterfaceOrientation)orientation;
+ (NSString *)stringWithOrientation:(UIInterfaceOrientation)orientation;
+ (BOOL)isSupportPortraitOrientation;
+ (BOOL)isSupportLandscapeOrientation;




//*****************************************  颜色 *************************************************//
#pragma mark - 颜色
/**
 *  根据颜色返回图片
 *
 *  @param color 颜色
 *
 *  @return 图片
 */
+ (UIImage*)imageWithColor:(UIColor*)color;

/**
 *  根据颜色返回图片
 *
 *  @param color 十六进制颜色
 *
 *  @return 图片
 */
+ (UIView *)getCellBottomLineViewWithColor:(NSString *)color;


/**
 字符串16进制颜色转化真正颜色

 @param hexString 888888
 @return 对应UIColor
 */
+ (UIColor *)colorWithHexString:(NSString *)hexString;
+ (UIColor *)colorWithHexString:(NSString *)hexString withAlpha:(float)alpha;


//*****************************************  图片 *************************************************//
#pragma mark - 图片
//图片自定义长宽
+ (UIImage *)reSizeImage:(UIImage *)image toSize:(CGSize)reSize;

+ (UIImage *)imageiPhoneOriPadWithName:(NSString *)name;

/**
 图片等比例缩小
 
 @param image <#image description#>
 @param size <#size description#>
 @return <#return value description#>
 */
+ (UIImage *)OriginImage:(UIImage *)image scaleToSize:(CGSize)size;

+ (UIImage *)thumbnailWithImageWithoutScale:(UIImage *)image size:(CGSize)asize;

@end
