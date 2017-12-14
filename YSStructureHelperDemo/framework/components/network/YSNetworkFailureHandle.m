//
//  YSNetworkFailureHandle.m
//  YSStructureHelperDemo
//
//  Created by 君若见故 on 2017/12/13.
//  Copyright © 2017年 develop. All rights reserved.
//

#import "YSNetworkFailureHandle.h"

static NSString *errorCode = @"errorCode";
static NSString *errorDomain = @"errorDomain";
static NSString *localDesc = @"localDesc";

@implementation YSNetworkFailureHandle

+ (NSError *)handleNetworkFailure:(NSError *)error {

    NSError *localError = nil;
    NSDictionary *errorInfo = [self analysisError:error];
    localError = [NSError errorWithDomain:errorInfo[errorDomain] code:((NSNumber *)errorInfo[errorCode]).integerValue userInfo:@{NSLocalizedDescriptionKey: errorInfo[localDesc]}];
    return localError;
}


/**
 解析常见错误
 @note 此处仅对错误描述做了本地化解释，错误域和错误码仍使用了原有的，
       实际使用中，可以根据业务需求，重新定义错误域和错误码，比如：将失去网络链接相关错误
       统一成一个自定义的错误码，在业务层使用时，可根据自定义错误码规则做相应的处理
 @param error 原生错误
 @return @{errorCode: xxx, errorDomain: xxx, localDesc: xxx}
 */
+ (NSDictionary *)analysisError:(NSError *)error {

    NSInteger code = error.code;
    NSString *domain = error.domain;
    NSString *desc = nil;
    switch (error.code) {
            case NSURLErrorUnknown:desc = @"未知原因错误";break;
            case NSURLErrorCancelled:desc = @"请求被取消";break;
            case NSURLErrorBadURL:desc = @"错误的请求地址";break;
            case NSURLErrorTimedOut:desc = @"请求超时,请重试";break;
            case NSURLErrorUnsupportedURL:desc = @"不支持的请求地址";break;
            case NSURLErrorCannotConnectToHost:desc = @"未能和服务器建立链接";break;
            case NSURLErrorNetworkConnectionLost:desc = @"网络链接已断开,请检查网络";break;
            case NSURLErrorNotConnectedToInternet:desc = @"未链接网络,请先链接网络";break;
            case NSURLErrorBadServerResponse:desc = @"访问了服务器未提供的服务";break;
            case NSURLErrorFileDoesNotExist:desc = @"请求资源不存在";break;
        default:
            desc = error.localizedDescription;
            break;
    }
    return @{errorCode: @(code), errorDomain: domain, localDesc: desc};
}

@end
