//
//  YSTimer.h
//  YSStructureHelperDemo
//
//  Created by Nigel on 2018/6/27.
//  Copyright © 2018年 develop. All rights reserved.
//

#import <Foundation/Foundation.h>
@class YSTimer;

typedef void(^TimerIncident)(YSTimer *timer);

@interface YSTimer : NSObject

/**
 GCD定时器

 @param seconds 间隔时间
 @param isMain 是否在主线程
 @param incident 回调
 */
- (void)setSpaceSeconds:(NSTimeInterval)seconds isMainThread:(BOOL)isMain incident:(nonnull TimerIncident)incident;

/**
 取消GCD定时器

 @param incident 取消完成回调
 */
- (void)cancelTimer:(nullable TimerIncident)incident;

@end
