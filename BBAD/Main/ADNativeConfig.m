//
//  ADNativeConfig.m
//  BBAD
//
//  Created by Dongjw on 17/5/25.
//  Copyright © 2017年 Babybus. All rights reserved.
//

#import "ADNativeConfig.h"

@implementation ADNativeConfig

- (instancetype)initWithDic:(NSDictionary *)dic {
    self = [super initWithDic:dic];
    if (self) {
        
        // 显示位置
        self.adPosition     = dic[@"pos"];
        
        // 广告平台
        self.platform       = [dic[@"ad_channel"] intValue];
                
        self.child_page     = dic[@"child_page"];
        
        // 宝宝巴士原生广告
        self.bbadInfoAry    = dic[@"bbadinfo"];
    }
    return self;

}

@end
