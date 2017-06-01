//
//  BBResponseObject.m
//  BBNetwork
//
//  Created by Dongjw on 17/5/17.
//  Copyright © 2017年 Babybus. All rights reserved.
//

#import "BBResponseObject.h"

@implementation BBResponseObject

+ (BBResponseObject *)responseObjectWithDictionary:(NSDictionary *)dictionary {
     
    BBResponseObject *responseObject = [[BBResponseObject alloc] init];
    responseObject.resultCode = [dictionary valueForKey:@"status"];
    responseObject.resultMessage = [dictionary valueForKey:@"info"];
    responseObject.data   = [dictionary objectForKey:@"data"];
    
    return responseObject;
}

@end
