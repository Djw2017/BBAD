//
//  BBADMacro.h
//  BBAD
//
//  Created by Dongjw on 17/5/26.
//  Copyright © 2017年 Babybus. All rights reserved.
//

#ifndef BBADMacro_h
#define BBADMacro_h

#define URL_BASE_USER @"http://papp-api.babybus.co" //用户社区

// 大全后台开屏数据(开屏广告)
#define URL_AD_RECOMMEND [NSString stringWithFormat:@"%@/index.php/api/Daquan/get_open_image/ost/2",URL_BASE_USER]

// 广告布局
#define URL_AD_LAYOUT [NSString stringWithFormat:@"%@/index.php/api/Daquan/get_adview",URL_BASE_USER]

#endif /* BBADMacro_h */
