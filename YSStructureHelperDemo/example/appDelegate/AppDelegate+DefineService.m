//
//  AppDelegate+DefineService.m
//  YSStructureHelperDemo
//
//  Created by 君若见故 on 2017/12/6.
//  Copyright © 2017年 develop. All rights reserved.
//

#import "AppDelegate+DefineService.h"
#import "YSNavViewController.h"
#import "ViewController.h"
#import "YSLogger.h"
#import "YSFPSMonitor.h"

@interface AppDelegate()<YSLoggerRollFileDelegate>

@end

@implementation AppDelegate (DefineService)

- (void)customVCHierachy {

    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    YSNavViewController *navVC = [[YSNavViewController alloc] initWithRootViewController:[[ViewController alloc] init]];
    self.window.rootViewController = navVC;
    [self.window makeKeyAndVisible];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
}

#pragma mark - logger
- (void)startLogger {

    YSLogger *logger = [YSLogger shareLogger];
    [YSLogger setFileLogLevel: ddLogLevel];
    logger.delegate = self;
}

- (void)getRollLogFileDidArchivePath:(NSString *)path {
    //获取抛出的日志文件，可在此处理
    log_info(@"roll: %@",path);
}

#pragma mark - network status
- (void)listenNetworkStatus {
    [[UIApplication sharedApplication] startListenNetworkStatus];
}

- (void)startFPSMonitor {
    
    [[YSFPSMonitor defaultFPSMonitor] start];
}

@end
