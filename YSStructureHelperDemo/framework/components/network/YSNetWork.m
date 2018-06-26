//
//  YSNetWork.m
//  YSStructureHelperDemo
//
//  Created by 君若见故 on 2017/12/12.
//  Copyright © 2017年 develop. All rights reserved.
//

#import "YSNetWork.h"
#import <AFNetworking/AFNetworking.h>
#import "YSNetworkFailureHandle.h"
#import "YSNetworkCache.h"
#import <CommonCrypto/CommonDigest.h>

//超时时间
static NSTimeInterval const timeOut = 30.0;

@interface YSNetWork()

@property (nonatomic, strong) AFHTTPSessionManager *sessionManager;
@property (nonatomic, strong) YSNetworkCache *networkCache;

@end

@implementation YSNetWork

static YSNetWork *netwok;
+ (instancetype)defaultNetwork {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        netwok = [[self alloc] init];
    });
    return netwok;
}

#pragma mark - settings

- (void)setTimeOut:(NSTimeInterval)seconds {
    if(seconds <= 0.0) {
        seconds = timeOut;
    }
    self.sessionManager.requestSerializer.timeoutInterval = seconds;
}

- (NSDictionary *)getAllHeaders {
    return [self.sessionManager.requestSerializer HTTPRequestHeaders];
}

- (void)setRequestHeaderWithKey:(NSString *)key value:(NSString *)value {
    [self.sessionManager.requestSerializer setValue:value forHTTPHeaderField:key];
}

- (NSSet *)getAllresponseAcceptableContentType {
    return [self.sessionManager.responseSerializer acceptableContentTypes];
}

- (void)setResponseAcceptableContentType:(NSString *)type {

    NSSet *typeSet = [[self.sessionManager.responseSerializer acceptableContentTypes] setByAddingObject:type];
    [self.sessionManager.responseSerializer setAcceptableContentTypes: typeSet];
}

- (void)setHttpsCertificateWithFilePath:(NSString *)filePath {

    if (filePath.length <= 0) {
        return;
    }
    NSData *data = [NSData dataWithContentsOfFile:filePath];
    NSSet *setInfo = [[NSSet alloc] initWithObjects:data, nil];
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate];
    //是否允许无效证书，true:允许，false:不允许
    [securityPolicy setAllowInvalidCertificates:true];
    //是否校验域名，true:校验，false：不校验
    securityPolicy.validatesDomainName = false;
    [securityPolicy setPinnedCertificates:setInfo];
    self.sessionManager.securityPolicy = securityPolicy;
}

#pragma mark - http

- (NSURLSessionDataTask *)GET:(NSString *)URLString
                   parameters:(NSDictionary *)parameters
               cacheTimeLimit:(NSTimeInterval)timeLimit
                  cachePolicy:(YSNetworkCachePolicy)cachePolicy
                     progress:(requestProgressBlock)progress
                      success:(requestSuccessBlock)success
                      failure:(requestFailureBlock)failure {

    NSString *cacheKey = [self getCacheKeyFromURLString:URLString params:parameters];
    switch (cachePolicy) {
        case YSNetworkCachePolicy_cache: {
            BOOL isAvailableCache = [self canUseCachePolicy:YSNetworkCachePolicy_cache cacheKey:cacheKey limitTime:timeLimit];
            if (isAvailableCache) {
                NSDictionary *result = [self.networkCache objectForKey:cacheKey];
                success(result);
                return nil;
            }
        }
            break;
        case YSNetworkCachePolicy_cacheWithLimitTime: {
            BOOL isAvailableCache = [self canUseCachePolicy:YSNetworkCachePolicy_cacheWithLimitTime cacheKey:cacheKey limitTime:timeLimit];
            if (isAvailableCache) {
                NSDictionary *result = [self.networkCache objectForKey:cacheKey];
                success(result);
                return nil;
            }
        }
            break;
        case YSNetworkCachePolicy_cacheAndRequest: {
            BOOL isAvailableCache = [self canUseCachePolicy:YSNetworkCachePolicy_cacheAndRequest cacheKey:cacheKey limitTime:timeLimit];
            if (isAvailableCache) {
                NSDictionary *result = [self.networkCache objectForKey:cacheKey];
                success(result);
            }
        }
            break;
        case YSNetworkCachePolicy_request:
            break;
        case YSNetworkCachePolicy_none:
            break;
    }

    return [self.sessionManager GET:URLString parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        if(progress) {
            dispatch_async(dispatch_get_main_queue(), ^{
                progress(downloadProgress);
            });
        }
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (cachePolicy == YSNetworkCachePolicy_cache ||
            cachePolicy == YSNetworkCachePolicy_cacheAndRequest ||
            cachePolicy == YSNetworkCachePolicy_cacheWithLimitTime) {
            [self.networkCache setObject:responseObject forKey:cacheKey withBlock:nil];
        }
        if(success) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if(failure) {
            NSError *loacalError = [YSNetworkFailureHandle handleNetworkFailure:error];
            failure(loacalError);
        }
    }];
}

