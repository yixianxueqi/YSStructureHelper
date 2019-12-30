//
//  YSConvenienceThread.h
//  YSSimpleOperation
//
//  Created by Lola001 on 2019/12/24.
//  Copyright © 2019 all. All rights reserved.
//

#import <Foundation/Foundation.h>

#if DEBUG
    #define YSConvenienceThreadEnableLog
#endif


#ifdef YSConvenienceThreadEnableLog
    // 输出群组及任务执行概况，以及任务完成耗时
    #define Tlog(...) NSLog(__VA_ARGS__)
#endif

extern NSString * const HeartBeatNotificationUnMainThread;
extern NSString * const HeartBeatNotificationInMainThread;

typedef void(^YSFinshBlock)(void);
typedef void(^YSActionTaskBlock)(_Nonnull YSFinshBlock);

@protocol YSMainRunloopActivityDelegate <NSObject>

@optional
- (void)mainRunloop:(NSRunLoop *)runloop activity:(CFRunLoopActivity)activity;

@end

/*
 线程
 */
@interface YSConvenienceThread : NSObject

+ (instancetype)convenienceThread;

- (void)addMainRunloopDelegate:(id<YSMainRunloopActivityDelegate>)delegate;
- (void)removeMainRunloopDelegate:(id<YSMainRunloopActivityDelegate>)delegate;

/*
 为防止阻塞延迟，单独在heartThread线程,
 此线程常驻只添加了定时器
 */
- (void)startHeartBeat;

/*
 类似主线程，为常驻线程且开启runloop和autoreleasepool,可用以下API指定此线程执行
 - (void)performSelector:(SEL)aSelector onThread:(NSThread *)thr withObject:(nullable id)arg waitUntilDone:(BOOL)wait
 - (void)performSelector:(SEL)aSelector onThread:(NSThread *)thr withObject:(nullable id)arg waitUntilDone:(BOOL)wait modes:(nullable NSArray<NSString *> *)array
 */
- (NSThread *)shadowThread;

/*
 将对象放在其它线程销毁，防止阻塞当前线程
 */
- (void)droptThread:(void(^)(void))block;

/*
 优先级为QOS_CLASS_DEFAULT的串行队列
 */
- (void)addSerialTask:(YSActionTaskBlock)block;

/*
 添加任务至优先级为QOS_CLASS_DEFAULT的DISPATCH_QUEUE_CONCURRENT队列内执行；
 立即执行
 */
- (void)addConcurrentTask:(void(^)(void))block;

/*
 在优先级为QOS_CLASS_DEFAULT的DISPATCH_QUEUE_CONCURRENT队列内；
 添加任务至指定分组,需startConcurrnetTaskForGroup方法开始执行该分组内所有任务
 若groupId=""则默认为groupId="None"
 */
- (void)addConcurrentTaskInGroup:(nonnull NSString *)groupId task:(YSActionTaskBlock _Nullable )block;

/*
 添加指定分组任务完成回调；
 @note: 该回调只会回调一次，然后finshBlock会被移除掉
 */
- (void)addConcurrentTaskCallbackforGroupId:(nonnull NSString *)groupId inMainThread:(BOOL)inMainThread finsh:(void(^_Nullable)(void))finshBlock;

/*
 移除指定分组完成回调,
 */
- (void)removeConcurrentTaskCallbackforGroupId:(nonnull NSString *)groupId;

/*
 立即执行指定分组内所有任务
 */
- (void)startConcurrnetTaskForGroup:(nonnull NSString *)groupId;

@end

