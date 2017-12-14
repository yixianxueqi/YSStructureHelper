//
//  UIApplication+NetworkStatus.h
//  YSStructureHelperDemo
//
//  Created by 君若见故 on 2017/12/12.
//  Copyright © 2017年 develop. All rights reserved.
//

#import <UIKit/UIKit.h>

/*
     网络监测类别 UIApplication+NetworkStatus
     当前网络状态归app所有，因此将相关网络状态检测方法及属性以类别的形式添加至UIApplication下，
     可以在app全局内通过[[UIApplication sharedApplication] currentStatus]访问到网络状态相关
     网络状态主要依赖三方：AFNetworking，Reachability
     网络状态以AFNetworking状态为原本，Reachability主要为检测是否可访问指定地址之用
     详情使用可见YSNetworkDemoViewController.m
 */

//网络状态
typedef NS_ENUM(NSInteger, YSNetworkStatus) {
    NetworkStatusUnknown = 1,
    NetworkStatusNotReachable = 2,
    NetworkStatusReachableViaWWAN = 3,
    NetworkStatusReachableViaWiFi = 4,
};

//网络状态变化通知,可监听此通知获取网络状态实时变化
//结果存在于通知userinfo的YSNetworkStatusItem字段内，其value值为number
//类似于此：@{YSNetworkStatusItem: @(YSNetworkStatus)}
extern NSString * const YSNetworkStatusChangedNotification;
extern NSString * const YSNetworkStatusItem;
/**
 监听网络状态变化类
 */
@interface UIApplication (NetworkStatus)

//获取当前网络状态
@property (nonatomic, assign, readonly) YSNetworkStatus currentStatus;


/**
 当前网络是否可用

 @return BOOL
 */
- (BOOL)reachable;

/**
 开始监听网络状态变化
 */
- (void)startListenNetworkStatus;

/**
 停止监听网络状态变化
 */
- (void)stopListenNetworkStatus;


/**
 检测网络是否能访问指定地址

 @param hostName 地址
 @param successBlock 成功回调
 @param failureBlock 失败回调
 */
- (void)isReachableHostname:(NSString *)hostName
               successBlock:(nonnull void(^)(void))successBlock
               failureBlock:(nonnull void(^)(void))failureBlock;

@end
