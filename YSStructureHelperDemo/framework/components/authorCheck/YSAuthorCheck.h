//
//  YSAuthorCheck.h
//  YSStructureHelperDemo
//
//  Created by Nigel on 2018/6/27.
//  Copyright © 2018年 develop. All rights reserved.
//

#import <Foundation/Foundation.h>

// 权限类型
typedef NS_ENUM(NSUInteger, YSDeviceAuthorType) {
    YSDeviceAuthorType_unknown = 1,  //未询问
    YSDeviceAuthorType_denied,      //被拒绝
    YSDeviceAuthorType_allow,       //允许
    YSDeviceAuthorType_notSupport   //设备不支持
};

/**
 权限检查及请求权限
 */
@interface YSAuthorCheck : NSObject

#pragma mark - 相机

+ (YSDeviceAuthorType)checkCameraAuthor;
+ (void)requestCameraAuthor;
+ (void)gotoAuthorSettings;

@end
