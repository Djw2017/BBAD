//
//  BBNetworkManager.m
//  BBNetwork
//
//  Created by Dongjw on 17/5/16.
//  Copyright © 2017年 Babybus. All rights reserved.
//

#import "AFNetworking.h"

#import "BBNetworkDefine.h"
#import "BBNetworkManager.h"
#import "BBResponseObject.h"

@implementation BBNetworkManager

+ (instancetype)shareInstance {
    static BBNetworkManager *shareInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareInstance = [[self alloc] init];
        shareInstance.timeoutInterval = 20;
    });
    
    return shareInstance;
}


#pragma mark - 请求
/**
 Get请求
 
 @param URLString 请求链接
 @param parameters 请求参数
 @param success 请求成功回调
 @param failure 请求失败回调
 */
+ (NSURLSessionDataTask *)getURLString:(NSString *)URLString
                            parameters:(id)parameters
                               success:(responseSuccessBlock)success
                               failure:(responseFailureBlock)failure {
    
    return  [self getURLString:URLString parameters:parameters optionsAttributes:nil success:success failure:failure];
}

/**
 Get请求,携带参数
 
 @param URLString 请求链接
 @param parameters 请求参数
 @param attributesDic 携带参数 @see BBNetworkDefine
 @param success 请求成功回调
 @param failure 请求失败回调
 @return dataTask
 */
+ (NSURLSessionDataTask *)getURLString:(NSString *)URLString
                            parameters:(nullable id)parameters
                     optionsAttributes:(nullable NSDictionary *)attributesDic
                               success:(responseSuccessBlock)success
                               failure:(responseFailureBlock)failure {
    
    // 设置超时时间
    NSNumber *timeoutIntervalNumber = attributesDic[BBNetworkTimeoutIntervalName];
    NSTimeInterval timeoutInterval = timeoutIntervalNumber ? timeoutIntervalNumber.integerValue : [[self shareInstance] timeoutInterval];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer.timeoutInterval = timeoutInterval;
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    NSURLSessionDataTask * dataTask = [manager GET:URLString parameters:parameters progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
                                               
       if (success) {
           // 处理数据
           [self successHandle:responseObject withSuccess:success withfailure:failure withAttributes:attributesDic];
       }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
       
       if (failure) {
           failure(error);
       }
    }];
    
    return dataTask;
}

/**
 Get请求,直接携带超时时间
 
 @param URLString 请求链接
 @param parameters 请求参数
 @param timeoutInterval 超时时间 @see BBNetworkTimeoutIntervalName
 @param success 请求成功回调
 @param failure 请求失败回调
 @return dataTask
 */
+ (NSURLSessionDataTask *)getURLString:(NSString *)URLString
                            parameters:(nullable id)parameters
                   withTimeoutInterval:(NSTimeInterval)timeoutInterval
                               success:(responseSuccessBlock)success
                               failure:(responseFailureBlock)failure {
    return  [self getURLString:URLString
                     parameters:parameters
              optionsAttributes:@{BBNetworkTimeoutIntervalName: [NSNumber numberWithInteger:timeoutInterval]}
                        success:success
                        failure:failure];
}

/**
 POST请求
 
 @param URLString 请求链接
 @param parameters 请求参数
 @param success 请求成功回调
 @param failure 请求失败回调
 @return dataTask
 */
+ (NSURLSessionDataTask *)postURLString:(NSString *)URLString
           parameters:(id)parameters
              success:(responseSuccessBlock)success
              failure:(responseFailureBlock)failure {
    
    return  [self postURLString:URLString parameters:parameters optionsAttributes:nil success:success failure:failure];
}

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
                             parameters:(id)parameters
                      optionsAttributes:(NSDictionary *)attributesDic 
                                success:(responseSuccessBlock)success
                                failure:(responseFailureBlock)failure {

    // 设置超时时间
    NSNumber *timeoutIntervalNumber = attributesDic[BBNetworkTimeoutIntervalName];
    NSTimeInterval timeoutInterval = timeoutIntervalNumber ? timeoutIntervalNumber.integerValue : [[self shareInstance] timeoutInterval];

    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer.timeoutInterval = timeoutInterval;
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    NSURLSessionDataTask * dataTask = [manager POST:URLString parameters:parameters progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
                                                
        if (success)
        {
            // 处理数据
            [self successHandle:responseObject withSuccess:success withfailure:failure withAttributes:attributesDic];
        }
        
            
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
        if (failure)
        {
            failure(error);
        }
        
    }];

    return dataTask;
}

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
                                failure:(responseFailureBlock)failure {
    
    return  [self postURLString:URLString
                     parameters:parameters
              optionsAttributes:@{BBNetworkTimeoutIntervalName: [NSNumber numberWithInteger:timeoutInterval]}
                        success:success
                        failure:failure];
}




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
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    NSURL *url = [NSURL URLWithString:URLString];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    // 下载任务
    NSURLSessionDownloadTask *task = [manager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
        
        if (progress)
        {
            progress(downloadProgress);
        }
        
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        
        if (destination)
        {
            return destination(targetPath, response);
        }
        else
        {
            return nil;
        }
        
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        
        if (error)
        {
            downLoadFailure(error);
        }
        else
        {
            downLoadSuccess(response, filePath);
        }
    }];
    
    // 开始启动任务
    [task resume];
    
    return task;
}

/**
 *  POST图片上传(单张图片)
 *
 *  @param URLString  请求的链接
 *  @param parameters 请求的参数
 *  @param picModle   上传的图片模型
 *  @param progress   进度的回调
 *  @param success    发送成功的回调
 *  @param failure    发送失败的回调
 */
