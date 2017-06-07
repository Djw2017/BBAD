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
              
        self.phone_image    =   dic[@"phone_image"];
        self.ipad_image     =   dic[@"ipad_image"];
        self.url            =   dic[@"url"];
        self.showInterval   =   [dic[@"delay_time"] intValue]/1000;
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder {

    [coder encodeBool:self.isValid          forKey:@"isValid"];
    [coder encodeObject:self.title          forKey:@"title"];
    [coder encodeInt:self.platform          forKey:@"platform"];
    [coder encodeObject:self.type           forKey:@"type"];
    
    [coder encodeObject:self.error          forKey:@"error"];
    [coder encodeInt:self.showInterval      forKey:@"showInterval"];
    [coder encodeObject:self.phone_image    forKey:@"phone_image"];
    [coder encodeObject:self.ipad_image     forKey:@"ipad_image"];
    [coder encodeObject:self.url            forKey:@"url"];

}

- (nullable instancetype)initWithCoder:(NSCoder *)decoder {
    if (self = [super init]) {
      
        self.isValid        =   [decoder decodeBoolForKey:@"isValid"];
        self.title          =   [decoder decodeObjectForKey:@"title"];
        self.platform       =   [decoder decodeIntForKey:@"platform"];
        self.type           =   [decoder decodeObjectForKey:@"type"];
        
        
        self.error          =   [decoder decodeObjectForKey:@"error"];
        self.showInterval   =   [decoder decodeIntForKey:@"showInterval"];
        self.phone_image    =   [decoder decodeObjectForKey:@"phone_image"];
        self.ipad_image     =   [decoder decodeObjectForKey:@"ipad_image"];
        self.url            =   [decoder decodeObjectForKey:@"url"];
        
    }
    return self;
}

@end
