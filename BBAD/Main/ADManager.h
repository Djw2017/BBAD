//
//  ADManager.h
//  BBAD
//
//  Created by Dongjw on 17/5/11.
//  Copyright © 2017年 sinyee.babybus. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <BBSDK/BBMacros.h>

#import "ADDefine.h"

#import "ADSplashManager.h"

@interface ADManager : NSObject

/// 开屏广告管理中心
@property (nonatomic, strong) ADSplashManager *splashManager;


SingletonH;

- (void)runSplashWith:(NSDictionary *)splash;

@end
