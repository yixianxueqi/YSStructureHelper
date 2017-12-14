//
//  YSNetworkCache.h
//  YSStructureHelperDemo
//
//  Created by 君若见故 on 2017/12/12.
//  Copyright © 2017年 develop. All rights reserved.
//

#import <Foundation/Foundation.h>

//缓存结果回调Block
typedef void(^YSNetworkCacheResultBlock)(NSString *key, NSDictionary *result);

/**
     网络缓存
 */
@interface YSNetworkCache : NSObject

+ (instancetype)shareCache;

- (BOOL)containsAvailableCacheForKey:(NSString *)key;
- (BOOL)containsAvailableCacheForKey:(NSString *)key limitTime:(NSTimeInterval)seconds;
- (void)objectForKey:(NSString *)key withBlock:(YSNetworkCacheResultBlock)resultBlock;
- (void)setObject:(NSDictionary *)object forKey:(NSString *)key withBlock:(void(^)(void))finshBlock;
- (void)removeObjectForKey:(NSString *)key withBlock:(void(^)(void))finshBlock;
- (void)removeAllCacheWithBlock:(void(^)(void))finshBlock;

@end
