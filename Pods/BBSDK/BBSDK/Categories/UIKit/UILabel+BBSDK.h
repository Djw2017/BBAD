//
//  UILabel+BBSDK.h
//  BBSDK
//
//  Created by Dongjw on 17/5/12.
//  Copyright © 2017年 sinyee.babybus. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (BBSDK)

+ (UILabel *)setAllocLabelWithText:(NSString *)text FontOfSize:(NSUInteger)fontSize TextColor:(NSString *)hexColor;

/**
 改变行间距

 @param label 对应lable
 @param space 行间距
 */
+ (void)changeLineSpaceForLabel:(UILabel *)label WithSpace:(float)space;


/**
 *  改变字间距
 *  @param label 对应lable
 *  @param space 字间距
 */
+ (void)changeWordSpaceForLabel:(UILabel *)label WithSpace:(float)space;

/**
 *  改变行间距和字间距
 *  @param label 对应lable
 *  @param lineSpace 行间距
 *  @param wordSpace 字间距
 */
+ (void)changeSpaceForLabel:(UILabel *)label withLineSpace:(float)lineSpace WordSpace:(float)wordSpace;

/**
 *  根据行间距确认高度
 *  @param str 字符串
 *  @param font 字体大小
 *  @param width 固定的宽度
 *  @param textlengthSpace 行间距
 */
+(CGFloat)getSpaceLabelHeight:(NSString*)str withFont:(UIFont*)font withWidth:(CGFloat)width  withTextlengthSpace:(NSNumber *)textlengthSpace;

@end
