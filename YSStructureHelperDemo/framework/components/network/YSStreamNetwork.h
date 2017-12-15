//
//  YSStreamNetwork.h
//  YSStructureHelperDemo
//
//  Created by 君若见故 on 2017/12/15.
//  Copyright © 2017年 develop. All rights reserved.
//

#import <Foundation/Foundation.h>

//上传对象基类
@interface YSUploadItem: NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *fileName;
@property (nonatomic, copy) NSString *mimeType;

@end

//上传文件对象类型
@interface YSUploadFileItem: YSUploadItem

@property (nonatomic, copy) NSString *filePath;

@end

//上传二进制流数据对象类型
@interface YSUploadDataItem: YSUploadItem

@property (nonatomic, copy) NSData *data;

@end

//上传类型
typedef NS_ENUM(NSInteger, YSUploadType) {

    YSUploadType_File = 1, //文件类型
    YSUploadType_Data, //二进制流数据
};

//待上传数据模型
@interface YSUploadObjct: NSObject


/**
 上传类型
 若上传类型为YSUploadType_File，则filePathList必须有值
 若上传类型为YSUploadType_Data，则dataList必须有值
 */
@property (nonatomic, assign) YSUploadType type;
@property (nonatomic, strong) NSDictionary *params;
@property (nonatomic, strong) NSArray<YSUploadFileItem *> *filePathList;
@property (nonatomic, strong) NSArray<YSUploadDataItem *> *dataList;

@end


/**
 上传下载处理类
 */
@interface YSStreamNetwork : NSObject


/**
 下载

 @param urlString 下载地址
 @param progress 进度回调，默认主线程
 @param filePath 文件下载后的存储路径
 @param completionHandler 完成回调
 @return NSURLSessionDownloadTask *
 */
+ (NSURLSessionDownloadTask *)downloadTaskWithURl:(NSString *)urlString
                                         progress:(void(^)(NSProgress *progress))progress
                                     saveFilePath:(NSString *)filePath
                                completionHandler:(void (^)(NSURLResponse *response, NSURL *filePath, NSError *error))completionHandler;


/**
 上传

 @param urlString 上传地址
 @param info 待上传数据模型
 @param header 自定义添加header头内容
 @param progress 进度回调，默认主线程
 @param completionHandler 完成回调
 @return NSURLSessionUploadTask *
 */
+ (NSURLSessionUploadTask *)uploadTaskWithURL:(NSString *)urlString
                                   uploadInfo:(YSUploadObjct *)info
                                       header:(NSDictionary *)header
                                     progress:(void(^)(NSProgress *progress))progress
                            completionHandler:(void (^)(NSURLResponse *response, id responseObject, NSError *error))completionHandler;

@end
