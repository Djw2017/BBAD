//
//  ADSplashContent.m
//  BBAD
//
//  Created by Dongjw on 17/5/24.
//  Copyright © 2017年 Babybus. All rights reserved.
//

#import "ADSplashContent.h"

@implementation ADSplashContent

- (instancetype)initWithDic:(NSDictionary *)dic {
    self = [super init];
    if (self) {
        self.phone_image = dic[@"phone_image"];
        self.ipad_image = dic[@"ipad_image"];
        self.type = dic[@"type"];
        self.begin_date = dic[@"begin_date"];
        self.end_date = dic[@"end_date"];
        self.url = dic[@"url"];
        self.title = dic[@"title"];
    }
    return  self;
}

@end
