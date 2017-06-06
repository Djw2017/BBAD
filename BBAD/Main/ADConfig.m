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
        
        self.isValid = YES;
        self.page = [dic[@"page"] intValue];
        self.adType = [dic[@"type"] intValue];

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