+ (NSURLSessionDataTask *)postURLString:(NSString *)URLString
                             parameters:(NSDictionary *)parameters
                                 andPic:(BBNetPictureModel *)picModle
                               progress:(progressBlock)progress
                                success:(responseSuccessBlock)success
                                failure:(responseFailureBlock)failure {
    
    return [self postURLString:URLString parameters:parameters  optionsAttributes:nil andPic:picModle progress:progress success:success failure:failure];
}

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
                                failure:(responseFailureBlock)failure {
    
    // 设置超时时间
    NSNumber *timeoutIntervalNumber = attributesDic[BBNetworkTimeoutIntervalName];
    NSTimeInterval timeoutInterval = timeoutIntervalNumber ? timeoutIntervalNumber.integerValue : [[self shareInstance] timeoutInterval];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer.timeoutInterval = timeoutInterval;
    
    manager.requestSerializer = [AFHTTPRequestSerializer serializer]; // 请求不使用AFN默认转换,保持原有数据
    manager.responseSerializer = [AFHTTPResponseSerializer serializer]; // 响应不使用AFN默认转换,保持原有数据
    
    NSURLSessionDataTask *task = [manager POST:URLString parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        /**
         *  压缩图片然后再上传(1.0代表无损 0~~1.0区间)
         */
//        NSData *data = UIImageJPEGRepresentation(picModle.pic, 1.0);
//        CGFloat precent = self.picSize / (data.length / 1024.0);
//        if (precent > 1)
//        {
//            precent = 1.0;
//        }
//        data = nil;
        
        NSString *fileName = [NSString stringWithFormat:@"%@.jpg", picModle.picName];
        NSData *fileData;
        if (picModle.picData) {
            fileData = picModle.picData;
        }else {
            fileData = UIImageJPEGRepresentation(picModle.picImage, 0.2);
        }
        [formData appendPartWithFileData:fileData name:picModle.picName fileName:fileName mimeType:@"image/jpeg"];
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
        if (progress) {
            progress(uploadProgress); // NSLog(@"%lf", 1.0 * uploadProgress.completedUnitCount / uploadProgress.totalUnitCount);
        }
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if (success) {
            // 处理数据
            [self successHandle:responseObject withSuccess:success withfailure:failure withAttributes:attributesDic];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        if (failure) {
            failure(error);
        }
    }];
    
    return task;
}




#pragma mark 内部实现

/**
 请求返回成功，对响应数据进行处理

 @param responseObject 服务端返回数据
 @param success 成功外部回调
 @param failure 失败外部回调
 @param attributesDic 可选参数
 */
+ (void)successHandle:(id )responseObject
          withSuccess:(responseSuccessBlock)success
          withfailure:(responseFailureBlock)failure
       withAttributes:(NSDictionary *)attributesDic{
    
    // 设置响应数据类型
    NSNumber *responseTypeNumber = attributesDic[BBNetworkResponseTypeName];
    BBNetResponseType responseType = responseTypeNumber ? responseTypeNumber.integerValue : BBNetResponseNSDictionary;
    
    // -服务端返回数据格式是 NSDictionary
    if (responseObject != nil && [responseObject isKindOfClass:[NSDictionary class]]) {
        
        [self bbNetWorkingHandleNSDictionary:responseObject withSuccessBolck:success withFailureBolck:failure];
    }
    
    // -服务端返回数据格式是 NSData
    else if(responseObject != nil && [responseObject isKindOfClass:[NSData class]]) {
        
        NSError* error = nil;
        
        // --假如指定返回data数据类型，则直接返回
        if (responseType == BBNetResponseNSData) {
            success(responseObject);
        }
        // --处理NSData数据，返回 NSDictionary
        else if (responseType == BBNetResponseNSDictionary){
            
            NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:responseObject
                                                                         options:0
                                                                           error:&error];
            if (!error) {
                [self bbNetWorkingHandleNSDictionary:responseDict withSuccessBolck:success withFailureBolck:failure];
            }else {
                failure(error);
            }
        }
        // --处理NSString数据，不进行任何处理，直接返回
        else {
            
            NSString *responseStr = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
            
            if (responseStr && ![responseStr isEqualToString:@""]) {
                success(responseStr);
            }
        }
        
    }
    
    else if (responseObject != nil && [responseObject isKindOfClass:[NSString class]]) {
        success(responseObject);
    }
    
    else {
        NSError *error = [NSError errorWithDomain:@"responseObject format is error" code:-2 userInfo:responseObject];
        failure(error);
    }
}

/**
 处理服务端响应的数据，直接返回可用的NSDictionary

 @param responseDict        需要处理的NSDictionary
 @param success 处理成功回调
 @param failure 处理失败回调
 */
+ (void)bbNetWorkingHandleNSDictionary:(NSDictionary *)responseDict
                      withSuccessBolck:(responseSuccessBlock )success
                      withFailureBolck:(responseFailureBlock )failure{
    
    if (responseDict) {
        // 假如返回的数据中含有 status 状态码，先判断是否为1，再进行返回
        if ([[responseDict allKeys] containsObject:@"status"]) {
            if ([[responseDict objectForKey:@"status"] intValue] == 1) {
                
//                BBResponseObject *responseObject = [BBResponseObject responseObjectWithDictionary:responseDict];
                success(responseDict);
            }else {
                NSError *error;
                if ([[responseDict objectForKey:@"status"] intValue] == 0) {
                    error = [NSError errorWithDomain:@"status is zero" code:-1 userInfo:responseDict];
                }
                failure(error);
            }
        }else {
            success(responseDict);
        }
    }
}

@end
