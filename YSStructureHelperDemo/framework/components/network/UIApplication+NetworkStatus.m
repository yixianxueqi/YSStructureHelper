//
//  UIApplication+NetworkStatus.m
//  YSStructureHelperDemo
//
//  Created by 君若见故 on 2017/12/12.
//  Copyright © 2017年 develop. All rights reserved.
//

#import "UIApplication+NetworkStatus.h"
#import <AFNetworking/AFNetworking.h>
#import <Reachability/Reachability.h>
#import <objc/runtime.h>

NSString * const YSNetworkStatusChangedNotification = @"YSNetworkStatusChangedNotification";
NSString * const YSNetworkStatusItem = @"YSNetworkStatusItem";

@interface UIApplication()

//获取当前网络状态
@property (nonatomic, assign, readwrite) YSNetworkStatus currentStatus;

@end

@implementation UIApplication (NetworkStatus)

#pragma mark - public

- (BOOL)reachable {
    return [[AFNetworkReachabilityManager sharedManager] isReachable];
}

- (void)startListenNetworkStatus {

    __weak typeof(self) weakSelf = self;
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        __strong __typeof(self) strongSelf = weakSelf;
        switch (status) {
            case AFNetworkReachabilityStatusUnknown:
                strongSelf.currentStatus = NetworkStatusUnknown;
                break;
            case AFNetworkReachabilityStatusNotReachable:
                strongSelf.currentStatus = NetworkStatusNotReachable;
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN:
                strongSelf.currentStatus = NetworkStatusReachableViaWWAN;
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi:
                strongSelf.currentStatus = NetworkStatusReachableViaWiFi;
                break;
        }
    }];
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
}

- (void)stopListenNetworkStatus {

    [[AFNetworkReachabilityManager sharedManager] stopMonitoring];
}

- (void)isReachableHostname:(NSString *)hostName
               successBlock:(nonnull void (^)(void))successBlock
               failureBlock:(nonnull void (^)(void))failureBlock {

    Reachability *reach = [Reachability reachabilityWithHostname: hostName];
    reach.reachableBlock = ^(Reachability *reachability) {
        dispatch_async(dispatch_get_main_queue(), ^{
            successBlock();
        });
    };
    reach.unreachableBlock = ^(Reachability *reachability) {
        dispatch_async(dispatch_get_main_queue(), ^{
            failureBlock();
        });
    };
    [reach startNotifier];
}

#pragma makr - getter/setter
- (YSNetworkStatus)currentStatus {

    NSNumber *number = objc_getAssociatedObject(self, _cmd);
    return (YSNetworkStatus)number.integerValue;
}

- (void)setCurrentStatus:(YSNetworkStatus)currentStatus {

    objc_setAssociatedObject(self, @selector(currentStatus), @(currentStatus), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [[NSNotificationCenter defaultCenter] postNotificationName:YSNetworkStatusChangedNotification object:self userInfo:@{YSNetworkStatusItem: @(self.currentStatus)}];
}

@end
