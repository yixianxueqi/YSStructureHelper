//
//  UIApplication+Info.h
//  YSStructureHelperDemo
//
//  Created by Nigel on 2018/6/26.
//  Copyright © 2018年 develop. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIApplication (Info)

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


@end
