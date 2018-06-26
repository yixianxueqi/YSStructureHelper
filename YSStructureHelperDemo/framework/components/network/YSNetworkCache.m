//
//  YSNetworkCache.m
//  YSStructureHelperDemo
//
//  Created by 君若见故 on 2017/12/12.
//  Copyright © 2017年 develop. All rights reserved.
//

#import "YSNetworkCache.h"
#import <YYKit/YYCache.h>
#import <YYKit/YYMemoryCache.h>
#import <YYKit/YYDiskCache.h>

static NSString * const CacheTimeStamp = @"YSCacheTimeStamp";
static NSString * const Data = @"data";

@interface YSNetworkCache()

@property (nonatomic, strong) YYCache *yyCache;

@end

@implementation YSNetworkCache

#pragma mark - lifeCycle
static YSNetworkCache *cache;
+ (instancetype)shareCache {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        cache = [[self alloc] init];
    });
    return cache;
}

#pragma mark - public

- (double)diskCost {
    
    return self.yyCache.diskCache.totalCost / 1024.0;
}

- (BOOL)containsAvailableCacheForKey:(NSString *)key {

    return [self.yyCache containsObjectForKey:key];
}

- (BOOL)containsAvailableCacheForKey:(NSString *)key limitTime:(NSTimeInterval)seconds {

    BOOL isAvailable = false;
    BOOL isContain = [self.yyCache containsObjectForKey:key];
    if (isContain) {
        NSTimeInterval curTimeInterval = [[NSDate date] timeIntervalSince1970];
        NSDictionary *dic = (NSDictionary *)[self.yyCache objectForKey:key];
        NSTimeInterval cacheTime = [dic[CacheTimeStamp] integerValue];
        if (curTimeInterval - cacheTime < seconds) {
            isAvailable = true;
        } else {
            isAvailable = false;
        }
    }
    return isAvailable;
}

- (void)objectForKey:(NSString *)key withBlock:(YSNetworkCacheResultBlock)resultBlock {

    [self.yyCache objectForKey:key withBlock:^(NSString * _Nonnull key, id<NSCoding>  _Nonnull object) {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSDictionary *result = (NSDictionary *)object;
            if(resultBlock) {
                resultBlock(key, result[Data]);
            }
        });
    }];
}

- (NSDictionary *)objectForKey:(NSString *)key {
    
    NSDictionary *result = (NSDictionary *)[self.yyCache objectForKey:key];
    return result[Data];
}

- (void)setObject:(NSDictionary *)object forKey:(NSString *)key withBlock:(void(^)(void))finshBlock {

    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:@([[NSDate date] timeIntervalSince1970]) forKey:CacheTimeStamp];
    [dic setObject:object forKey:Data];
    [self.yyCache setObject:dic forKey:key withBlock:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            if (finshBlock) {
                finshBlock();
            }
        });
    }];
}

- (void)removeObjectForKey:(NSString *)key withBlock:(void(^)(void))finshBlock {

    [self.yyCache removeObjectForKey:key withBlock:^(NSString * _Nonnull key) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (finshBlock) {
                finshBlock();
            }
        });
    }];
}

- (void)removeAllCacheWithBlock:(void(^)(void))finshBlock {

    [self.yyCache removeAllObjectsWithBlock:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            if (finshBlock) {
                finshBlock();
            }
        });
    }];
}

- (void)removeMemoryCache {
    
    [self.yyCache.memoryCache removeAllObjects];
}

#pragma mark - getter/setter
- (YYCache *)yyCache {
    if (!_yyCache) {
        _yyCache = [YYCache cacheWithName:@"YSNetworkCache"];
    }
    return _yyCache;
}

@end
