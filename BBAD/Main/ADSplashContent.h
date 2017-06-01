//
//  ADSplashContent.h
//  BBAD
//
//  Created by Dongjw on 17/5/24.
//  Copyright © 2017年 Babybus. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ADSplashContent : NSObject

//开屏广告
@property (nonatomic,copy) NSString *phone_image;
@property (nonatomic,copy) NSString *ipad_image;
@property (nonatomic,copy) NSString *type;
@property (nonatomic,copy) NSString *begin_date;
@property (nonatomic,copy) NSString *end_date;
@property (nonatomic,copy) NSString *url;
@property (nonatomic,copy) NSString *title;

- (instancetype)initWithDic:(NSDictionary *)dic;

@end
