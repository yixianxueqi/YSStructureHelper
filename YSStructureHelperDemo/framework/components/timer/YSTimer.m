//
//  YSTimer.m
//  YSStructureHelperDemo
//
//  Created by Nigel on 2018/6/27.
//  Copyright © 2018年 develop. All rights reserved.
//

#import "YSTimer.h"

@interface YSTimer()

@property (nonatomic,strong) dispatch_queue_t queue;
@property (nonatomic,strong) dispatch_source_t timer;

@end

@implementation YSTimer

- (void)setSpaceSeconds:(NSTimeInterval)seconds isMainThread:(BOOL)isMain incident:(TimerIncident)incident {
    
    if (isMain) {
        self.queue = dispatch_get_main_queue();
    } else {
        self.queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    }
    self.timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, self.queue);
    dispatch_source_set_timer(self.timer, DISPATCH_TIME_NOW, seconds * NSEC_PER_SEC, 1 * NSEC_PER_SEC);
    dispatch_source_set_event_handler(self.timer, ^{
        incident(self);
    });
    dispatch_resume(self.timer);
}

- (void)setDelaySeconds:(NSTimeInterval)seconds isMainThread:(BOOL)isMain incident:(nonnull TimerIncident)incident {
    
    if (isMain) {
        self.queue = dispatch_get_main_queue();
    } else {
        self.queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    }
    self.timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, self.queue);
    dispatch_source_set_timer(self.timer, dispatch_time(seconds, 0), DISPATCH_TIME_FOREVER, 1 * NSEC_PER_SEC);
    dispatch_source_set_event_handler(self.timer, ^{
        incident(self);
    });
    dispatch_resume(self.timer);
}

- (void)cancelTimer:(TimerIncident)incident {
    
    if (self.timer) {
        dispatch_source_set_cancel_handler(self.timer, ^{
            if (incident) {
                incident(self);
            }
        });
        dispatch_cancel(self.timer);
    }
}

- (void)dealloc {
    
    NSLog(@"%@ dealloc", NSStringFromClass(self.class));
}

@end
