//
//  YSConvenienceThread.m
//  YSSimpleOperation
//
//  Created by Lola001 on 2019/12/24.
//  Copyright © 2019 all. All rights reserved.
//

#import "YSConvenienceThread.h"
#import <YYKit/NSThread+YYAdd.h>

#ifdef YSConvenienceThreadEnableLog

#endif

NSString * const HeartBeatNotificationUnMainThread = @"HeartBeatNotificationUnMainThread";
NSString * const HeartBeatNotificationInMainThread = @"HeartBeatNotificationInMainThread";

static NSString *const kHeartThreadName = @"com.ys.heartThread";
static NSString *const kShadowThreadName = @"com.ys.shadowThread";
static char *const kDropQueueName = "com.ys.dropQueue";
static char *const kSerialQueueName = "com.ys.serialQueue";
static char *const kConcurrentQueueName = "com.ys.concurrentQueue";

@interface YSConvenienceThread ()
{
    dispatch_queue_t _dropQueue;
    NSHashTable *_delegatesList;
    NSThread *_shadowThread;
    NSThread *_heartThread;
    NSTimer *_timer;
    dispatch_queue_t _serialQueue;
    
    dispatch_queue_t _concurrentQueue;
    NSMutableArray *_groupList;
    NSMutableArray *_groupFinshCallBackList;
}
@end

@implementation YSConvenienceThread

#pragma mark - lifeCycle
static YSConvenienceThread *manager;
+ (instancetype)convenienceThread {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[self alloc] init];
        [manager prepare];
    });
    return manager;
}

#pragma mark - public
- (void)addMainRunloopDelegate:(id<YSMainRunloopActivityDelegate>)delegate {
    
    if (!delegate) {
        return;
    }
    @synchronized (_delegatesList) {
        [_delegatesList addObject:delegate];
    }
}

- (void)removeMainRunloopDelegate:(id<YSMainRunloopActivityDelegate>)delegate {
    
    @synchronized (_delegatesList) {
        [_delegatesList removeObject:delegate];
    }
}

- (void)startHeartBeat {
    
    _heartThread = [[NSThread alloc] initWithTarget:self selector:@selector(heartThreadRun) object:nil];
    _heartThread.name = kHeartThreadName;
    [_heartThread start];
}

- (NSThread *)shadowThread {
    
    return _shadowThread;
}

- (void)droptThread:(void (^)(void))block {
    
    if (!block) {
        return;
    }
    dispatch_async(_dropQueue, ^{
        if (block) {
            block();
        }
    });
}

- (void)addSerialTask:(YSActionTaskBlock)block {
    
    if (!block) {
        return;
    }
    dispatch_async(_serialQueue, ^{
#ifdef YSConvenienceThreadEnableLog
            CFAbsoluteTime taskStartTime = CFAbsoluteTimeGetCurrent();
#endif
        dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
        void(^finshBlock)(void) = ^{
            dispatch_semaphore_signal(semaphore);
#ifdef YSConvenienceThreadEnableLog
                CFAbsoluteTime taskLinkTime = (CFAbsoluteTimeGetCurrent() - taskStartTime);
                Tlog(@"YSSerialTask taskFinsh %.3f", taskLinkTime);
#endif
        };
        if (block) {
            block(finshBlock);
        }
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    });
}

- (void)addConcurrentTask:(void(^)(void))block {
    
    if (!block) {
        return;
    }
    dispatch_async(_concurrentQueue, block);
}

- (void)addConcurrentTaskInGroup:(nonnull NSString *)groupId task:(YSActionTaskBlock)block; {
    
    if (!block) {
        return;
    }
    if (groupId.length == 0) {
        groupId = @"None";
    }
    @synchronized (_groupList) {
        BOOL isInQueue = false;
        for (NSMutableDictionary *dic in _groupList) {
            NSString *grp = (NSString *)[dic valueForKey:@"groupId"];
            if ([grp isEqualToString:groupId]) {
                NSMutableArray *taskList = [dic valueForKey:@"taskList"];
                [taskList addObject:block];
                isInQueue = true;
            }
        }
        if (!isInQueue) {
            NSMutableDictionary *dic = [NSMutableDictionary dictionary];
            NSMutableArray *taskList = [NSMutableArray array];
            [taskList addObject:block];
            [dic setValue:groupId forKey:@"groupId"];
            [dic setValue:taskList forKey:@"taskList"];
            [_groupList addObject:dic];
        }
    }
}

