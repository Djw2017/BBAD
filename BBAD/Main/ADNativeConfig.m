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
        
        self.adPosition = dic[@"position"];
        self.adPlatformAry = dic[@"platform"];
        self.bbadInfoAry = dic[@"bbadinfo"];
    }
    return self;

}

@end
