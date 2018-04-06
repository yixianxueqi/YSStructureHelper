//
//  NSFileManager+FileAssist.m
//  YSStructureHelperDemo
//
//  Created by 君若见故 on 2018/3/19.
//  Copyright © 2018年 develop. All rights reserved.
//

#import "NSFileManager+FileAssist.h"

@implementation NSFileManager (FileAssist)

+ (void)userPlistStoreValue:(id)value withKey:(NSString *)key {
    
    [[NSUserDefaults standardUserDefaults] setValue:value forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (id)userPlistGetValueByKey:(NSString *)key {
    
    return [[NSUserDefaults standardUserDefaults] valueForKey:key];
}

//Documents路径
+ (NSString *)documentsPath {
    
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
}
//Library路径
+ (NSString *)libraryPath {
    return [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) firstObject];
}
//tmp路径
+ (NSString *)tmpPath {
    
    return NSTemporaryDirectory();
}
//Caches路径
+ (NSString *)cachesPath {
    return [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
};

- (BOOL)fileIsExistAtPath:(NSString *)path andNullCreate:(BOOL)isCreate {
    
    BOOL flag = [self fileExistsAtPath:path];
    if (flag) {
        return flag;
    } else {
        if (isCreate) {
            [self createFileAtPath:path contents:nil attributes:nil];
        }
        return false;
    }
}

- (BOOL)directoryIsExistAtPath:(NSString *)path andNullCreate:(BOOL)isCreate {
    
    BOOL isDir;
    BOOL flag = [self fileExistsAtPath:path isDirectory:&isDir];
    if (flag && isDir) {
        return flag;
    } else {
        if (isCreate) {
            [self createDirectoryAtPath:path withIntermediateDirectories:true attributes:nil error:nil];            
        }
        return false;
    }
}

- (double)sizeOfFileAtPath:(NSString *)path {
    
    if ([self fileExistsAtPath:path]) {
        return [[self attributesOfItemAtPath:path error:nil] fileSize];
    }
    return -1;
}

- (double)sizeOfDirectoryAtPath:(NSString *)path {
    
    if ([self directoryIsExistAtPath:path andNullCreate:false]) {
        long long folderSize = 0;
        NSArray *items = [self contentsOfDirectoryAtPath:path error:nil];
        for (NSString *fileName in items) {
            @autoreleasepool{
                NSString *subPath = [path stringByAppendingPathComponent:fileName];
                if ([self directoryIsExistAtPath:subPath andNullCreate:false]) {
                    folderSize += [self sizeOfDirectoryAtPath:subPath];
                } else {
                    folderSize += [self sizeOfFileAtPath:subPath];
                }
            }
        }
        return folderSize;
    }
    return -1;
}

@end















