//
//  YSNetworkFailureHandle.h
//  YSStructureHelperDemo
//
//  Created by 君若见故 on 2017/12/13.
//  Copyright © 2017年 develop. All rights reserved.
//

#import <Foundation/Foundation.h>


/**
 网络错误处理
 针对网络请求失败的原因进行本地化描述
 */
@interface YSNetworkFailureHandle : NSObject


/**
 错误转换
 将原生错误装换为自定义错误，利于业务处理
 @param error 待转换错误
 @return NSError *
 */
+ (NSError *)handleNetworkFailure:(NSError *)error;

@end
