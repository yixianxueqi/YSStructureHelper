//
//  NSFileManager+FileAssist.h
//  YSStructureHelperDemo
//
//  Created by 君若见故 on 2018/3/19.
//  Copyright © 2018年 develop. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSFileManager (FileAssist)

/*
    沙盒默认的plist存取
 */
+ (void)userPlistStoreValue:(id)value withKey:(NSString *)key;
+ (id)userPlistGetValueByKey:(NSString *)key;

/*
    获取路径相关
 */
//Documents路径
+ (NSString *)documentsPath;
//Library路径
+ (NSString *)libraryPath;
//tmp路径
+ (NSString *)tmpPath;
//Caches路径
+ (NSString *)cachesPath;

/*
 文件操作相关
 */

/**
 判断文件是否存在，返回True/False, isCreate标识当不存在时，是否创建。

 @param path 文件路径
 @param isCreate 是否创建
 @return 是否存在
 */
- (BOOL)fileIsExistAtPath:(NSString *)path andNullCreate:(BOOL)isCreate;

/**
 判断目录是否存在，返回True/False, isCreate标识当不存在时，是否创建。

 @param path 目录路径
 @param isCreate 是否创建
 @return 是否存在
 */
- (BOOL)directoryIsExistAtPath:(NSString *)path andNullCreate:(BOOL)isCreate;

/**
 获取文件大小，文件若不存在则返回-1。

 @param path 文件路径
 @return 字节大小 Byte
 */
- (double)sizeOfFileAtPath:(NSString *)path;

/**
 获取目录大小，目录若不存在则返回-1。

 @param path 目录路径
 @return 字节大小 Byte
 */
- (double)sizeOfDirectoryAtPath:(NSString *)path;

@end
















