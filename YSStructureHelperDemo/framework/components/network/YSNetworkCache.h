//
//  YSNetworkCache.h
//  YSStructureHelperDemo
//
//  Created by 君若见故 on 2017/12/12.
//  Copyright © 2017年 develop. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
     网络缓存，主要采用YYCache作为核心去缓存
 */

//缓存结果回调Block
typedef void(^YSNetworkCacheResultBlock)(NSString *key, NSDictionary *result);

/**
     网络缓存
 */
@interface YSNetworkCache : NSObject

+ (instancetype)shareCache;

// 获取缓存文件大小,单位KB
- (double)diskCost;

//获取是否存在缓存
- (BOOL)containsAvailableCacheForKey:(NSString *)key;
- (BOOL)containsAvailableCacheForKey:(NSString *)key limitTime:(NSTimeInterval)seconds;

/*
 获取缓存对象，为防止读取缓存对象过于耗时而阻塞当前线程，
 在background queue内进行，结果在block内异步回调，默认在主线程回调
 */
- (void)objectForKey:(NSString *)key withBlock:(YSNetworkCacheResultBlock)resultBlock;

// 获取缓存对象，
- (NSDictionary *)objectForKey:(NSString *)key;

/*
 设置缓存对象，为防止待缓存对象过大写入时阻塞当前线程，
 在background queue进行缓存，完成后在主线程异步回调
 */
- (void)setObject:(NSDictionary *)object forKey:(NSString *)key withBlock:(void(^)(void))finshBlock;

/*
 移除指定缓存，在background queue进行，
 在主线程内异步回调
 */
- (void)removeObjectForKey:(NSString *)key withBlock:(void(^)(void))finshBlock;

/*
 移除全部缓存，在background queue进行，
 在主线程内异步回调
 */
- (void)removeAllCacheWithBlock:(void(^)(void))finshBlock;

/**
 移除内存缓存
 @note 防止内存占用过大，收到警告时可清理下内存
 */
- (void)removeMemoryCache;

@end
