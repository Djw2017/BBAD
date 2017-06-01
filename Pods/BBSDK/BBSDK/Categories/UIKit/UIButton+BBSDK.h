//
//  UIButton+BBSDK.h
//  BBSDK
//
//  Created by Dongjw on 17/5/12.
//  Copyright © 2017年 sinyee.babybus. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (BBSDK)

@property (nonatomic, assign) CGFloat fontSize;

/**
 *  设置背景图片
 *  @param normalImage 普通情况图片
 *  @param highlightImage 点击选中时的图片
 */
- (void)setBackground:(UIImage *)normalImage    :(UIImage *)highlightImage;

/**
 *  设置按钮信息
 *  @param image 图片
 *  @param title 文字
 *  @param fontSize 文字大小
 *  @param color 字体颜色
 *  @param stateType 状态
 */
+ (UIButton *)setImage:(UIImage *)image
             withTitle:(NSString *)title
              fontSize:(CGFloat )fontSize
         setTitleColor:(NSString *)color
              forState:(UIControlState)stateType;

/**
 *  设置按钮信息
 *  @param image 图片
 *  @param title 文字
 *  @param fontSize 文字大小
 *  @param color 字体颜色
 *  @param stateType 状态
 */
- (void)setImage:(UIImage *)image
       withTitle:(NSString *)title
        fontSize:(CGFloat )fontSize
   setTitleColor:(NSString *)color
        forState:(UIControlState)stateType;

/**
 *  设置按钮信息
 *  @param image 按钮左图片
 *  @param title 文字
 *  @param fontSize 文字大小
 *  @param color 字体颜色
 *  @param stateType 状态
 */
- (void)setLeftImage:(UIImage *)image
      withRightTitle:(NSString *)title
            fontSize:(CGFloat )fontSize
       setTitleColor:(NSString *)color
            forState:(UIControlState)stateType;

/**
 *  倒计时按钮
 *
 *  @param timeLine 倒计时总时间
 *  @param title    还没倒计时的title
 *  @param subTitle 倒计时中的名字
 *  @param mColor   还没倒计时文字的颜色
 *  @param color    倒计时中的文字颜色
 */
- (void)startWithTime:(NSInteger)timeLine
                title:(NSString *)title
       countDownTitle:(NSString *)subTitle
            mainColor:(UIColor *)mColor
           countColor:(UIColor *)color;


@end
