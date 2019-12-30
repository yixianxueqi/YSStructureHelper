//
//  NSObject+YSNotification.m
//  testConvinence
//
//  Created by Lola001 on 2019/10/18.
//  Copyright © 2019 all. All rights reserved.
//

#import "NSObject+YSNotification.h"
#import <objc/runtime.h>

@implementation NSObject (YSNotification)

#pragma mark - lifeCycle
#pragma mark - public
- (void)addObserveNotification:(NSString *)notificationName object:(nullable id)object handleBlock:(YSNotificationHandleBlock)block {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:notificationName object:object];
    @synchronized (self) {
        if (block) {
            NSString *key = [self mapKeyForNotification:notificationName object:object];
            [[self mapTable] setObject:block forKey:key];
        }
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleNotification:) name:notificationName object:object];
}

- (void)removeObserveNotification:(NSString *)notificationName object:(nullable id)object {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:notificationName object:object];
    @synchronized (self) {
        if (object) {
            NSString *key = [self mapKeyForNotification:notificationName object:object];
            [[self mapTable] removeObjectForKey:key];
        } else {
            NSMutableDictionary *map = [self mapTable];
            NSMutableArray *removeList = [NSMutableArray array];
            [map enumerateKeysAndObjectsUsingBlock:^(NSString *key, id  _Nonnull obj, BOOL * _Nonnull stop) {
                if ([key hasPrefix:[NSString stringWithFormat:@"%@_", notificationName]]) {
                    [removeList addObject:key];
                }
            }];
            for (NSString *key in removeList) {
                [map removeObjectForKey:key];
            }
        }
    }
}

- (void)removeAllObserveNotification {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    @synchronized (self) {
        [[self mapTable] removeAllObjects];
    }
}
#pragma mark - incident
#pragma mark - private
- (void)handleNotification:(NSNotification *)notification {
    
    NSString *key = [self mapKeyForNotification:notification.name object:notification.object];
    YSNotificationHandleBlock block = [[self mapTable] objectForKey:key];
    if (block) {
        block(notification.object, notification.userInfo);
    }
    if (notification.object) {
        NSString *otherKey = [self mapKeyForNotification:notification.name object:nil];
        block = [[self mapTable] objectForKey:otherKey];
        if (block) {
            block(notification.object, notification.userInfo);
        }
    }
}

- (NSString *)mapKeyForNotification:(NSString *)notificationName object:(nullable id)object {
    
    return [NSString stringWithFormat:@"%@_%p", notificationName, object];
}
#pragma mark - delegate
#pragma mark - getter/setter

- (NSMutableDictionary *)mapTable {
    
    @synchronized (self) {
        NSMutableDictionary *map = objc_getAssociatedObject(self, _cmd);
        if (!map) {
            map = [NSMutableDictionary dictionary];
            objc_setAssociatedObject(self, _cmd, map, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }
        return map;
    }
}

@end
