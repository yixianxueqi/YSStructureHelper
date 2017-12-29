//
//  YSStreamNetwork.m
//  YSStructureHelperDemo
//
//  Created by 君若见故 on 2017/12/15.
//  Copyright © 2017年 develop. All rights reserved.
//

#import "YSStreamNetwork.h"
#import <AFNetworking/AFNetworking.h>

@implementation YSUploadItem
@end

@implementation YSUploadFileItem
@end

@implementation YSUploadDataItem
@end

@implementation YSUploadObjct
@end

@implementation YSStreamNetwork

+ (NSURLSessionDownloadTask *)downloadTaskWithURl:(NSString *)urlString
                                         progress:(void (^)(NSProgress *))progress
                                     saveFilePath:(NSString *)filePath
                                completionHandler:(void (^)(NSURLResponse *, NSURL *, NSError *))completionHandler {

    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *sessionManager = [[AFURLSessionManager alloc] initWithSessionConfiguration:config];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    NSURLSessionDownloadTask *downloadTask = [sessionManager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
        if (progress) {
            dispatch_async(dispatch_get_main_queue(), ^{
                progress(downloadProgress);
            });
        }
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        return [NSURL fileURLWithPath:[filePath stringByAppendingPathComponent:response.suggestedFilename]];
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        if (completionHandler) {
            completionHandler(response, filePath, error);
        }
    }];
    [downloadTask resume];
    return downloadTask;
}

+ (NSURLSessionUploadTask *)uploadTaskWithURL:(NSString *)urlString
                                   uploadInfo:(YSUploadObjct *)info
                                       header:(NSDictionary *)header
                                     progress:(void (^)(NSProgress *))progress
                            completionHandler:(void (^)(NSURLResponse *, id, NSError *))completionHandler {
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST" URLString:urlString parameters:info.params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        if (info.type == YSUploadType_File) {
            for (YSUploadFileItem *item in info.filePathList) {
                [formData appendPartWithFileURL:[NSURL fileURLWithPath:item.filePath] name:item.name fileName:item.fileName mimeType:item.mimeType error:nil];
            }
        } else {
            for (YSUploadDataItem *item in info.dataList) {
                [formData appendPartWithFileData:item.data name:item.name fileName:item.fileName mimeType:item.mimeType];
            }
        }
    } error:nil];
    for (NSString *key in header) {
        [request setValue:header[key] forHTTPHeaderField:key];
    }
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *sessionManager = [[AFURLSessionManager alloc] initWithSessionConfiguration:config];
    NSURLSessionUploadTask *uploadTask = [sessionManager uploadTaskWithStreamedRequest:request progress:^(NSProgress * _Nonnull uploadProgress) {
        if (progress) {
            dispatch_async(dispatch_get_main_queue(), ^{
                progress(uploadProgress);
            });
        }
    } completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        if (completionHandler) {
            completionHandler(response, responseObject, error);
        }
    }];
    [uploadTask resume];
    return uploadTask;
}

@end
