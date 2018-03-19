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
+ (NSString *)tempPath;
//Caches路径
+ (NSString *)cachesPath;

@end
