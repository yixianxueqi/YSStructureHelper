//
//  YSFPSMonitor.h
//  YSStructureHelperDemo
//
//  Created by 君若见故 on 2018/3/9.
//  Copyright © 2018年 develop. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 屏幕刷新FPS监测，方案来自YYKit-Demo中
 */
@interface YSFPSMonitor : NSObject

+ (instancetype)defaultFPSMonitor;

- (void)start;
- (void)stop;
@end
