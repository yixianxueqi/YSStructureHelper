//
//  YSThreadDemoViewController.m
//  YSStructureHelperDemo
//
//  Created by Lola001 on 2019/12/30.
//  Copyright © 2019 develop. All rights reserved.
//

#import "YSThreadDemoViewController.h"
#import "YSConvenienceThread.h"

@interface YSThreadDemoViewController ()<YSMainRunloopActivityDelegate>

@end

@implementation YSThreadDemoViewController

#pragma mark - lifeCycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"线程相关";
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self testThread];
}

#pragma mark - public
#pragma mark - incident
#pragma mark - private
- (void)testThread {
    
    YSConvenienceThread *thread = [YSConvenienceThread convenienceThread];
    [thread addMainRunloopDelegate:self];
    [thread startHeartBeat];
    
    __block UIView *view = [[UIView alloc] init];
    [thread droptThread:^{
        view = nil;
        log_debug(@"drop...");
    }];
    
    [self performSelector:@selector(runTaskInShadowThread:) onThread:[thread shadowThread] withObject:@(1000000) waitUntilDone:false];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:HeartBeatNotificationInMainThread object:nil queue:nil usingBlock:^(NSNotification * _Nonnull note) {
        log_debug(@"heart: %@,【%d】", [NSThread currentThread], [NSThread isMainThread]);
    }];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:HeartBeatNotificationUnMainThread object:nil queue:nil usingBlock:^(NSNotification * _Nonnull note) {
        log_debug(@"heart: %@,【%d】", [NSThread currentThread], [NSThread isMainThread]);
    }];
    
    for (int i = 0; i < 10; i++) {
        [thread addSerialTask:^(void (^finshBlock)(void)) {
            log_debug(@"serial task: %d, %@", i, [NSThread currentThread]);
            sleep(1.0);
            if (finshBlock) {
                finshBlock();
            }
        }];
    }
    
    [thread addConcurrentTask:^{
        log_debug(@"concurrent task ....");
    }];
    
    // group1
    __weak typeof(thread) weakThread = thread;
    [thread addConcurrentTaskInGroup:@"1" task:^(YSFinshBlock finshBlock) {
        sleep(2.0);
        log_debug(@"concurrent group 1 task 1...%@", [NSThread currentThread]);
        finshBlock();
    }];
    [thread addConcurrentTaskInGroup:@"1" task:^(YSFinshBlock finshBlock) {
        sleep(5.0);
        log_debug(@"concurrent group 1 task 2...%@", [NSThread currentThread]);
        finshBlock();
    }];
    [thread addConcurrentTaskInGroup:@"1" task:^(YSFinshBlock finshBlock) {
        log_debug(@"concurrent group 1 task 3...%@", [NSThread currentThread]);
        sleep(2.0);
        finshBlock();
    }];
    
    //group2
    [thread addConcurrentTaskInGroup:@"2" task:^(YSFinshBlock finshBlock) {
        sleep(2.0);
        log_debug(@"concurrent group 2 task 1...%@", [NSThread currentThread]);
        finshBlock();
    }];
    [thread addConcurrentTaskInGroup:@"2" task:^(YSFinshBlock finshBlock) {
        sleep(3.0);
        log_debug(@"concurrent group 2 task 2...%@", [NSThread currentThread]);
        finshBlock();
    }];
    
    //group3
    [thread addConcurrentTaskInGroup:@"3" task:^(YSFinshBlock finshBlock) {
        sleep(2.0);
        log_debug(@"concurrent group 3 task 1...%@", [NSThread currentThread]);
        finshBlock();
    }];
    [thread addConcurrentTaskInGroup:@"3" task:^(YSFinshBlock finshBlock) {
        sleep(3.0);
        log_debug(@"concurrent group 3 task 2...%@", [NSThread currentThread]);
        finshBlock();
    }];
    
    
    [thread addConcurrentTaskCallbackforGroupId:@"3" inMainThread:false finsh:^{
        log_debug(@"concurrent group 3 finsh...%@", [NSThread currentThread]);
    }];
    [thread addConcurrentTaskCallbackforGroupId:@"2" inMainThread:false finsh:^{
        log_debug(@"concurrent group 2 finsh...%@", [NSThread currentThread]);
        [weakThread startConcurrnetTaskForGroup:@"3"];
    }];
    [thread addConcurrentTaskCallbackforGroupId:@"1" inMainThread:false finsh:^{
        log_debug(@"concurrent group 1 finsh...%@", [NSThread currentThread]);
        [weakThread startConcurrnetTaskForGroup:@"2"];
    }];
    [thread startConcurrnetTaskForGroup:@"1"];
}

- (void)runTaskInShadowThread:(NSNumber *)count {
    
    log_debug(@"--*-- start --*--" );
    for (int i = 0; i < [count integerValue]; i++) {
        @autoreleasepool {
            NSMutableArray *arr = [NSMutableArray array];
            [arr count];
        }
    }
    log_debug(@"--*-- end --*--" );
}

#pragma mark - YSMainRunloopActivityDelegate
- (void)mainRunloop:(NSRunLoop *)runloop activity:(CFRunLoopActivity)activity {
    
//    log_debug(@"main runloop activity: %lu, 【%d】", activity, [NSThread isMainThread]);
}

#pragma mark - getter/setter

@end
