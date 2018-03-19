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
+ (NSString *)tempPath {
    
    return NSTemporaryDirectory();
}
//Caches路径
+ (NSString *)cachesPath {
    return [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
};

@end
