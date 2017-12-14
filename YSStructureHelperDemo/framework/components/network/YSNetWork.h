//
//  YSNetWork.h
//  YSStructureHelperDemo
//
//  Created by 君若见故 on 2017/12/12.
//  Copyright © 2017年 develop. All rights reserved.
//

#import <Foundation/Foundation.h>

//成功回调
typedef void(^requestSuccessBlock)(id responseObj);
//失败回调
typedef void(^requestFailureBlock)(NSError *error);
//进度回调
typedef void(^requestProgressBlock)(NSProgress *progress);

// 缓存策略
typedef NS_ENUM(NSInteger, YSNetworkCachePolicy) {

    /*
     总是使用缓存数据，无则请求数据
     */
    YSNetworkCachePolicy_cache = 1,
    /*
     优先使用缓存，其次去请求数据。
     若缓存存在，会返回两次数据，第一次为缓存数据，第二次为请求数据
     若缓存不存在，则只会返回一次数据，为请求数据
     */
    YSNetworkCachePolicy_cacheAndRequest,
    /*
     使用有限制的缓存，在一定时间内使用缓存数据，超出时间则是发起新的请求。
     例：在60s内重复请求同一接口，则使用缓存数据，超出60s后，则发起新的请求去请求数据，并更新缓存
     */
    YSNetworkCachePolicy_cacheWithLimitTime,
    /*
     总是发起请求
     */
    YSNetworkCachePolicy_request,
    /*
     无缓存策略
     */
    YSNetworkCachePolicy_none,
};


@interface YSNetWork : NSObject

/*
 当缓存策略为YSNetworkCachePolicy_cacheWithLimitTime时有效,
 设置在指定时间差内取缓存，超出则发起新的请求
 默认60s
 */
@property (nonatomic, assign) NSTimeInterval cacheTimeLimit;

+ (instancetype)defaultNetwork;
#pragma mark - settings

/**
 设置超时时间，对netWorkCenter的POST/GET请求生效

 @param seconds 超时时间，默认30s,若为0，则自动设置默认值
 */
- (void)setTimeOut:(NSTimeInterval)seconds;

/**
 获取请求头内容

 @return NSDictionary *;
 */
- (NSDictionary *)getAllHeaders;


/**
 设置请求头内容

 @param key NSString *
 @param value NSString *
 */
- (void)setRequestHeaderWithKey:(NSString *)key value:(NSString *)value;

/**
 获取所有可接受内容类型

 @return NSSet *
 */
- (NSSet *)getAllresponseAcceptableContentType;


/**
 设置返回可接受内容类型

 @param type NSString *
 */
- (void)setResponseAcceptableContentType:(NSString *)type;

#pragma mark - http


/**
 Get请求

 @param URLString 请求地址
 @param parameters 请求参数
 @param cachePolicy 缓存策略
 @param progress 内容下载进度
 @param success 成功回调
 @param failure 失败回调
 @return NSURLSessionDataTask *
 */
- (NSURLSessionDataTask *)GET:(NSString *)URLString
                   parameters:(NSDictionary *)parameters
                  cachePolicy:(YSNetworkCachePolicy)cachePolicy
                     progress:(requestProgressBlock)progress
                      success:(requestSuccessBlock)success
                      failure:(requestFailureBlock)failure;



/**
 Post请求

 @param URLString 请求地址
 @param parameters 请求参数
 @param cachePolicy 缓存策略
 @param progress 请求内容上传进度
 @param success 成功回调
 @param failure 失败回调
 @return NSURLSessionDataTask *
 */
- (NSURLSessionDataTask *)POST:(NSString *)URLString
                   parameters:(NSDictionary *)parameters
                  cachePolicy:(YSNetworkCachePolicy)cachePolicy
                     progress:(requestProgressBlock)progress
                      success:(requestSuccessBlock)success
                      failure:(requestFailureBlock)failure;

@end




