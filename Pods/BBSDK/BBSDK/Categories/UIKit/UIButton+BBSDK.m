//
//  UIButton+BBSDK.m
//  BBSDK
//
//  Created by Dongjw on 17/5/12.
//  Copyright © 2017年 sinyee.babybus. All rights reserved.
//

#import "UIButton+BBSDK.h"

#import "BBUIUtility.h"

@implementation UIButton (BBSDK)

- (CGFloat)fontSize
{
    return self.titleLabel.font.pointSize;
}

- (void)setFontSize:(CGFloat)fontSize
{
    self.titleLabel.font = [UIFont systemFontOfSize:fontSize];
}

- (void)setBackground:(UIImage *)normalImage    :(UIImage *)highlightImage
{
    [self setBackgroundImage:normalImage forState:UIControlStateNormal];
    [self setBackgroundImage:highlightImage forState:UIControlStateHighlighted];
}

- (void)setLeftImage:(UIImage *)image
      withRightTitle:(NSString *)title
            fontSize:(CGFloat )fontSize
       setTitleColor:(NSString *)color
            forState:(UIControlState)stateType {
    
    [self.imageView setContentMode:UIViewContentModeLeft];
    [self setImageEdgeInsets:UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0)];
    [self setImage:image forState:stateType];
    [self.titleLabel setContentMode:UIViewContentModeRight];
    [self setTitleColor:[BBUIUtility colorWithHexString:color] forState:UIControlStateNormal];
    self.titleLabel.font = [UIFont systemFontOfSize:fontSize];
    [self setTitleEdgeInsets:UIEdgeInsetsMake(0.0,5.0, 0.0, 0.0)];
    [self setTitle:title forState:stateType];
}


- (void)setImage:(UIImage *)image
       withTitle:(NSString *)title
        fontSize:(CGFloat )fontSize
   setTitleColor:(NSString *)color
        forState:(UIControlState)stateType {
    
    [self setImage:image forState:stateType];
    if (color != 0) {
        [self setTitleColor:[BBUIUtility colorWithHexString:color] forState:UIControlStateNormal];
    }
    self.titleLabel.font = [UIFont systemFontOfSize:fontSize];
    [self setTitle:title forState:stateType];
}

+ (UIButton *)setImage:(UIImage *)image
             withTitle:(NSString *)title
              fontSize:(CGFloat )fontSize
         setTitleColor:(NSString *)color
              forState:(UIControlState)stateType{
    
    UIButton *button = [[UIButton alloc]init];
    //    [button setImage:image forState:stateType];
    [button setBackgroundImage:image forState:stateType];
    if (color != 0) {
        [button setTitleColor:[BBUIUtility colorWithHexString:color] forState:UIControlStateNormal];
    }
    button.titleLabel.font = [UIFont systemFontOfSize:fontSize];
    [button setTitle:NSLocalizedString(title,nil)  forState:stateType];
    
    return button;
    
}


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
           countColor:(UIColor *)color {
    
    //倒计时时间
    __block NSInteger timeOut = timeLine;
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    //每秒执行一次
    dispatch_source_set_timer(_timer, dispatch_walltime(NULL, 0), 1.0 * NSEC_PER_SEC, 0);
    dispatch_source_set_event_handler(_timer, ^{
        
        //倒计时结束，关闭
        if (timeOut <= 0) {
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                [self setTitleColor:mColor forState:UIControlStateNormal];
                [self setTitle:title forState:UIControlStateNormal];
                self.userInteractionEnabled = YES;
            });
        } else {
            int allTime = (int)timeLine + 1;
            int seconds = timeOut % allTime;
            NSString *timeStr = [NSString stringWithFormat:@"%0.2ds", seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self setTitleColor:color forState:UIControlStateNormal];
                [self setTitle:[NSString stringWithFormat:@"%@%@",subTitle,timeStr] forState:UIControlStateNormal];
                self.userInteractionEnabled = NO;
            });
            timeOut--;
        }
    });
    dispatch_resume(_timer);
}

@end
