//
//  ADConfig.m
//  BBAD
//
//  Created by Dongjw on 17/5/26.
//  Copyright © 2017年 Babybus. All rights reserved.
//

#import "ADConfig.h"

@implementation ADConfig

- (instancetype)initWithDic:(NSDictionary *)dic {
    
    if (self = [super init]) {
        
        self.page = [dic[@"page"] intValue];
        self.displayInterval = [dic[@"displayInterval"] intValue];
        self.isValid = YES;
        self.adType = [dic[@"type"] intValue];
        self.adPosition = dic[@"position"];
        self.adPlatformAry = dic[@"platform"];
        self.bbadInfoAry = dic[@"bbadinfo"];
    }
    return self;
}

//- (NSString *)debugDescription {
//    
//    NSMutableString *description = [NSMutableString stringWithFormat:@"\n#[%@] ID(%@) PlaceId(%@) DisplayInterval(%@) LaunchInterval(%@) IsValid(%@)", ADKAdTypeString(self.adType), @(self.adId), @(self.placeId), @(self.displayInterval), @(self.launchInterval), @(self.isValid)];
//    
//    [self.adPlatformAry enumerateObjectsUsingBlock:^(ADKUnionAd *unionAd, NSUInteger idx, BOOL * _Nonnull stop) {
//        [description appendFormat:@"\n       %@", [unionAd debugDescription]];
//    }];
//    
//    [description appendString:@"\n"];
//    
//    return description;
//}

@end
