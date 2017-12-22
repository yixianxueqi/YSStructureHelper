//
//  UIDevice+Info.h
//  YSStructureHelperDemo
//
//  Created by 君若见故 on 2017/12/20.
//  Copyright © 2017年 develop. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIDevice (Info)

/**
 *  获取app名称
 *
 *  @return NSString *
 */
+ (NSString *)appName;

/**
 *  获取Bundle Identifier
 *
 *  @return NSString *
 */
+ (NSString *)bundleIdentifier;

/**
 *  获取app版本
 *
 *  @return NSString *
 */
+ (NSString *)appVersion;

/**
 *  获取appBuild版本
 *
 *  @return NSString *
 */
+ (NSString *)appBuildVersion;

/**
 *  获取设备序列号
 *
 *  @notice: 删除应用重装，系统升级，系统还原，系统重刷 会变
 *  @return NSString *
 */
+ (NSString *)deviceSerialNum;

/**
 *  获取设备唯一标识
 *
 *  @return NSString *
 */
+ (NSString *)uuid;

/**
 *  获取手机别名
 *
 *  @notice 用户给设备自定义名称
 *  @return NSString *
 */
+ (NSString *)deviceNameDefineByUser;

/**
 *  获取设备名称
 *
 *  @return NSString *
 */
+ (NSString *)deviceName;

/**
 *  获取设备系统版本
 *
 *  @return NSString *
 */
+ (NSString *)deviceSystemVersion;

/**
 *  获取设备型号
 *
 *  @return NSString *
 */
+ (NSString *)deviceModel;

/**
 *  获取设备区域型号
 *
 *  @return NSString *
 */
+ (NSString *)deviceLocalModel;

/**
 *  获取运营商信息
 *
 *  @return NSString *
 */
+ (NSString *)operatorInfo;

/**
 *  获取电池状态
 *
 *  @return UIDeviceBatteryState *
 */
+ (UIDeviceBatteryState)batteryState;

/**
 *  获取电量等级
 *
 *  @notice 0 ~ 1.0
 *  @return CGFloat
 */
+ (CGFloat)batteryLevel;

/**
 获取当前设备IP

 @return NSString *
 */
+ (NSString *)getDeviceIPAdress;

/**
 获取总内存大小

 @return long long
 */
+ (long long)getTotalMemorySize;


/**
 获取当前可用内存

 @return long long
 */
+ (long long)getAvailableMemorySize;

/**
 获取精准电池电量

 @return CGFloat
 */
+ (CGFloat)getCurrentBatteryLevel;

@end
