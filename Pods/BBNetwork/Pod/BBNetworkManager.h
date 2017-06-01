//
//  BBNetworkManager.h
//  BBNetwork
//
//  Created by Dongjw on 17/5/16.
//  Copyright © 2017年 Babybus. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "BBNetPictureModel.h"

NS_ASSUME_NONNULL_BEGIN

#pragma mark - 请求block
/**
 请求成功Block
 请求不携带 BBNetworkResponseTypeName 参数时，返回 BBResponseObject 类型
 */
typedef void (^ __nullable  responseSuccessBlock)(id responseObject);

/**
 请求失败Block
 */
typedef void (^ __nullable responseFailureBlock)(NSError *error);

#pragma mark - 下载block
/**
 上传或者下载进度Block
 */
typedef void (^ __nullable  progressBlock)(NSProgress *progress);

/**
 下载成功的Blcok
 */
typedef void (^ __nullable  downLoadSuccessBlock)(NSURLResponse *response, NSURL *filePath);

/**
 下载失败的Blcok
 */
typedef void (^ __nullable  downLoadFailureBlock)(NSError *error);

/**
 返回URL的Block

 @param targetPath nil
 @param response nil
 @return 下载地址
 */
typedef NSURL *_Nullable(^ destinationBlock)(NSURL *targetPath, NSURLResponse *response);




@interface BBNetworkManager : NSObject

/// 全局请求超时时间(默认20秒)，单独请求超时请携带参数. @see BBNetworkTimeoutIntervalName
@property (nonatomic, assign) NSTimeInterval timeoutInterval;

+ (instancetype)shareInstance;

/**
 Get请求
 
 @param URLString 请求链接
 @param parameters 请求参数
 @param success 请求成功回调
 @param failure 请求失败回调
 */
+ (NSURLSessionDataTask *)getURLString:(NSString *)URLString
                            parameters:(nullable id)parameters
                               success:(responseSuccessBlock)success
                               failure:(responseFailureBlock)failure;

/**
 POST请求
 
 @param URLString 请求链接
 @param parameters 请求参数
 @param success 请求成功回调
 @param failure 请求失败回调
 @return dataTask
 */
+ (NSURLSessionDataTask *)postURLString:(NSString *)URLString
                             parameters:(nullable id)parameters
                                success:(responseSuccessBlock)success
                                failure:(responseFailureBlock)failure;

/**
 POST请求,携带参数
 
 @param URLString 请求链接
 @param parameters 请求参数
 @param attributesDic 携带参数 @see BBNetworkDefine
 @param success 请求成功回调
 @param failure 请求失败回调
 @return dataTask
 */
+ (NSURLSessionDataTask *)postURLString:(NSString *)URLString
                             parameters:(nullable id)parameters
                      optionsAttributes:(nullable NSDictionary *)attributesDic
                                success:(responseSuccessBlock)success
                                failure:(responseFailureBlock)failure;

/**
 POST请求,直接携带超时时间
 
 @param URLString 请求链接
 @param parameters 请求参数
 @param timeoutInterval 超时时间 @see BBNetworkTimeoutIntervalName
 @param success 请求成功回调
 @param failure 请求失败回调
 @return dataTask
 */
+ (NSURLSessionDataTask *)postURLString:(NSString *)URLString
                             parameters:(nullable id)parameters
                    withTimeoutInterval:(NSTimeInterval)timeoutInterval
                                success:(responseSuccessBlock)success
                                failure:(responseFailureBlock)failure;




#pragma mark - 上传/下载
/**
 *  下载
 *
 *  @param URLString       请求的链接
 *  @param progress        进度的回调
 *  @param destination     返回URL的回调
 *  @param downLoadSuccess 发送成功的回调
 *  @param downLoadFailure         发送失败的回调
 *  @return downloadTask
 */
+ (NSURLSessionDownloadTask *)downLoadWithURL:(NSString *)URLString
                                     progress:(progressBlock)progress
                                  destination:(destinationBlock)destination
                              downLoadSuccess:(downLoadSuccessBlock)downLoadSuccess
                              downLoadfailure:(downLoadFailureBlock)downLoadFailure;

/**
 *  POST图片上传(单张图片)
 *
 *  @param URLString  请求的链接
 *  @param parameters 请求的参数
 *  @param picModle   上传的图片模型
 *  @param progress   进度的回调
 *  @param success    发送成功的回调
 *  @param failure    发送失败的回调
 *  @return dataTask
 */
+ (NSURLSessionDataTask *)postURLString:(NSString *)URLString
                             parameters:(nullable NSDictionary *)parameters
                                 andPic:(BBNetPictureModel *)picModle
                               progress:(progressBlock)progress
                                success:(responseSuccessBlock)success
                                failure:(responseFailureBlock)failure;

/**
 *  POST图片上传(单张图片) ,携带参数
 *
 *  @param URLString  请求的链接
 *  @param parameters 请求的参数
 *  @param attributesDic 携带参数 @see BBNetworkDefine
 *  @param picModle   上传的图片模型
 *  @param progress   进度的回调
 *  @param success    发送成功的回调
 *  @param failure    发送失败的回调
 *  @return dataTask
 */
+ (NSURLSessionDataTask *)postURLString:(NSString *)URLString
                             parameters:(nullable NSDictionary *)parameters
                      optionsAttributes:(nullable NSDictionary *)attributesDic
                                 andPic:(BBNetPictureModel *)picModle
                               progress:(progressBlock)progress
                                success:(responseSuccessBlock)success
                                failure:(responseFailureBlock)failure;

@end

NS_ASSUME_NONNULL_END
