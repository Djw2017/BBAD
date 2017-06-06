//
//  BBADMacro.h
//  BBAD
//
//  Created by Dongjw on 17/5/26.
//  Copyright © 2017年 Babybus. All rights reserved.
//

#ifndef BBADMacro_h
#define BBADMacro_h

// 广告请求开屏pos参数
#define PosParameterSplash   @"10"

//#define PosParameterSplash   @"10"


#define URL_BASE_USER @"http://papp-api.babybus.co" //用户社区

// 广告
#define URL_AD_RECOMMEND [NSString stringWithFormat:@"%@/index.php/api/Daquan/get_adview",URL_BASE_USER]

// 广告布局
#define URL_AD_LAYOUT [NSString stringWithFormat:@"%@/index.php/api/Daquan/get_adview",URL_BASE_USER]

#endif /* BBADMacro_h */
