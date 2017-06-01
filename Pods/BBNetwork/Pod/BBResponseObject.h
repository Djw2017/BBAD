//
//  BBResponseObject.h
//  BBNetwork
//
//  Created by Dongjw on 17/5/17.
//  Copyright © 2017年 Babybus. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BBResponseObject : NSObject

@property (nonatomic, copy) NSString *resultMessage;

@property (nonatomic, copy) NSString *resultCode;

@property (nonatomic, strong) NSDictionary *data;

+ (BBResponseObject *)responseObjectWithDictionary:(NSDictionary *)dictionary;

@end
