//
//  YSNetworkDemoViewController.m
//  YSStructureHelperDemo
//
//  Created by 君若见故 on 2017/12/12.
//  Copyright © 2017年 develop. All rights reserved.
//

#import "YSNetworkDemoViewController.h"

@interface YSNetworkDemoViewController ()

@end

@implementation YSNetworkDemoViewController

#pragma mark - lifeCycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"网络";
    self.view.backgroundColor = [UIColor whiteColor];
    //注册网络监听通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(networkStatusChangedNotificationHandle:) name:YSNetworkStatusChangedNotification object:nil];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    //app刚启动就检测网络会是默认值，在一定间隔后才准确获取
    //或者可以延时启动网络监测
    //本demo放在app一启动就检测网络状态
    log_info(@"network Reachable: %d", [[UIApplication sharedApplication] reachable]);
    log_info(@"network status: %ld", (long)[[UIApplication sharedApplication] currentStatus]);
    //检测是否可以访问指定域名
    __weak typeof(self) weakSelf = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [[UIApplication sharedApplication] isReachableHostname:@"www.baidu.com" successBlock:^{
            __strong __typeof(self) strongSelf = weakSelf;
            log_debug(@"可以访问到www.baidu.com");
            [strongSelf.view showAutoHideAlertMsg:@"可以访问到www.baidu.com"];
        } failureBlock:^{
            __strong __typeof(self) strongSelf = weakSelf;
            log_debug(@"无法访问到www.baidu.com,请检查网络链接");
            [strongSelf.view showAutoHideAlertMsg:@"无法访问到www.baidu.com,请检查网络链接"];
        }];
    });

    [self.view showAutoHideAlertMsg:[NSString stringWithFormat:@"%@",[self networkStatusDescripton:[[UIApplication sharedApplication] currentStatus]]]];
}

-(void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:YSNetworkStatusChangedNotification object:nil];
}

#pragma mark - public
#pragma mark - incident
//网络变化通知处理
- (void)networkStatusChangedNotificationHandle:(NSNotification *)notify {

    log_info(@"network status change notification: %@",notify);
    YSNetworkStatus status = (YSNetworkStatus)((NSNumber *)notify.userInfo[YSNetworkStatusItem]).integerValue;
    [self.view showAutoHideAlertMsg:[self networkStatusDescripton:status]];
}

#pragma mark - private

//网络切换描述
- (NSString *)networkStatusDescripton: (YSNetworkStatus)status {

    NSString *desc = @"";
    switch (status) {
        case NetworkStatusUnknown:
            desc = @"未知网络";
            break;
        case NetworkStatusNotReachable:
            desc = @"网络不可用";
            break;
        case NetworkStatusReachableViaWWAN:
            desc = @"运营商网络";
            break;
        case NetworkStatusReachableViaWiFi:
            desc = @"WiFi环境";
            break;
    }
    return desc;
}
#pragma mark - delegate
#pragma mark - getter/setter

@end