- (void)addConcurrentTaskCallbackforGroupId:(nonnull NSString *)groupId inMainThread:(BOOL)inMainThread finsh:(void(^_Nullable)(void))finshBlock {
    
    if (!groupId || !finshBlock) {
        return;
    }
    if (groupId.length == 0) {
        groupId = @"None";
    }
    @synchronized (_groupFinshCallBackList) {
        BOOL isFind = false;
        for (NSMutableDictionary *info in _groupFinshCallBackList) {
            NSString *grp = [info valueForKey:@"groupId"];
            if ([grp isEqualToString:groupId]) {
                [info setValue:finshBlock forKey:@"callBack"];
                [info setValue:@(inMainThread) forKey:@"callBackThread"];
                isFind = true;
                break;
            }
        }
        if (!isFind) {
            NSMutableDictionary *info = [NSMutableDictionary dictionary];
            [info setValue:groupId forKey:@"groupId"];
            [info setValue:finshBlock forKey:@"callBack"];
            [info setValue:@(inMainThread) forKey:@"callBackThread"];
            [_groupFinshCallBackList addObject:info];
        }
    }
}

- (void)removeConcurrentTaskCallbackforGroupId:(nonnull NSString *)groupId {
    
    if (groupId == nil) {
        return;
    }
    if (groupId.length == 0) {
        groupId = @"None";
    }
    @synchronized (_groupFinshCallBackList) {
        NSMutableDictionary *delInfo = nil;
        for (NSMutableDictionary *info in _groupFinshCallBackList) {
            NSString *grp = (NSString *)[info valueForKey:@"groupId"];
            if ([grp isEqualToString:groupId]) {
                delInfo = info;
                break;
            }
        }
        if (delInfo) {
            [_groupFinshCallBackList removeObject:delInfo];
        }
    }
}

- (void)startConcurrnetTaskForGroup:(nonnull NSString *)groupId {
    
#ifdef YSConvenienceThreadEnableLog
    Tlog(@"YSConcurrentTask group count: %ld", _groupList.count);
#endif
    if (groupId == nil) {
        return;
    }
    if (groupId.length == 0) {
        groupId = @"None";
    }
    // 寻找待执行的分组
    NSMutableDictionary *taskInfo = nil;
    @synchronized (_groupList) {
        for (NSMutableDictionary *info in _groupList) {
            NSString *grp = (NSString *)[info valueForKey:@"groupId"];
            if ([grp isEqualToString:groupId]) {
                taskInfo = info;
                break;
            }
        }
        [_groupList removeObject:taskInfo];
    }
    
    NSArray *taskList = [taskInfo valueForKey:@"taskList"];
    dispatch_group_t group = dispatch_group_create();
    
    // 寻找分组完成回调
    void(^callBack)(void) = NULL;
    BOOL callBackIsInMainThread = true;
    @synchronized (_groupFinshCallBackList) {
        NSMutableDictionary *callBackInfo = nil;
        for (NSMutableDictionary *info in _groupFinshCallBackList) {
            NSString *grp = (NSString *)[info valueForKey:@"groupId"];
            if ([grp isEqualToString:groupId]) {
                callBack = [info valueForKey:@"callBack"];
                callBackIsInMainThread = [[info valueForKey:@"callBackThread"] boolValue];
                callBackInfo = info;
                break;
            }
        }
        if (callBackInfo) {
            [_groupFinshCallBackList removeObject:callBackInfo];
        }
    }
    // 执行分组内任务
#ifdef YSConvenienceThreadEnableLog
    NSInteger index = 0;
    NSInteger groupTaskTotal = taskList.count;
    CFAbsoluteTime groupStartTime = CFAbsoluteTimeGetCurrent();
#endif
    for (YSActionTaskBlock actionBlock in taskList) {
#ifdef YSConvenienceThreadEnableLog
        index += 1;
#endif
        dispatch_group_enter(group);
        dispatch_async(_concurrentQueue, ^{
#ifdef YSConvenienceThreadEnableLog
            Tlog(@"YSConcurrentTask begin run group[%@] task: %ld/%ld", groupId, index, groupTaskTotal);
            CFAbsoluteTime taskStartTime = CFAbsoluteTimeGetCurrent();
#endif
            void(^finshBlock)(void) = ^{
                dispatch_group_leave(group);
#ifdef YSConvenienceThreadEnableLog
                CFAbsoluteTime taskLinkTime = (CFAbsoluteTimeGetCurrent() - taskStartTime);
                Tlog(@"YSConcurrentTask group[%@] task[%ld] costTime %.3f", groupId, index, taskLinkTime);
#endif
            };
            actionBlock(finshBlock);
        });
    }

#ifdef YSConvenienceThreadEnableLog
    __weak typeof(self) weakSelf = self;
#endif
    dispatch_queue_t callBackQueue = (callBackIsInMainThread ? dispatch_get_main_queue() : _concurrentQueue);
    if (!taskInfo) {
        dispatch_async(callBackQueue, ^{
#ifdef YSConvenienceThreadEnableLog
            __strong typeof(self) self = weakSelf;
            CFAbsoluteTime linkTime = (CFAbsoluteTimeGetCurrent() - groupStartTime);
            Tlog(@"YSConcurrentTask groupId[%@] finsh %.3f, left group count: %ld", groupId, linkTime, self->_groupList.count);
#endif
            if (callBack) {
                callBack();
            }
        });
    } else {
        dispatch_group_notify(group, callBackQueue, ^{
#ifdef YSConvenienceThreadEnableLog
            __strong typeof(self) self = weakSelf;
            CFAbsoluteTime linkTime = (CFAbsoluteTimeGetCurrent() - groupStartTime);
            Tlog(@"YSConcurrentTask groupId[%@] finsh %.3f, left group count: %ld", groupId, linkTime, self->_groupList.count);
#endif
            if (callBack) {
                callBack();
            }
        });
    }
}

