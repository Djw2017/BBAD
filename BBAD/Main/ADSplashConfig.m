//
//  ADSplashConfig.m
//  BBAD
//
//  Created by Dongjw on 17/6/1.
//  Copyright © 2017年 Babybus. All rights reserved.
//

#import "ADSplashConfig.h"

@implementation ADSplashConfig

- (instancetype)initWithDic:(NSDictionary *)dic {
    self = [super initWithDic:dic];
    if (self) {
        
//        self.showInterval = [dic[@"position"] intValue];
//        self.isShowADStr = [dic[@"platform"] intValue];
        
        self.begin_date     =   dic[@"begin_date"];
        self.end_date       =   dic[@"end_date"];
        self.platform       =   [dic[@"ad_channel"] intValue];
        
        self.phone_image    =   dic[@"phone_image"];
        self.ipad_image     =   dic[@"ipad_image"];
        self.type           =   dic[@"type"];
        self.url            =   dic[@"url"];
        self.title          =   dic[@"title"];
        self.app_download   =   dic[@"app_download"];
        self.showInterval   =   [dic[@"delay_time"] intValue]/1000;
    }
    return self;
}

@end
