//
//  YSGCDGroup.m
//  YSStructureHelperDemo
//
//  Created by Nigel on 2018/6/27.
//  Copyright © 2018年 develop. All rights reserved.
//

#import "YSGCDGroup.h"

@interface YSGCDGroup()

@property (nonatomic,strong) dispatch_queue_t globalQueue;
@property (nonatomic,strong) dispatch_queue_t mainQueue;
@property (nonatomic,strong) dispatch_group_t group;

@end

@implementation YSGCDGroup

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.globalQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        self.mainQueue = dispatch_get_main_queue();
        self.group = dispatch_group_create();
    }
    return self;
}

- (void)enterGroup {
    
    dispatch_group_enter(self.group);
}

- (void)leaveGroup {
    
    dispatch_group_leave(self.group);
}

- (void)doAsyncTask:(nonnull DispatchGroupTask)task {
    
    dispatch_group_async(self.group, self.globalQueue, ^{
        task();
    });
}

- (void)waitTimeUntil:(NSTimeInterval)seconds finsh:(void(^)(BOOL isFinsh))task {
    
    dispatch_time_t time;
    if (seconds <= 0.0) {
        time = DISPATCH_TIME_FOREVER;
    } else {
        time = dispatch_time(DISPATCH_TIME_NOW, seconds * NSEC_PER_SEC);
    }
    dispatch_async(self.globalQueue, ^{
        long result = dispatch_group_wait(self.group, time);
        if (task) {
            task(!result);
        }
    });
}

- (void)compltionInMainQueue:(BOOL)isMain taks:(nonnull DispatchGroupTask)task {
    
    dispatch_queue_t targetQueue = isMain ? self.mainQueue : self.globalQueue;
    dispatch_group_notify(self.group, targetQueue, ^{
        task();
    });
}

- (void)dealloc {
    
    NSLog(@"%@ dealloc", NSStringFromClass(self.class));
}

@end
