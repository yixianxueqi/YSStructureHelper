//
//  NSObject+YSNotification.h
//  testConvinence
//
//  Created by Lola001 on 2019/10/18.
//  Copyright © 2019 all. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^YSNotificationHandleBlock)(id object, NSDictionary *userInfo);

@interface NSObject (YSNotification)

- (void)addObserveNotification:(NSString *)notificationName object:(nullable id)object handleBlock:(nullable YSNotificationHandleBlock)block;
- (void)removeObserveNotification:(NSString *)notificationName object:(nullable id)object;
- (void)removeAllObserveNotification;

@end
