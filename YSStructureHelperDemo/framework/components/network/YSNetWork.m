//
//  YSNetWork.m
//  YSStructureHelperDemo
//
//  Created by 君若见故 on 2017/12/12.
//  Copyright © 2017年 develop. All rights reserved.
//

#import "YSNetWork.h"
#import <AFNetworking.h>
#import "YSNetworkFailureHandle.h"

//超时时间
static NSTimeInterval const timeOut = 30.0;

@interface YSNetWork()

@property (nonatomic, strong) AFHTTPSessionManager *sessionManager;

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

#pragma mark - http

- (NSURLSessionDataTask *)GET:(NSString *)URLString
                   parameters:(NSDictionary *)parameters
                  cachePolicy:(YSNetworkCachePolicy)cachePolicy
                     progress:(requestProgressBlock)progress
                      success:(requestSuccessBlock)success
                      failure:(requestFailureBlock)failure {

    return [self.sessionManager GET:URLString parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        if(progress) {
            dispatch_async(dispatch_get_main_queue(), ^{
                progress(downloadProgress);
            });
        }
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
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
                   cachePolicy:(YSNetworkCachePolicy)cachePolicy
                      progress:(requestProgressBlock)progress
                       success:(requestSuccessBlock)success
                       failure:(requestFailureBlock)failure {

    return [self.sessionManager POST:URLString parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        if (progress) {
            dispatch_async(dispatch_get_main_queue(), ^{
                progress(uploadProgress);
            });
        }
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
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

#pragma mark - getter/setter
- (AFHTTPSessionManager *)sessionManager {
    if(!_sessionManager) {
        _sessionManager = [AFHTTPSessionManager manager];
        _sessionManager.requestSerializer = [AFJSONRequestSerializer serializer];
        _sessionManager.requestSerializer.timeoutInterval = timeOut;
    }
    return _sessionManager;
}

@end
