//
//  ADNetworkLoader.m
//  BBAD
//
//  Created by Dongjw on 17/5/26.
//  Copyright © 2017年 Babybus. All rights reserved.
//

#import <BBNetwork/BBNetwork.h>
#import "BBADMacro.h"

#import "ADDefine.h"
#import "ADNativeConfig.h"
#import "ADNetworkLoader.h"

#import "ADSplashManager.h"

@interface ADNetworkLoader ()

@property (nonatomic, strong) NSURLSessionDataTask *requestTask;

@end

@implementation ADNetworkLoader

/**
 请求服务端配置各页面广告具体数据
 
 @param page 当前界面
 @param completedBlock 配置数据
 */
- (void)loadAdConfigsWithPage:(ADPage)page completed:(ADNetworkLoaderNativeBlock)completedBlock {
    
    self.requestTask = [BBNetworkManager postURLString:@"http://papp-api.babybus.co/index.php/api/Daquan/home_index" parameters:@{
                                                                                     @"ost": @"2"} success:^(id  _Nonnull responseObject) {
        
//        NSDictionary *ddd = @{@"data": @[@{@"page": @"2",
//                                           @"displayInterval": @"30",
//                                           @"type": @"3",
//                                           @"position": @[@"3", @"5"],
//                                           @"platform": @[@"1",@"4"],
//                                           @"bbadinfo": @[@{@"title": @"宝宝巴士小小新品",
//                                                            @"desc": @"端午节小小新品出炉啦",
//                                                            @"img": @"http://img.bitscn.com/upimg/allimg/c160120/1453262W253120-12J05.jpg"}]
//                                          }
//                                        ]
//                             };
        NSArray *ary = [[NSArray alloc] init];
        for (NSDictionary *dic in responseObject[@"data"]) {
            
            ADNativeConfig *config = [[ADNativeConfig alloc] initWithDic:dic];
            config.page = page;
            ary = [ary arrayByAddingObject:config];
        }
        
        completedBlock(ary,nil);
        
    } failure:^(NSError * _Nonnull error) {
        if (error.code != -999) {
            completedBlock(nil,error);
        }
    }];
}

/**
 请求开屏数据
 
 @param completedBlock 开屏广告数据
 */
+ (void)loadSplashAdConfigCompleted:(ADNetworkLoaderSplashBlock)completedBlock {
    
    NSDictionary *dic = @{@"pos": @"10",
                          @"ost": @"1",
                          @"al": @"350"};
    
    [BBNetworkManager postURLString:URL_AD_RECOMMEND parameters:dic withTimeoutInterval:[ADSplashManager sharedInstance].fetchDelay success:^(id  _Nonnull responseObject) {
        
        NSDictionary *responseDic = (NSDictionary *)responseObject;
        
        [responseDic[@"data"] enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            ADSplashConfig *currentSplashConfig;
            if ([obj isKindOfClass:[NSDictionary class]]) {
                currentSplashConfig = [[ADSplashConfig alloc] initWithDic:obj];
            }else{
                NSError *error = [NSError errorWithDomain:@"Response is not NSDictionary"
                                                     code:KADSplashErrorDataFormatError
                                                 userInfo:nil];
                completedBlock(nil,error);
                return ;
            }
            
            // 时间有效则展示
            BOOL beginIsSmall = [currentSplashConfig.begin_date integerValue]<[responseDic[@"always_time"] integerValue];
            BOOL endIsBig = [currentSplashConfig.end_date integerValue]>[responseDic[@"always_time"] integerValue];
            
            if (beginIsSmall && endIsBig){
                
                completedBlock(currentSplashConfig,nil);
            }else {
                NSError *error = [NSError errorWithDomain:@"(begin_date>always_time)||(end_date<always_time) is not allowed"
                                                     code:KADSplashErrorConditionNotMeet
                                                 userInfo:nil];
                completedBlock(nil,error);
            }
        }];
        
    } failure:^(NSError * _Nonnull error) {
        NSError *selfError = [NSError errorWithDomain:error.domain
                                                 code:KADSplashErrorBBNetworkError
                                             userInfo:nil];
        
        completedBlock(nil,selfError);
    }];

}

- (void)cancel {
    
    if (self.requestTask) {
        [self.requestTask cancel];
    }
}

@end
