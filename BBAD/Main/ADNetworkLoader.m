//
//  ADNetworkLoader.m
//  BBAD
//
//  Created by Dongjw on 17/5/26.
//  Copyright © 2017年 Babybus. All rights reserved.
//

#import <BBNetwork/BBNetwork.h>
#import "BBADMacro.h"

#import "ADNetworkLoader.h"

@interface ADNetworkLoader ()

@property (nonatomic, strong) NSURLSessionDataTask *requestTask;

@end

@implementation ADNetworkLoader

/**
 请求服务端配置各页面广告具体数据
 
 @param version 当前版本号
 @param completedBlock 配置数据
 */
- (void)loadAdConfigsWithVersion:(NSString *)version completed:(ADNetworkLoaderCompletedBlock)completedBlock {
    
    self.requestTask = [BBNetworkManager postURLString:URL_AD_LAYOUT parameters:@{@"pos": @"2",@"al": @"346", @"ost": @"1"} success:^(id  _Nonnull responseObject) {
        
        NSDictionary *ddd = @{@"data": @[@{@"page": @"2",
                                           @"displayInterval": @"30",
                                           @"type": @"3",
                                           @"position": @[@"3", @"5"],
                                           @"platform": @[@"1",@"4"],
                                           @"bbadinfo": @[@{@"title": @"宝宝巴士小小新品",
                                                            @"desc": @"端午节小小新品出炉啦",
                                                            @"img": @"http://img.bitscn.com/upimg/allimg/c160120/1453262W253120-12J05.jpg"}]
                                          }
                                        ]
                             };
        NSArray *ary = [[NSArray alloc] init];
        for (NSDictionary *dic in ddd[@"data"]) {
            ADConfig *config = [[ADConfig alloc] initWithDic:dic];
            ary = [ary arrayByAddingObject:config];
        }
        
        completedBlock(ary,nil);
        
    } failure:^(NSError * _Nonnull error) {
        completedBlock(nil,error);
    }];
}

- (void)cancel {
    
    if (self.requestTask) {
        [self.requestTask cancel];
    }
}

@end
