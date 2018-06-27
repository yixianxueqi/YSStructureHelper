//
//  YSGCDGroup.h
//  YSStructureHelperDemo
//
//  Created by Nigel on 2018/6/27.
//  Copyright © 2018年 develop. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^DispatchGroupTask)(void);

@interface YSGCDGroup : NSObject


/**
 进入群组，和leaveGroup成对出现。
 @note 是对dispatch_group_enter的封装。
       常用于异步任务。
 */
- (void)enterGroup;

/**
 离开群组，和enterGroup成对出现。
 @note 是对dispatch_group_leave的封装。
       常用与异步任务。
 */
- (void)leaveGroup;

/**
 group添加任务处理

 @param task 任务
 */
- (void)doAsyncTask:(nonnull DispatchGroupTask)task;

/**
 等待，在指定时间后回调。会阻塞当前线程。
 @note 在指定时间间隔回调,finsh为false代表群组任务尚未完成；finsh为true代表群组任务完成。
       已将会导致所处线程阻塞的wait放入dispatch_get_global_queue内。
       该方法是对于dispatch_group_wait封装。
 @param seconds 等待时间，小于0则代表一直等到任务完成
 @param task 等待结束回调
 */
- (void)waitTimeUntil:(NSTimeInterval)seconds finsh:(void(^)(BOOL isFinsh))task;

/**
 完成回调
 @note  是对于dispatch_group_notify方法的封装。
 @param isMain 是否回调在主线程
 @param task 完成回调
 */
- (void)compltionInMainQueue:(BOOL)isMain taks:(nonnull DispatchGroupTask)task;

@end