#pragma mark - incident
#pragma mark - private
- (void)prepare {
    
    _delegatesList = [NSHashTable weakObjectsHashTable];
    
    // observe mainrunloop
    [self addObserveForMainRunloop];
    
    // shadowThread
    _shadowThread = [[NSThread alloc] initWithTarget:self selector:@selector(shadowThreadRun) object:nil];
    _shadowThread.name = kShadowThreadName;
    [_shadowThread start];
    
    // drop
    dispatch_queue_attr_t dropQueueAttr = dispatch_queue_attr_make_with_qos_class(DISPATCH_QUEUE_SERIAL, QOS_CLASS_UTILITY, -1);
    _dropQueue = dispatch_queue_create(kDropQueueName, dropQueueAttr);
    
    // serial
    dispatch_queue_attr_t seriakQueueAttr = dispatch_queue_attr_make_with_qos_class(DISPATCH_QUEUE_SERIAL, QOS_CLASS_DEFAULT, -1);
    _serialQueue = dispatch_queue_create(kSerialQueueName, seriakQueueAttr);
    
    // concurrent
    _groupList = [NSMutableArray array];
    _groupFinshCallBackList = [NSMutableArray array];
    dispatch_queue_attr_t concurrentQueueAttr = dispatch_queue_attr_make_with_qos_class(DISPATCH_QUEUE_CONCURRENT, QOS_CLASS_DEFAULT, -1);
    _concurrentQueue = dispatch_queue_create(kConcurrentQueueName, concurrentQueueAttr);
}

#pragma mark - shadowThread && mainRunloop

- (void)shadowThreadRun {
    
    [NSThread addAutoreleasePoolToCurrentRunloop];
    
    @autoreleasepool {
        NSRunLoop *runloop = [NSRunLoop currentRunLoop];
        [runloop addPort:[NSMachPort port] forMode:NSDefaultRunLoopMode];
        [runloop run];
    }
}

- (void)addObserveForMainRunloop {
    
    CFRunLoopRef runloop = CFRunLoopGetMain();
    CFRunLoopObserverRef observe = CFRunLoopObserverCreate(CFAllocatorGetDefault(),
                                                           kCFRunLoopAllActivities,
                                                           true,
                                                           0x7FFFFFFF,
                                                           RunloopObserverCallBack,
                                                           NULL);
    CFRunLoopAddObserver(runloop, observe, kCFRunLoopCommonModes);
    CFRelease(observe);
}

static void RunloopObserverCallBack(CFRunLoopObserverRef observer, CFRunLoopActivity activity, void *info) {
    
    YSConvenienceThread *thread = [YSConvenienceThread convenienceThread];
    [thread notifyDelegatesRunloopActivity:activity];
}

- (void)notifyDelegatesRunloopActivity:(CFRunLoopActivity)activity {
    
    for (id<YSMainRunloopActivityDelegate> delegate in _delegatesList) {
        if (delegate && [delegate respondsToSelector:@selector(mainRunloop:activity:)]) {
            [delegate mainRunloop:[NSRunLoop mainRunLoop] activity:activity];
        }
    }
}

#pragma mark - timerThread && timer

- (void)heartThreadRun {
    
    _timer = [[NSTimer alloc] initWithFireDate:[NSDate date] interval:1.0 target:self selector:@selector(timerRun) userInfo:nil repeats:true];
    
    @autoreleasepool {
        NSRunLoop *runloop = [NSRunLoop currentRunLoop];
        [runloop addPort:[NSMachPort port] forMode:NSDefaultRunLoopMode];
        [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
        [runloop run];
    }
}

- (void)timerRun {
    
    [self performSelector:@selector(postHeartNotificatoonInMainThread) onThread:[NSThread mainThread] withObject:nil waitUntilDone:false];
    [self performSelector:@selector(postHeartNotificatoonUnMainThread) onThread:_heartThread withObject:nil waitUntilDone:false];
}

- (void)postHeartNotificatoonInMainThread {
    
    [[NSNotificationCenter defaultCenter] postNotificationName:HeartBeatNotificationInMainThread object:nil];
}

- (void)postHeartNotificatoonUnMainThread {
    
    [[NSNotificationCenter defaultCenter] postNotificationName:HeartBeatNotificationUnMainThread object:nil];
}
#pragma mark - delegate
#pragma mark - getter/setter

@end
