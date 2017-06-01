//
//  BBNetPictureModel.h
//  BBNetwork
//
//  Created by Dongjw on 17/5/17.
//  Copyright © 2017年 Babybus. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BBNetPictureModel : NSObject

/**
 *  上传的图片的名字
 */
@property (nonatomic, copy) NSString *picName;

/**
 *  上传的图片，当不传picData时，可传入此值使用内部压缩,压缩比0.2
 */
@property (nonatomic, strong, nullable) UIImage *picImage;

/**
 *  上传的二进制文件
 */
@property (nonatomic, strong) NSData *picData;

/**
 *  上传的资源url
 */
@property (nonatomic, copy) NSString *url;

@end

NS_ASSUME_NONNULL_END