- (NSURLSessionDataTask *)POST:(NSString *)URLString
                    parameters:(NSDictionary *)parameters
                cacheTimeLimit:(NSTimeInterval)timeLimit
                   cachePolicy:(YSNetworkCachePolicy)cachePolicy
                      progress:(requestProgressBlock)progress
                       success:(requestSuccessBlock)success
                       failure:(requestFailureBlock)failure {

    NSString *cacheKey = [self getCacheKeyFromURLString:URLString params:parameters];
    switch (cachePolicy) {
        case YSNetworkCachePolicy_cache: {
            BOOL isAvailableCache = [self canUseCachePolicy:YSNetworkCachePolicy_cache cacheKey:cacheKey limitTime:timeLimit];
            if (isAvailableCache) {
                NSDictionary *result = [self.networkCache objectForKey:cacheKey];
                success(result);
                return nil;
            }
        }
            break;
        case YSNetworkCachePolicy_cacheWithLimitTime: {
            BOOL isAvailableCache = [self canUseCachePolicy:YSNetworkCachePolicy_cacheWithLimitTime cacheKey:cacheKey limitTime:timeLimit];
            if (isAvailableCache) {
                NSDictionary *result = [self.networkCache objectForKey:cacheKey];
                success(result);
                return nil;
            }
        }
            break;
        case YSNetworkCachePolicy_cacheAndRequest: {
            BOOL isAvailableCache = [self canUseCachePolicy:YSNetworkCachePolicy_cacheAndRequest cacheKey:cacheKey limitTime:timeLimit];
            if (isAvailableCache) {
                NSDictionary *result = [self.networkCache objectForKey:cacheKey];
                success(result);
            }
        }
            break;
        case YSNetworkCachePolicy_request:
            break;
        case YSNetworkCachePolicy_none:
            break;
    }

    return [self.sessionManager POST:URLString parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        if (progress) {
            dispatch_async(dispatch_get_main_queue(), ^{
                progress(uploadProgress);
            });
        }
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (cachePolicy == YSNetworkCachePolicy_cache ||
            cachePolicy == YSNetworkCachePolicy_cacheAndRequest ||
            cachePolicy == YSNetworkCachePolicy_cacheWithLimitTime) {
            [self.networkCache setObject:responseObject forKey:cacheKey withBlock:nil];
        }
        log_debug(@"发起请求");
        if(success) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            NSError *localError = [YSNetworkFailureHandle handleNetworkFailure:error];
            failure(localError);
        }
    }];
}

#pragma mark - private

/**
 将请求地址和请求参数合为同一字符串，经MD5加密后作为缓存cacheKey

 @param urlString 请求地址
 @param params 请求参数
 @return cacheKey
 */
- (NSString *)getCacheKeyFromURLString:(NSString *)urlString params:(NSDictionary *)params {

    NSMutableString *key = [NSMutableString stringWithString: urlString];
    NSError *error = nil;
    NSData *data = [NSJSONSerialization dataWithJSONObject:params options:NSJSONWritingPrettyPrinted error:&error];
    if (!error) {
        NSString *paramsStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        [key appendString:paramsStr];
    }
    return [[self class] MD5String:key];
}


/**
 将字符串MD5加密

 @param string 待加密字符串
 @return NSString *
 */
+ (NSString *)MD5String:(NSString *)string {

    if(self == nil || [string length] == 0)
        return nil;
    const char *value = [string UTF8String];
    unsigned char outputBuffer[CC_MD5_DIGEST_LENGTH];
    CC_MD5(value, (CC_LONG)strlen(value), outputBuffer);
    NSMutableString *outputString = [[NSMutableString alloc] initWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(NSInteger count = 0; count < CC_MD5_DIGEST_LENGTH; count++){
        [outputString appendFormat:@"%02x",outputBuffer[count]];
    }
    return outputString;
}

#pragma mark - cache
/**
 是否可以使用缓存

 @param cacheKey 缓存唯一性标识
 @return Bool
 */
- (BOOL)canUseCachePolicy:(YSNetworkCachePolicy)cachePolicy
                 cacheKey:(NSString *)cacheKey
                limitTime:(NSTimeInterval)limitTime {

    BOOL isAvailabelCache = false;
    if (cachePolicy == YSNetworkCachePolicy_cacheWithLimitTime) {
        isAvailabelCache = [self.networkCache containsAvailableCacheForKey:cacheKey limitTime:limitTime];
    } else {
        isAvailabelCache = [self.networkCache containsAvailableCacheForKey:cacheKey];
    }
    return isAvailabelCache;
}

#pragma mark - getter/setter
- (AFHTTPSessionManager *)sessionManager {
    if(!_sessionManager) {
        _sessionManager = [AFHTTPSessionManager manager];
        _sessionManager.requestSerializer = [AFJSONRequestSerializer serializer];
        _sessionManager.requestSerializer.timeoutInterval = timeOut;
    }
    return _sessionManager;
}

- (YSNetworkCache *)networkCache {
    if (!_networkCache) {
        _networkCache = [YSNetworkCache shareCache];
    }
    return _networkCache;
}

@end
