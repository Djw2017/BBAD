//
//  BBNetPictureModel.m
//  BBNetwork
//
//  Created by Dongjw on 17/5/17.
//  Copyright © 2017年 Babybus. All rights reserved.
//

#import "BBNetPictureModel.h"

@implementation BBNetPictureModel

- (NSString *)description {
    return [NSString stringWithFormat:@"<%@ : %p> \n{picName : %@ \n pic : %@ \n}", [self class], self,self.picName, self.picImage];
}

@end
