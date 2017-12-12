//
//  AppDelegate+DefineService.h
//  YSStructureHelperDemo
//
//  Created by 君若见故 on 2017/12/6.
//  Copyright © 2017年 develop. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate (DefineService)

//设置视图结构
- (void)customVCHierachy;

/**
 启动日志组件
 */
- (void)startLogger;

/**
 启动网络状态监听
 */
- (void)listenNetworkStatus;

@end
