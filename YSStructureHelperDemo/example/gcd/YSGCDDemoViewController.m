//
//  YSGCDDemoViewController.m
//  YSStructureHelperDemo
//
//  Created by Nigel on 2018/6/27.
//  Copyright © 2018年 develop. All rights reserved.
//

#import "YSGCDDemoViewController.h"
#import "YSTimer.h"
#import "YSGCDGroup.h"

@interface YSGCDDemoViewController ()

@end

@implementation YSGCDDemoViewController

#pragma mark - lifeCycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"GCD相关";
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    // 测试定时器
    [self testTimer];
    // 测试group异步任务
    [self testAsyncGroupNotify];
    // 测试group同步任务
//    [self testSyncGroupNotify];
    // 测试group等待处理
//    [self testGroupWait];
}

#pragma mark - public
#pragma mark - http
#pragma mark - incident
#pragma mark - private

// 测试定时器
- (void)testTimer {
    
    __block NSInteger count = 0;
    [[[YSTimer alloc] init] setSpaceSeconds:1.0 isMainThread:false incident:^(YSTimer *timer) {
        log_debug(@"timer %ld", (long)count);
        count += 1;
        if (count > 10) {
            [timer cancelTimer:^(YSTimer *timer) {
                log_debug(@"cancel timer");
            }];
        }
    }];
}

// 测试group异步任务
- (void)testAsyncGroupNotify {
    
    YSGCDGroup *group = [[YSGCDGroup alloc] init];
    [group doAsyncTask:^{
        sleep(5);
        log_debug(@"task 1");
        [group enterGroup];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            sleep(5);
            log_debug(@"http 1");
            [group leaveGroup];
        });
    }];
    
    [group doAsyncTask:^{
        sleep(10);
        log_debug(@"task 2");
        [group enterGroup];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            sleep(5);
            log_debug(@"http 2");
            [group leaveGroup];
        });
    }];
    [group compltionInMainQueue:true taks:^{
        log_debug(@"completion");
    }];
}

// 测试group同步任务
- (void)testSyncGroupNotify {
    
    YSGCDGroup *group = [[YSGCDGroup alloc] init];
    [group doAsyncTask:^{
        sleep(5);
        log_debug(@"task 1");
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            sleep(5);
            log_debug(@"http 1");
        });
    }];
    
    [group doAsyncTask:^{
        sleep(10);
        log_debug(@"task 2");
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            sleep(5);
            log_debug(@"http 2");
        });
    }];
    [group compltionInMainQueue:true taks:^{
        log_debug(@"completion");
    }];
}

// 测试group等待处理
- (void)testGroupWait {
    
    YSGCDGroup *group = [[YSGCDGroup alloc] init];
    [group doAsyncTask:^{
        sleep(5);
        log_debug(@"task 1");
        [group enterGroup];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            sleep(5);
            log_debug(@"http 1");
            [group leaveGroup];
        });
    }];
    
    [group doAsyncTask:^{
        sleep(10);
        log_debug(@"task 2");
        [group enterGroup];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            sleep(5);
            log_debug(@"http 2");
            [group leaveGroup];
        });
    }];
    
    [group waitTimeUntil:3.0 finsh:^(BOOL isFinsh) {
        log_debug(@"wait, %d", isFinsh);
    }];
    log_debug(@"end");
}

#pragma mark - delegate
#pragma mark - getter/setter

@end
